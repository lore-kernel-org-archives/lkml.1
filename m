Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYE0Vwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYE0Vwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbYE0Vw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:52:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758296AbYE0Vw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:52:26 -0400
Date: Tue, 27 May 2008 22:38:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080527223822.57306677@core>
In-Reply-To: <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<1211859542.3286.46.camel@pasglop>
	<alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	<1211922621.3286.80.camel@pasglop>
	<alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> re-ordering, even though I doubt it will be visible in practice. So if you 
> use the "__" versions, you'd better have barriers even on x86!

Are we also going to have __ioread*/__iowrite* ?

Also is the sematics of __readl/__writel defined for all architectures -
I used it ages ago in the i2o drivers for speed and it got removed
because it didn't build on some platforms.

Alan

