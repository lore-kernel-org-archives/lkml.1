Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZG2HCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZG2HCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZG2HCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:02:03 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41426 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZG2HCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:02:02 -0400
Date: Wed, 29 Jul 2009 12:31:53 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090729070110.GA4311@skywalker>
References: <alpine.LFD.2.01.0907280848090.3186@localhost.localdomain> <20090728174213.5e927428@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280944150.3186@localhost.localdomain> <20090728180649.596c5412@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain> <20090728195651.3a402a31@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain> <20090729004639.71f0eabc@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907281651160.3186@localhost.localdomain> <alpine.LFD.2.01.0907281722440.3161@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907281722440.3161@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 05:26:16PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 28 Jul 2009, Linus Torvalds wrote:
> > 
> > So does this work for everyone? I haven't tested it yet myself, but this 
> > is the patch that "looks" right.
> 
> This thing (on top of current -git) seems to pass Ogawa's tests at least 
> on my machine (both on SMP, and when the processes are limited to just a 
> single CPU).
> 
> Of course, since he wrote both the patch _and_ the tests, that doesn't 
> come as a huge surprise - you'd expect Ogawa's patch to fix the testcase 
> he has.
> 
> I use neither kdesu nor GNU emacs, so people who see the problem should 
> test this patch, and maybe we can put _this_ particular issue behind us.
> 

The patch also fix the "compile in emacs" bug.
http://bugzilla.kernel.org/show_bug.cgi?id=13815

-aneesh
