Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbYETNWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbYETNWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYETNWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:22:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46648 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYETNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:22:36 -0400
Date: Tue, 20 May 2008 14:22:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20080520132217.GA5633@srcf.ucam.org>
References: <20080505223357.GA2839@srcf.ucam.org> <20080506081347.GA8688@homac> <20080506082110.GA10355@srcf.ucam.org> <48201987.4020009@gmail.com> <20080506092653.GB4378@homac> <20080506093628.GA12469@srcf.ucam.org> <20080519162934.GA15623@srcf.ucam.org> <20080520074442.GA14417@homac> <20080520102038.GA2441@srcf.ucam.org> <20080520131831.GA568@homac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520131831.GA568@homac>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fixups to ATA ACPI hotplug
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 03:18:32PM +0200, Holger Macht wrote:

> +	if (kobj && !is_dock_event) {
> +		sprintf(event_string, "BAY_EVENT=%d", event);
> +		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);

I think we want to do the _EJ0 checking before this, otherwise we'll 
generate two uevents for the same removal on some hardware. Otherwise, 
looks good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
