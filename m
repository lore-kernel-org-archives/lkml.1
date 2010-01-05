Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102Ab0AEALk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0AEALk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900Ab0AEALk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:11:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753892Ab0AEALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:11:39 -0500
Date: Tue, 5 Jan 2010 00:14:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
Message-ID: <20100105001424.13f67547@lxorguk.ukuu.org.uk>
In-Reply-To: <1262645259.6469.18.camel@wall-e>
References: <200912271003.631128760@firstfloor.org>
	<20091227210314.ABA04B17C3@basil.firstfloor.org>
	<1261950589.25298.32.camel@wall-e>
	<20091227234137.GD2399@basil.fritz.box>
	<20100104135754.07d4e442.akpm@linux-foundation.org>
	<20100104222429.6a386a88@lxorguk.ukuu.org.uk>
	<1262645259.6469.18.camel@wall-e>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Bloat is going to be a big issue if its macro and all the serial/tty
> > stuff switches to it. Please keep the bytewise one none macro - even if
> > its a lib/foo.c file that simply uses the macros to produce the existing
> > new API.
> 
> Nope, currently the bytewise is the special case. Most of the user of
> kfifo try to store other type then bytes in a fifo. 

If the tty layer switches to it then the bytewise one will dominately
quite rapidly as it can replace the uart_circ stuff

> The new macro based kfifo does not bloat the code, the opposite is the
> truth. I checked the assembler output on intel and ppc and the generated
> code is smaller and better.

Thats excellent

