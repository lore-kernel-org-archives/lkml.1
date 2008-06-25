Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbYFYOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbYFYOwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYFYOwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:52:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37231 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbYFYOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:52:20 -0400
Date: Wed, 25 Jun 2008 15:32:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
 preempt-able hardirqs
Message-ID: <20080625153212.611c3766@lxorguk.ukuu.org.uk>
In-Reply-To: <20080625142249.GA21630@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	<20080623235141.GB17297@elte.hu>
	<20080624000016.GA12547@polina.dev.rtsoft.ru>
	<20080625123431.GA25452@polina.dev.rtsoft.ru>
	<486244FF.8060805@ru.mvista.com>
	<20080625142249.GA21630@polina.dev.rtsoft.ru>
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

> Note: I don't have any specifications on that ULi bridge, neither I have
> any schematics for that board (so far, let's hope). So I can't say
> exactly how things are inter-connected or what these PCI quirks are
> actually doing (despite few comments in them).

So you don't for example know if the bridge is correctly configured for
that device to be edge or level triggered ?

Alan
