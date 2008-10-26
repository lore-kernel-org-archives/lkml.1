Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYJZSWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYJZSWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYJZSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:21:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbYJZSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:21:50 -0400
Date: Sun, 26 Oct 2008 11:19:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Mikko C." <mikko.cal@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
In-Reply-To: <200810261914.40825.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org> <200810261914.40825.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> 
> OK, I've closed bug #11853 with this assumption.  Mikko, if it happens again
> with 2.6.28-rc1-git3 or later, please reopen.

Note: I tried to find Mikko's config, but zlin.dk times out. So I cannot 
check that he actually has CONFIG_HOTPLUG_CPU off, which is probably 
required to actually trigger the bug. 

But it does sound likely.

However, the "Thunderbird crashes out for me" thing in that same thread 
may be totally unrelated.

		Linus
