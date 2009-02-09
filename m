Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZBIK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZBIK1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZBIK1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:27:33 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48835 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZBIK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:27:32 -0500
Date: Mon, 9 Feb 2009 11:27:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Frank Seidel <frank@f-seidel.de>, Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090209112718.5ddf68db@hyperion.delvare>
In-Reply-To: <20090209083537.GA3438@pengutronix.de>
References: <498C3EEA.5060508@suse.de>
	<20090208000553.059a0732@hyperion.delvare>
	<498EDA18.1090300@f-seidel.de>
	<20090208144751.46184041@hyperion.delvare>
	<20090209083537.GA3438@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 09:35:37 +0100, Wolfram Sang wrote:
> > I mean the (first) printk in the loop, not the last printk in this
> > function. So what I am suggesting is:
> > 
> > +	printk(KERN_DEBUG);
> > 	for (i = 0; i < i2c->irqlogidx; i++)
> > 		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> > 	printk("\n");
> 
> Hmm, I was told (by Jean ;)) that every printk should end with newline,
> otherwise it might get interrupted with other output -> mess.

Correct, however the code was already wrong before Frank's patch, and
his patch is fixing a different problem. So I don't have any problem
with this, this can be fixed in a later patch if anybody cares.

-- 
Jean Delvare
