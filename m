Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbXGSUEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbXGSUEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXGSUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:04:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbXGSUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:04:35 -0400
Date: Thu, 19 Jul 2007 22:04:13 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Denis Vlasenko <vda.linux@googlemail.com>
cc: Bodo Eggert <7eggert@gmx.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Rene Herman <rene.herman@gmail.com>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <200707192034.35885.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.58.0707192140160.4693@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
 <Pine.LNX.4.58.0707170134390.29868@be1.lrz> <200707192034.35885.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/mBKw0GDeqMu6Rkuc9c1B/G5ZMOvQ/BNRWU8h
 XO2qYctsroWiE4++0GY47eKAIJvRHD+bGgfA0vo78DHtc2nxEq
 oD5jiylY+gWQDts4uRd8g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Denis Vlasenko wrote:
> On Tuesday 17 July 2007 00:42, Bodo Eggert wrote:

> > > b) make 4K stacks the default option in vanilla kernel.org kernels as
> > > a gentle nudge towards getting people to start fixing the code paths
> > > that are not 4K stack safe.
> > 
> > That's the big NACK. It's OK for MM, where things are supposed to be in a 
> > not well-tested state, but for running possibly mission-critical systems,
> > you should take no risk.
> 
> Mission-critical machines are not supposed to have kernel configured
> with incompetent/careless sysadmin who didn't think about
> config choices he made at kernel build time.

Is it careless to asume good code quality for default options?
Does the 4K stack come with a big red warning about crashing the kernel?
(I just checked, it does not, only benefits are listed.)
Are 4K stacks so obviously flawed nobody would use them for reliable systems?
Or is each sysadmin supposed to read LKML in order to find out about the
pitfalls you designed for them?
-- 
Top 100 things you don't want the sysadmin to say:
55. NO!  Not _that_ button!
