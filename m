Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXFLJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXFLJK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXFLJKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:10:12 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:37559 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXFLJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:10:11 -0400
Date: Tue, 12 Jun 2007 10:09:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeff Garzik <jeff@garzik.org>,
       Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Message-ID: <20070612090940.GA9719@srcf.ucam.org>
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E1A32.90306@linux.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 08:59:46PM -0700, Arjan van de Ven wrote:

> that's a temporary shortcoming; even with these power savings you can 
> do hotplug as long as you're willing to poll for it at a reasonable 
> interval and are willing to wait the time between polls for a hotplug 
> to take effect..

On laptops, I suspect that we'll probably get an ACPI interrupt even if 
the AHCI hotplug pathway can't manage.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
