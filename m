Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYJZShS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYJZShS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYJZShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:37:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbYJZShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:37:01 -0400
Date: Sun, 26 Oct 2008 11:36:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Mikko C." <mikko.cal@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
In-Reply-To: <4904B6CC.7000403@gmail.com>
Message-ID: <alpine.LFD.2.00.0810261133150.5200@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org> <200810261914.40825.rjw@sisk.pl> <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org>
 <4904B6CC.7000403@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Mikko C. wrote:
> 
> Here's the full config: http://pastebin.com/d1481da76

Ok, you do indeed not have HOTPLUG_CPU, so I'd be willing to bet this is 
it.

> Does -rc1-git2 not have the fix yet?

It should indeed be in -rc1-git2, so you can test it that way. 

		Linus
