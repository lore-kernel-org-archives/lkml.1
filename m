Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXLEA3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXLEA3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXLEA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:29:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53675 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbXLEA30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:29:26 -0500
Date: Wed, 5 Dec 2007 00:24:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jared Hulbert" <jaredeh@gmail.com>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
Message-ID: <20071205002454.52ea755c@the-village.bc.nu>
In-Reply-To: <6934efce0712041608w2e25587n6b2d738fa0265d9d@mail.gmail.com>
References: <47548BF4.3010907@nortel.com>
	<20071203230629.725f4c7a@the-village.bc.nu>
	<6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	<20071204203536.2bf6d025@the-village.bc.nu>
	<6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
	<20071204232449.6148e152@the-village.bc.nu>
	<6934efce0712041608w2e25587n6b2d738fa0265d9d@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 16:08:07 -0800
"Jared Hulbert" <jaredeh@gmail.com> wrote:

> On Dec 4, 2007 3:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Right.  The trend is to hide the nastiness of NAND technology changes
> > > behind controllers.  In general I think this is a good thing.
> >
> > You miss the point - any controller you hide it behind almost inevitably
> > adds enough latency you don't want to use it synchronously.
> 
> I think I get it.  We keep saying that it's the latency is too high.
> I agree that most technologies out there have latencies that are too
> high.  Again I ask the question, what latencies do we have to hit
> before the sync options become worth it?

Probably about 1000 clocks but its always going to depend upon the
workload and whether any other work can be done usefully.

Alan
