Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXDXIFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXDXIFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXDXIFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:05:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46170 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbXDXIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:05:38 -0400
Date: Tue, 24 Apr 2007 09:09:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 7/7] libata: send event when AN received
Message-ID: <20070424090910.1d145c24@the-village.bc.nu>
In-Reply-To: <20070423170024.73b74a37.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070423170024.73b74a37.kristen.c.accardi@intel.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/* check the 'N' bit in word 0 of the FIS */
> +		if (f[0] & (1 << 15)) {
> +			int port_addr =  ((f[0] & 0x00000f00) >> 8);
> +			struct ata_device *adev = &ap->device[port_addr];

You can't be sure that the port_addr returned will be in range if a
device is malfunctioning...

