Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbXK0RGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbXK0RGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbXK0RGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:06:39 -0500
Received: from gw.goop.org ([64.81.55.164]:59305 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbXK0RGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:06:39 -0500
Message-ID: <474C4EA0.6090407@goop.org>
Date: Tue, 27 Nov 2007 09:06:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: =?ISO-8859-1?Q?Re=3A_2=2E6=2E24-rc3-mm1_--_arch/x86/xen/en?=
 =?ISO-8859-1?Q?lighten=2Ec=3A591=3A_error=3A_=27TLB=5FFLUSH=5FALL=27?=
 =?ISO-8859-1?Q?_undeclared_=28first_use_in_this_function=29?=
References: <a44ae5cd0711261006o3bf83210pd176bc93f710e9f5@mail.gmail.com>
In-Reply-To: <a44ae5cd0711261006o3bf83210pd176bc93f710e9f5@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> arch/x86/xen/enlighten.c: In function 'xen_flush_tlb_others':
> arch/x86/xen/enlighten.c:591: error: 'TLB_FLUSH_ALL' undeclared (first
> use in this function)
> arch/x86/xen/enlighten.c:591: error: (Each undeclared identifier is
> reported only once
> arch/x86/xen/enlighten.c:591: error: for each function it appears in.)
> make[1]: *** [arch/x86/xen/enlighten.o] Error 1
>   

Hm, I can't reproduce this in current git with your .config.  Is there
something in -mm which touches the tlb headers?

I do have a stack of tglx's x86 unification patches applied as well. 
Perhaps they help.

    J
