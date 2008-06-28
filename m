Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYF1Jiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYF1Jiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 05:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYF1Jim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 05:38:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53121 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756072AbYF1Jil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 05:38:41 -0400
Date: Sat, 28 Jun 2008 10:15:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
 preemptable hardirqs
Message-ID: <20080628101535.54f20794@lxorguk.ukuu.org.uk>
In-Reply-To: <20080628010928.GA4248@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	<20080623235141.GB17297@elte.hu>
	<20080624000016.GA12547@polina.dev.rtsoft.ru>
	<20080625123431.GA25452@polina.dev.rtsoft.ru>
	<20080628005436.GA1956@polina.dev.rtsoft.ru>
	<20080628010928.GA4248@polina.dev.rtsoft.ru>
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

> Though, from a brief glance there is nothing much useful for this ULi
> chip. The only thing I gathered is that IDE controller does not provide
> any means of configuring its IRQs behaviour, so it is indeed ULi's bridge
> problems. It doesn't change anything, just another data point...

Legacy mode - Int line, edge
Native mode - PCI, level

Standard for IDE controllers
