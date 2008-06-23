Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYFWOij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYFWOij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbYFWOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:38:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48575 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755459AbYFWOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:38:31 -0400
Date: Mon, 23 Jun 2008 15:20:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Subject: Re: [patch] x86 supports NO_IRQ convention
Message-ID: <20080623152045.07a21216@lxorguk.ukuu.org.uk>
In-Reply-To: <200806230429.36298.david-b@pacbell.net>
References: <200806221953.18849.david-b@pacbell.net>
	<20080623100823.61213c3f@lxorguk.ukuu.org.uk>
	<200806230429.36298.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 04:29:36 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Monday 23 June 2008, Alan Cox wrote:
> > Zero is not a valid IRQ in the kernel mapping of things.
> 
> That's counter-factual:

There are historical reasons for the timer tick (which isn't visible
outside arch code) being 0 on x86.

> I certainly agree it'd be convenient to be able to just test
> for IRQ being nonzero. 

0 means "no IRQ" in things like dev->irq. Lots of driver code assumes
this and it has been decreed 'correct'.

Alan
