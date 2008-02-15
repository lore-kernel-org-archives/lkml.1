Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbYBONu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbYBONu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYBONuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:50:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49870 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYBONuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:50:19 -0500
Date: Fri, 15 Feb 2008 14:50:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
In-Reply-To: <47B2CF57.9030308@panasas.com>
Message-ID: <Pine.LNX.4.64.0802151450020.30301@fbirervta.pbzchgretzou.qr>
References: <20080212234928.GA13892@havoc.gtf.org> <47B2CF57.9030308@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13 2008 13:07, Boaz Harrosh wrote:
>+static struct pci_device_id gdthtable[] __devinitdata = {
>+	{ PCI_VDEVICE(VORTEX, PCI_ANY_ID) },
>+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC) },
>+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC_XSCALE) },
>+	{ }	/* terminate list */
>+};

As usual, +const and +__devinitconst :-)

