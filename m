Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXKSPwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXKSPwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbXKSPwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:52:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47658 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754289AbXKSPwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:52:06 -0500
Date: Mon, 19 Nov 2007 15:50:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 21285: Report baud rate back via termios
Message-ID: <20071119155007.6cfdce37@the-village.bc.nu>
In-Reply-To: <20071119154137.GA30129@flint.arm.linux.org.uk>
References: <20071119151222.6cfa9c4c@the-village.bc.nu>
	<20071119154137.GA30129@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 15:41:37 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Mon, Nov 19, 2007 at 03:12:22PM +0000, Alan Cox wrote:
> > Currently reports back the requested rate not the result of the divides
> > but thats an easy fix for someone with h/w
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Ack for first hunk.  When can this be merged?  I assume it has to wait
> for tty_encode_baud_rate() to appear in mainline?

tty_termios_encode_baud-rate/tty_encode_baud_rate are now in mainline
