Return-Path: <linux-kernel-owner+w=401wt.eu-S1422847AbXBHAam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847AbXBHAam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422846AbXBHAal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:30:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422834AbXBHAag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:30:36 -0500
Date: Wed, 7 Feb 2007 16:30:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] pata_acpi: take two
Message-Id: <20070207163026.8ac90b5d.akpm@linux-foundation.org>
In-Reply-To: <20070207172220.04c96dc5@localhost.localdomain>
References: <20070207172220.04c96dc5@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 17:22:20 +0000
Alan <alan@lxorguk.ukuu.org.uk> wrote:

> This is a driver for motherboard SFF style PATA ports that have ACPI
> control methods. 

It needs some work against the current libata tree. 

drivers/ata/pata_acpi.c: In function 'pacpi_port_start':
drivers/ata/pata_acpi.c:259: warning: implicit declaration of function 'ata_port_stop'
drivers/ata/pata_acpi.c: At top level:
drivers/ata/pata_acpi.c:327: error: 'ata_pio_data_xfer' undeclared here (not in a function)
drivers/ata/pata_acpi.c:336: error: 'ata_host_stop' undeclared here (not in a function)
