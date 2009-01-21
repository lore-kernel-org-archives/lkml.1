Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbZAUMcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbZAUMcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbZAUMcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:32:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57067 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758280AbZAUMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:32:08 -0500
Date: Wed, 21 Jan 2009 12:32:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Michael Bramer <michael@debsupport.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port
 RS-232 MIC-3620 from advantech'
Message-ID: <20090121123215.1b3acc4d@lxorguk.ukuu.org.uk>
In-Reply-To: <4976DF6F.2010509@wincor-nixdorf.com>
References: <20090118135359.GA3087@deb-support.de>
	<20090119145101.GA16732@ports.donpac.ru>
	<20090119235122.GE21026@deb-support.de>
	<20090120151216.GB16732@ports.donpac.ru>
	<20090121075212.GA18485@deb-support.de>
	<4976DA3D.7050201@teltonika.lt>
	<4976DF6F.2010509@wincor-nixdorf.com>
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

> >>  static struct pci_device_id serial_pci_tbl[] = {
> >> +       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
> >> +               0x3620, PCI_ANY_ID, 0, 0,
> 
> Why not use PCI_VENDOR_ID_ADVANTECH as PCI_SUBVENDOR_ID too?

The Advantech vendor id is not 0x3620. This confused me as well which is
why I asked for an lspci. Advantech has stuck the device id in the
subvendor bits and '1' in the subdevice (so it should be 1 not
PCI_ANY_ID).

Alan
