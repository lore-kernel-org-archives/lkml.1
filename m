Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYGVMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYGVMlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYGVMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:41:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36889 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbYGVMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:41:28 -0400
Date: Tue, 22 Jul 2008 13:23:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial_txx9: Fix build failure by tty_port conversion
Message-ID: <20080722132345.5916af3b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721.234128.41011776.anemo@mba.ocn.ne.jp>
References: <20080721.234128.41011776.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 23:41:28 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Since commit df4f4dd429870f435f8d5d9d561db029a29f063b ("serial: use
> tty_port"), serial_txx9 cause this build failure:
> 
> linux/drivers/serial/serial_txx9.c: In function 'receive_chars':
> linux/drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Already sent to Linus
