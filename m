Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbXBXAOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbXBXAOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXBXAOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:14:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54857 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933268AbXBXAOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:14:00 -0500
Date: Sat, 24 Feb 2007 01:17:54 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: <Tom.Morrison@Verizon.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Problems with init of Marvell PCI Express SATA Card
Message-ID: <20070224011754.5b8447dc@lxorguk.ukuu.org.uk>
In-Reply-To: <CJEDIOAEPEPAEFLDLKIBEEJNCDAA.Tom.Morrison@Verizon.net>
References: <20070224004809.30a0e105@lxorguk.ukuu.org.uk>
	<CJEDIOAEPEPAEFLDLKIBEEJNCDAA.Tom.Morrison@Verizon.net>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> if you look in the sata_mv.c it has support for the 
> 7042 throughout it (exactly the same as PCI in fact - 
> its the same core chip - just different bus interface)...

For the 7042 with the TTI PCI identifier but not one with a Marvell ID -
what vendor/device does your device show up ?

The probe code uses the table in each driver to do matches. For the 7042
the only version it knows is

   { PCI_VDEVICE(TTI, 0x2310), chip_7042 },
