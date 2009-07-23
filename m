Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZGWOqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZGWOqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZGWOqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:46:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48986 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711AbZGWOqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:46:01 -0400
Date: Thu, 23 Jul 2009 15:46:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>, Rich Freiss <richard.freiss@hp.com>,
       Linux OMAP Users <linux-omap@vger.kernel.org>
Subject: Re: Boot Hang - mmotm 090716 - serial 8250 irq flags support
Message-ID: <20090723154657.184a12ab@lxorguk.ukuu.org.uk>
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC35608702F57AD326@dbde02.ent.ti.com>
References: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
	<20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
	<1248353462.5674.80.camel@useless.americas.hpqcorp.net>
	<20090723145754.3f001c4e@lxorguk.ukuu.org.uk>
	<FCCFB4CDC6E5564B9182F639FC35608702F57AD326@dbde02.ent.ti.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you referring to serial-add-irqflags-support patch.
> Do let me know in case any respin of this patch is needed.

The old_serial_port structure just needed the irqflags field moving to
the end so it didn't break some existing initialisers (eg
arch/x86/include/asm/serial.h)

Alan
