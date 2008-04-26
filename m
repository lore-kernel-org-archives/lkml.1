Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYDZQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYDZQJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYDZQJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:09:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbYDZQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=sHy5XkGbCvY/I4k/sZKWEmHdb63pA16wAuJ6nB9qKojE6Y9TSQ8WPRNTqF54m/5bZ1dLygRk71oTrM7DVN9w8wSMNYMEhqvodSqX6vU8HxuGBZp/ldhPk6T6mGq7KYyZNP8xX2KfNgZF3fw68b4aeg7FrkS39PdG4iRz9G+WJBM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: If you want me to quit I will quit
Date: Sat, 26 Apr 2008 18:21:05 +0200
User-Agent: KMail/1.9.9
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi>
In-Reply-To: <20080426110044.GB2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804261821.05332.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 26 April 2008, you wrote:
> > [BUILDFIX PATCH] au0828: debug is a poor global identifier
> 
> Another issue for which I already sent a (slightly different) patch.
> 
> Why not check the mailing list before duplicating work? [1]
> 
> And if you e.g. discover next that our x86 userspace headers in
> 2.6.25 (sic) are fucked up guess who already sent a patch last 
> weekend... [2]
> 
> Why do other people get over 100 checkpatch fixes into the tree at once 
> or Linus applies patches directly bypassing the maintainers (like the 
> one you sent just before [3], which I've also already sent before [4]) 
> but my patches bitrot forever?
> 
> And Linus didn't even bother to answer what the correct path for my 
> patches is. [5]

Linus just can't tell you directly to send him pull requests for patches
touching kernel areas which are (or are supposed to be) maintained by other
people but he isn't going to ignore properly justified git pull requests
(see below).

Also you may try this for your changes:

* set -mm like tree containing all pending patches
  (+ ask for inclusion into -next tree and -mm tree)

* send tree status updates to LKML (w/ some "marketing") regularly

* send git pull requests to Linus with changes ACK-ed by relevant
  parties or lacking feedback (> 1 month timeout)

> My current record is sending a patch 7 times (and still counting) 
> without it getting applied anywhere. [6]

Please send a git pull request with v850 removal to Linus noting that:

* the code has been broken for ages (since 2.6.19) and maintainer
  cannot be even reached, according to MAINTAINERS:

	UCLINUX FOR NEC V850
	P:      Miles Bader

* the patch was posted multiple times (first 3 months ago)
  and there were no complains

* you've got an ACK from Greg Ungerer and you may add mine
  (FWIW, ACK-s from other arch maintainers would be more valuable),

  also back in February Ingo was positive about removing v850
  port and suggested adding info about it to

  Documentation/feature-removal-schedule.txt

  as a prerequisite for the removal (unfortunately it hasn't happened?)

> And if anyone has doubts in the quality of my patches try to find
> commits of me in Linus' tree that introduced any bugs - you most 
> likely won't find 3 buggy commits among my last 500 commits.

Nobody questions quality of your patches - the problem is that they are
spread all over the tree and are likely to conflict with other people's
trees.  Setting your own tree and putting it into -next tree seems like
a best solution for this.  It should also help in preventing duplicated
work / patches getting lost.

Thanks,
Bart

> Guys, this is neither a kindergarten nor the right place for corporate 
> mobbing games. If you want to get rid of me simply say so and I'll 
> immediately unsubscribe and stop bothering you with patches.
> 
> Really annoyed
> Adrian
> 
> [1] http://lkml.org/lkml/2008/4/25/376
> [2] http://lkml.org/lkml/2008/4/20/181
> [3] http://lkml.org/lkml/2008/4/25/511
> [4] http://lkml.org/lkml/2008/4/24/523
> [5] http://lkml.org/lkml/2008/4/2/369
> [6] http://lkml.org/lkml/2008/4/21/523
>     http://lkml.org/lkml/2008/4/21/577
