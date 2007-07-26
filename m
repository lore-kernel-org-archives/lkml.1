Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbXGZOEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbXGZOEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbXGZOD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:03:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47090 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756781AbXGZOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:03:57 -0400
Date: Thu, 26 Jul 2007 15:10:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao" <fernando@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
Message-ID: <20070726151042.0ae34e0e@the-village.bc.nu>
In-Reply-To: <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
	<d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The handler does handle the interrupt - both status and data registers
> are read so from the keyboard controller point of view the interrupt
> has been handled even if we happen to discard the data. As far as I
> know IRQ12 is never shared by BIOS... Vojtech, do you remember why we
> request IRQ12 with IRQF_SHARED?

A small number of boxes do share IRQ12 and it was switched to shared for
them. 

The debug check is an *aid* not a definitive proof of a problem
