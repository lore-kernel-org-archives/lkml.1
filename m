Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXDJWkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXDJWkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030616AbXDJWkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:40:07 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39036 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030682AbXDJWkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:40:03 -0400
Date: Tue, 10 Apr 2007 15:38:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
Message-ID: <20070410223812.GT10574@sequoia.sous-sol.org>
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org> <461C084C.9020009@vmware.com> <461C0CB4.9000407@goop.org> <461C0F76.1070308@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461C0F76.1070308@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> Jeremy Fitzhardinge wrote:
> >Why not submit a patch to do what you need here?  (The Geode comment is
> >a bit worrying though.)
> 
> Why should VMI add workaround into PIT code?

I'm not sure it's a workaround, seems more like a subtle diff (perhaps
it's just an oversight).  I need to rectify it anyway when merging in
the x86_64 version.  It's the way the x86_64 code is working already.
Shutdown for most clockevents tells device to stop ticking.
