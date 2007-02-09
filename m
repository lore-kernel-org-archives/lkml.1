Return-Path: <linux-kernel-owner+w=401wt.eu-S2992796AbXBIT7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992796AbXBIT7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992798AbXBIT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:59:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43236 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992796AbXBIT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:59:54 -0500
Date: Fri, 9 Feb 2007 20:13:09 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] pata_acpi: take two
Message-ID: <20070209201309.3e44a3ae@localhost.localdomain>
In-Reply-To: <20070207163026.8ac90b5d.akpm@linux-foundation.org>
References: <20070207172220.04c96dc5@localhost.localdomain>
	<20070207163026.8ac90b5d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 16:30:26 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 Feb 2007 17:22:20 +0000
> Alan <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > This is a driver for motherboard SFF style PATA ports that have ACPI
> > control methods. 
> 
> It needs some work against the current libata tree. 
> 
> drivers/ata/pata_acpi.c: In function 'pacpi_port_start':
> drivers/ata/pata_acpi.c:259: warning: implicit declaration of function 'ata_port_stop'
> drivers/ata/pata_acpi.c: At top level:
> drivers/ata/pata_acpi.c:327: error: 'ata_pio_data_xfer' undeclared here (not in a function)
> drivers/ata/pata_acpi.c:336: error: 'ata_host_stop' undeclared here (not in a function)

Ok added to my todo list to sort out once there's a tree to work from.
