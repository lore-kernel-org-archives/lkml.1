Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbXCJKcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbXCJKcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXCJKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:32:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33254 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbXCJKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:32:40 -0500
Message-ID: <45F28947.30406@vmware.com>
Date: Sat, 10 Mar 2007 02:32:39 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: PATCH: Fix VMI and COMPAT_VDSO for 2.6.21
References: <45F2578E.3060907@vmware.com> <45F257C1.4070904@vmware.com> <20070310084750.GA15647@elte.hu>
In-Reply-To: <20070310084750.GA15647@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> makes sense. We can do Jan's relocatable-COMPAT_VDSO thing in v2.6.22, 
> but for v2.6.21 that's way too intrusive.
>   

Agree.  I think we can clean up some of the strange build magic though, 
by adding boot time ELF magic instead.  We'll see which works out better.

Zach
