Return-Path: <linux-kernel-owner+w=401wt.eu-S1030403AbXDJWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbXDJWal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030591AbXDJWak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:30:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55345 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030403AbXDJWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:30:39 -0400
Message-ID: <461C0F76.1070308@vmware.com>
Date: Tue, 10 Apr 2007 15:28:06 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org> <461C084C.9020009@vmware.com> <461C0CB4.9000407@goop.org>
In-Reply-To: <461C0CB4.9000407@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Why not submit a patch to do what you need here?  (The Geode comment is
> a bit worrying though.)
>   

Why should VMI add workaround into PIT code?  PIT code wants to know 
nothing about VMI.  It understands PIT timers on hardware.  VMI, on the 
other hand, is special - it knows exactly what hardware platform it has 
and can manipulate hardware freely.  On a generic platform, surely touch 
PIT I/O ports would be quite ill behavior.  But side effects of that on 
a vastly restricted platform are predictable based on the hardware and 
kernel, and we would not add a workaround outside of VMI unless it was 
really necessary or generally useful.

Zach
