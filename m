Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXICSh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXICSh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXICShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:37:50 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3964 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbXICSht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:37:49 -0400
Date: Mon, 3 Sep 2007 20:38:21 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070902120154.GA23769@elte.hu>
Message-ID: <Pine.LNX.4.64.0709032030320.1817@scrub.home>
References: <20070902120154.GA23769@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Ingo Molnar wrote:

> Roman, as an addendum to my review, please find below a prototype patch 
> i've just written that implements RSRFS (Really Simple Really Fair 
> Scheduler) ontop of CFS. It is intended to demonstrate the essence of 
> the math you have presented via your patch. (it has no nice levels 
> support yet, to make the math really apparent to everyone interested)

It simplifies the math too much, the nice level weighting is an essential 
part of the math and without it one can't really understand the problem 
I'm trying to solve. At http://lkml.org/lkml/2007/9/3/168 I provide an 
example of the math, which more acurately demonstrates the essential 
math.

bye, Roman

