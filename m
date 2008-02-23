Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbYBWSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbYBWSmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbYBWSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:41:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757146AbYBWSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:41:58 -0500
Date: Sat, 23 Feb 2008 18:31:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Message-ID: <20080223183138.59d18e26@core>
In-Reply-To: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
References: <19f34abd0802230948n3b98b7d2kd67ca9c2f8fbbd47@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> I don't see the connection between (no-)smp and ata. Something with
> interrupt routing/IPI, missing irq ack? Booting another !SMP kernel
> works fine. The problem also exists in 2.6.24-rc2.

Almost certainly interrupt routing try smp but with noapic and see if it
fails as well ?
