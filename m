Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZG2A1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZG2A1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZG2A1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:27:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbZG2A1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:27:13 -0400
Date: Tue, 28 Jul 2009 17:26:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907281722440.3161@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp> <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk>
 <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp> <20090727222010.1a5efb7b@lxorguk.ukuu.org.uk> <87r5w19xsb.fsf@devron.myhome.or.jp> <20090728112203.7b70adba@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
 <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Linus Torvalds wrote:
> 
> So does this work for everyone? I haven't tested it yet myself, but this 
> is the patch that "looks" right.

This thing (on top of current -git) seems to pass Ogawa's tests at least 
on my machine (both on SMP, and when the processes are limited to just a 
single CPU).

Of course, since he wrote both the patch _and_ the tests, that doesn't 
come as a huge surprise - you'd expect Ogawa's patch to fix the testcase 
he has.

I use neither kdesu nor GNU emacs, so people who see the problem should 
test this patch, and maybe we can put _this_ particular issue behind us.

		Linus
