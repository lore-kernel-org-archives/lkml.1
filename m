Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXFYWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXFYWA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXFYWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:00:17 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3607 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbXFYWAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:00:16 -0400
Date: Tue, 26 Jun 2007 00:00:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
In-Reply-To: <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706252356400.1817@scrub.home>
References: <20070625200601.GA18980@elte.hu>  <200706252309.47467.zippel@linux-m68k.org>
 <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 25 Jun 2007, Jesper Juhl wrote:

> > On Monday 25 June 2007, Ingo Molnar wrote:
> > 
> > > the patch improves the sysbench OLTP macrobenchmark significantly:
> > 
> > Has that any real practical relevance?
> > 
> It seems to me that Ingo's patch offers slightly improved performance
> for any program using the time() system call, with no real drawbacks,
> so why wouldn't we want to use it?

How do you come to the conclusion it has no real drawbacks?
Ingo provided no information about his test setup and his patch was a 
little strange, so I can't say that yet.

bye, Roman
