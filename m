Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYDNVgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYDNVgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYDNVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:35:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49282 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbYDNVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:35:53 -0400
Date: Mon, 14 Apr 2008 22:31:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer PARPORT_PC
Message-ID: <20080414223124.6b92de11@core>
In-Reply-To: <20080414195551.GE26885@cs181133002.pp.htv.fi>
References: <20080414195551.GE26885@cs181133002.pp.htv.fi>
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

On Mon, 14 Apr 2008 22:55:51 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/parport/parport_pc.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:67:25: error: asm/parport.h: No such file or directory
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c: In function 'parport_pc_find_ports':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:3215: error: implicit declaration of function 'parport_pc_find_nonpci_ports'
> make[3]: *** [drivers/parport/parport_pc.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

If xtensa has PCI then if you fix up the headers so the PCI stuff works
we'll be in a better shape.
