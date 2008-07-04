Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYGDUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYGDUJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYGDUJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:09:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbYGDUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:09:16 -0400
Date: Fri, 4 Jul 2008 20:51:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Fannin <jfannin@gmail.com>
Cc: Alan Cox <alan@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next-0703 -- more ppc serial fixes
Message-ID: <20080704205120.27350175@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704182909.GB1631@nineveh.local>
References: <20080703190948.8e7bceca.sfr@canb.auug.org.au>
	<20080704182909.GB1631@nineveh.local>
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

On Fri, 4 Jul 2008 14:29:10 -0400
Joseph Fannin <jfannin@gmail.com> wrote:

> On Thu, Jul 03, 2008 at 07:09:48PM +1000, Stephen Rothwell wrote:
> 
> [next-0703]
> 
> > $ git quiltimport --author "Alan Cox <alan@lxorguk.ukuu.org.uk>" --patches "../quilt/ttydev"
> 
> More fixes for ppc serial drivers seem to be needed since next-0701 (exclusive):
> 
> drivers/serial/mpc52xx_uart.c: In function 'mpc52xx_uart_int_rx_chars':
> drivers/serial/mpc52xx_uart.c:735: error: 'struct uart_info' has no member named 'tty'
> drivers/serial/mpc52xx_uart.c: In function 'mpc52xx_uart_of_probe':
> drivers/serial/mpc52xx_uart.c:1277: warning: cast to pointer from integer of different size

Should already by in the ttydev tree at this point
