Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYF3Kbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYF3Kbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYF3KbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:31:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbYF3KbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:31:22 -0400
Date: Mon, 30 Jun 2008 11:12:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/2] serial: Add flush_buffer() operation to uart_ops
Message-ID: <20080630111248.567795df@lxorguk.ukuu.org.uk>
In-Reply-To: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
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

On Mon, 30 Jun 2008 12:24:20 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Serial drivers using DMA (like the atmel_serial driver) tend to get very
> confused when the xmit buffer is flushed and nobody told them.  They
> also tend to spew a lot of garbage since the DMA engine keeps running
> after the buffer is flushed and possibly refilled with unrelated data.
> 
> This patch adds a new flush_buffer operation to the uart_ops struct,
> along with a call to it from uart_flush_buffer() right after the xmit
> buffer has been cleared. The driver can implement this in order to
> syncronize its internal DMA state with the xmit buffer when the buffer
> is flushed.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Alan Cox <alan@redhat.com>
