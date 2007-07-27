Return-Path: <linux-kernel-owner+w=401wt.eu-S937755AbXG0UhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937755AbXG0UhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934055AbXG0Ug4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:36:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763020AbXG0Ugz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:36:55 -0400
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources
	(was: updatedb)
From: Arjan van de Ven <arjan@infradead.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707272243.02336.a1426z@gawab.com>
References: <200707272243.02336.a1426z@gawab.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 27 Jul 2007 13:34:58 -0700
Message-Id: <1185568498.2711.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> IMHO, what everybody agrees on, is that swap-prefetch has a positive effect 
> in some cases, and nobody can prove an adverse effect (excluding power 
> consumption).  The reason for this positive effect is also crystal clear:  
> It prefetches from swap on idle into free memory, ie: it doesn't force 

the fact that there is free memory is ... strange. IN principle, Linux
keeps almost no memory free (except some emergency buffers) so that
things you swap in prematurely will BY DEFINITION go at the expense of
other things that could be there.... 

also, they take up seek time (5 to 10 msec), so if you were to read
something else at the time you get additional latency.

so the conclusion that it only can be better (if you don't care about
power) is imo premature.

Sure it still can be worth it, but it for sure is NOT an automatic
thing.


