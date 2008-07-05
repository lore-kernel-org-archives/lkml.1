Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYGEKwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYGEKwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYGEKwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:52:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50783 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYGEKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:52:14 -0400
Date: Sat, 5 Jul 2008 11:34:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Peterson <joe@skyrush.com>, Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080705113434.41109492@lxorguk.ukuu.org.uk>
In-Reply-To: <486E9F91.6010701@firstfloor.org>
References: <48661488.10304@gmail.com>
	<87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<871w29s5u2.fsf@basil.nowhere.org>
	<20080704221457.1f147225@lxorguk.ukuu.org.uk>
	<486E97F2.8020605@firstfloor.org>
	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>
	<486E9F91.6010701@firstfloor.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So what kind of data do you want? Someone watching a wallclock while
> comparing Ctrl-Z+kill versus Ctrl-C on a IO intensive process?

Latency traces with timestamps might be quite useful, they'd probably
also tell you why it happened. I can't reproduce it, nobody has provided
numbers so even if I wanted to work on it I couldn't do much.

Instead I have lots of real tty, ATA and other work that needs doing
which has quantified data, is reproducable and needs doing, so that will
get done.

Alan
