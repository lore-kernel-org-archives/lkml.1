Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbYF2NKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbYF2NKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYF2NKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:10:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34249 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754841AbYF2NKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:10:05 -0400
Date: Sun, 29 Jun 2008 13:49:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: avorontsov@ru.mvista.com, Ingo Molnar <mingo@elte.hu>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
 preemptable hardirqs
Message-ID: <20080629134943.19b94bd2@lxorguk.ukuu.org.uk>
In-Reply-To: <486615E2.3080802@ru.mvista.com>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	<20080623235141.GB17297@elte.hu>
	<20080624000016.GA12547@polina.dev.rtsoft.ru>
	<20080625123431.GA25452@polina.dev.rtsoft.ru>
	<20080628005436.GA1956@polina.dev.rtsoft.ru>
	<20080628101431.0b64d6c2@lxorguk.ukuu.org.uk>
	<486615E2.3080802@ru.mvista.com>
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

>    His boot log shows the native mode.

Then the bridge is misprogrammed

>    What's IDEIRT, some ISA bridge register? And why should one set 
> [A]PIC to level mode for legacy mode IDE? :-O

You need an NDA and then they'll send you the data sheet for the bridges
and other logic. It's all programmable.

"He has an OpenPIC, it's PowerPC SoC, so no ELCR either"

Really - he's using a designed for PC ISA bridge etc.. he might have all
sorts of stuff on it.

Alan
