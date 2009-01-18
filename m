Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbZAROOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbZAROOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761601AbZARON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:13:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41679 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759310AbZARON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:13:56 -0500
Date: Sun, 18 Jan 2009 14:14:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Bramer <michael@debsupport.de>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port
 RS-232 MIC-3620 from advantech'
Message-ID: <20090118141409.3c2d0f95@lxorguk.ukuu.org.uk>
In-Reply-To: <20090118135359.GA3087@deb-support.de>
References: <20090118135359.GA3087@deb-support.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +               .vendor         = PCI_VENDOR_ID_ADVANTECH,
> +               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               .subdevice      = PCI_ANY_ID,

This looks odd - the subvendor ought to be a vendor id, and there should
be a device id as well.

> +       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
> +               PCI_DEVICE_ID_ADVANTECH_PCI3620, PCI_ANY_ID, 0, 0,
> +               pbn_b2_8_921600 },
>         {       PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
>                 PCI_SUBVENDOR_ID_CONNECT_TECH,
>                 PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,
> -------------------------------------
> 
> can you add this in the next linux kernel?

Can you firstly send me an lspci -vvxxx of that device. Also see
Documentation/SubmittingPatches about Signed-off-by lines and we'll sort
out merging it.

Alan
