Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYFPUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYFPUjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYFPUj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:39:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59784 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754027AbYFPUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:39:25 -0400
Date: Mon, 16 Jun 2008 21:21:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616212150.041d2969@lxorguk.ukuu.org.uk>
In-Reply-To: <4856CB79.9090602@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	<4856C93B.7070804@garzik.org>
	<20080616210001.3c3588a7@lxorguk.ukuu.org.uk>
	<4856CB79.9090602@garzik.org>
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

On Mon, 16 Jun 2008 16:22:17 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> >> Anyone running 'make oldconfig' could easily skip over this and get a 
> >> non-usable device, too.  Seems like a default 'y' is appropriate for the 
> >> initial patch...
> > 
> > If you blindly type N N N N to make oldconfig then you have an operator
> > error, and that should be fixed by fixing the operator.
> 
> Tell that to Linus and Ingo in the E1000 thread.

Happily - although Ingo is also the one who got ATA breakage by typing Y
Y Y Y ;)
