Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbYETKVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbYETKVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYETKUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:20:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54405 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYETKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:20:53 -0400
Date: Tue, 20 May 2008 11:20:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20080520102038.GA2441@srcf.ucam.org>
References: <20080505223357.GA2839@srcf.ucam.org> <20080506081347.GA8688@homac> <20080506082110.GA10355@srcf.ucam.org> <48201987.4020009@gmail.com> <20080506092653.GB4378@homac> <20080506093628.GA12469@srcf.ucam.org> <20080519162934.GA15623@srcf.ucam.org> <20080520074442.GA14417@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520074442.GA14417@homac>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fixups to ATA ACPI hotplug
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 09:44:42AM +0200, Holger Macht wrote:

> * In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
>   the device has been plugged or unplugged. If plugged, hotplug it, if
>   unplugged, just signal event to userspace
>   (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)

The only issue I can see is that this one doesn't check _EJ0. Unless 
that's done, you'll (on some hardware) evaluate _STA on the bay itself 
rather than the device within the bay, which leads to confusion as to 
whether the device has been inserted. Other than that, looks good. 
Jeff's sent my patch to Linus, so can you redo this on top and I'll sign 
it off?

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
