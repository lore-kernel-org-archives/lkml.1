Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYFYMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYFYMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYFYMwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:52:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47775 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754433AbYFYMwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:52:05 -0400
Date: Wed, 25 Jun 2008 13:32:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
 preempt-able hardirqs
Message-ID: <20080625133257.7677258d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080625123431.GA25452@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	<20080623235141.GB17297@elte.hu>
	<20080624000016.GA12547@polina.dev.rtsoft.ru>
	<20080625123431.GA25452@polina.dev.rtsoft.ru>
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

> The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
> reason it does not hold IRQ line, but rises it for some short period
> of time (while the drive itself rises and holds it correctly -- I'm
> seeing it via oscilloscope).

Are you sure the kernel isn't touching the status register and so
clearing the IRQ condition at the controller ?
