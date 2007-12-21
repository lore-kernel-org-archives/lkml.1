Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXLULTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXLULTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXLULTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:19:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbXLULTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:19:36 -0500
Date: Fri, 21 Dec 2007 12:19:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
	well
Message-ID: <20071221111921.GB687@elte.hu>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712201912.37416.volker.armin.hemmann@tu-clausthal.de> <20071220190419.GA23620@elte.hu> <200712210309.02865.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712210309.02865.volker.armin.hemmann@tu-clausthal.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hemmann, Volker Armin <volker.armin.hemmann@tu-clausthal.de> wrote:

> Ok, so after the holidays I will do the following:
> 
> let memtest86+ run several hours. do a full backup&restore to switch 
> to r3 and build an unpatched kernel. see if I can reproduce the oops 
> with .21 and .22 (because AFAIR no oops with 21.. but I might be 
> wrong).
> 
> Not exactly in that order.

yeah, that would help. But generally it a big PITA to figure out such 
bugs where there's no specific 'smoking gun' in the oopses themselves. 
What usually happens is that people try to figure out a faster way of 
triggering the bug - and then bisection can be done. But the hardware 
must be eliminated first as the cause of the bug. Taking out half of the 
RAM (i know it's painful ...) can help too in isolating RAM problems.

	Ingo
