Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYH3AJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYH3AJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYH3AJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:09:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYH3AJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:09:37 -0400
Date: Fri, 29 Aug 2008 17:08:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>
 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> >
> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log
> 
> pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff

And that seems utter crap to begin with.

	PCI: Using MMCONFIG at e0000000 - efffffff

Where did it get that bogus "ffffffff" end address?

Anyway, that whole MMCONFIG/BAR thing was totally broken to begin with, 
and it's reverted now in my tree, so I guess it doesn't much matter.

			Linus
