Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYISWie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYISWie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYISWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:38:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50350 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751694AbYISWiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:38:25 -0400
Date: Fri, 19 Sep 2008 23:38:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Li" <lkml@chrisli.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: irq 19: nobody cared
Message-ID: <20080919233808.64aa7539@lxorguk.ukuu.org.uk>
In-Reply-To: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 13:40:33 -0700
"Chris Li" <lkml@chrisli.org> wrote:

> Hi,
> 
> I run into this irq nobody care problem on a dell vostro 200 machine.
> I test the latest git tree. The problem is there as well.
> I also update the BIOS to the latest version. Doesn't help either.
> 
> It seem the IRQ in question is shared between UHCI and SATA controller.
> So I am not sure it is a SATA problem or a USB problem.

It could also be an IRQ being routed wrongly or an incorrect BIOS table
so that the kernel is looking for the IRQ in the wrong place.

Does booting with the irqpoll option help ?

> 
> usb 4-2: new full speed USB device using uhci_hcd and address 2
> irq 19: nobody cared (try booting with the "irqpoll" option)

And does this last one (the irq19) occur immediately when you plug in a
USB device ?
