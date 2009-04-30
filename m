Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbZD3MMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbZD3MMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZD3MLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:11:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41883 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbZD3MLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:11:24 -0400
Date: Thu, 30 Apr 2009 13:11:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>
Subject: Re: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel
	Moorestown platform
Message-ID: <20090430121118.GA22480@srcf.ucam.org>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com> <95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 05:19:06PM +0800, Li, Jiebing wrote:
> 
> This patch enables support of SDIO bus driver suspend/resume operation and supply sysfs interface for user
> to call suspend/resume selectively.Remind that this function should work together with SDIO device driver's
> suspend/resume function.

We used to have similar functionality in the PCI layer, but it got 
removed on the assumption that this kind of thing should be handled by 
the drivers being sufficiently intelligent. What's the use case for 
this?

> And Moorestown's specific code is added into this patch to enable the second SDIO slot of the host controller.

That should probably be sent as a separate patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
