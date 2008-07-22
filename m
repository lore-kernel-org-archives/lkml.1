Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYGVOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYGVOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYGVOJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:09:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52386 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbYGVOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:09:42 -0400
Date: Tue, 22 Jul 2008 14:52:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <kumar.gala@freescale.com>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: latest tree build failure -- cpm uart & gpio
Message-ID: <20080722145215.2cf6fdd9@lxorguk.ukuu.org.uk>
In-Reply-To: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
References: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
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

On Tue, 22 Jul 2008 08:54:16 -0500
Kumar Gala <kumar.gala@freescale.com> wrote:

> can someone look at the following compile failure in linus's tree.   
> I'm guessing part of this has to do with Alan's tty changes (and might  
> already be addressed?).
> 
> include/asm-generic/gpio.h:131: error: implicit declaration of  
> function 'gpio_get_value'
> include/asm-generic/gpio.h:137: error: implicit declaration of  
> function 'gpio_set_value'

These are not

> make[4]: *** [drivers/net/fs_enet/fs_enet-main.o] Error 1
> drivers/serial/cpm_uart/cpm_uart_core.c:212: error: 'struct uart_info'  
> has no member named 'tty'

That one is and hasn't been addressed so I wil do it right now.

