Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYGVNyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYGVNyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYGVNyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:54:36 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:56575 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYGVNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:54:35 -0400
Message-Id: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: linuxppc-dev list <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: latest tree build failure -- cpm uart & gpio
Date: Tue, 22 Jul 2008 08:54:16 -0500
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can someone look at the following compile failure in linus's tree.   
I'm guessing part of this has to do with Alan's tty changes (and might  
already be addressed?).

include/asm-generic/gpio.h:131: error: implicit declaration of  
function 'gpio_get_value'
include/asm-generic/gpio.h:137: error: implicit declaration of  
function 'gpio_set_value'
make[4]: *** [drivers/net/fs_enet/fs_enet-main.o] Error 1
drivers/serial/cpm_uart/cpm_uart_core.c:212: error: 'struct uart_info'  
has no member named 'tty'
make[4]: *** [drivers/serial/cpm_uart/cpm_uart_core.o] Error 1
make[3]: *** [drivers/serial/cpm_uart] Error 2
make[3]: *** [drivers/net/fs_enet] Error 2
make[2]: *** [drivers/net] Error 2
make[2]: *** [drivers/serial] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

- k
