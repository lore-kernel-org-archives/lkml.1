Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZFKSol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZFKSol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZFKSoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:44:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:40941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbZFKSoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="420943102"
Date: Thu, 11 Jun 2009 11:43:39 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-pci@vger.kernel.org, andrew.patterson@hp.com,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v3] PCI: Add support for turning PCIe ECRC on or off
Message-ID: <20090611114339.23c0106e@jbarnes-g45>
In-Reply-To: <20090422225208.16081.73220.stgit@bluto.andrew>
References: <20090422225203.16081.94717.stgit@bluto.andrew>
	<20090422225208.16081.73220.stgit@bluto.andrew>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 16:52:09 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> PCI: Add support for turning PCIe ECRC on or off
> 
> Adds support for PCI Express transaction layer end-to-end CRC checking
> (ECRC).  This patch will enable/disable ECRC checking by
> setting/clearing the ECRC Check Enable and/or ECRC Generation Enable
> bits for devices that support ECRC.
> 
> The ECRC setting is controlled by the "pci=ecrc=<policy>" command-line
> option. If this option is not set or is set to 'bios", the enable and
> generation bits are left in whatever state that firmware/BIOS set
> them to. The "off" setting turns them off, and the "on" option turns
> them on (if the device supports it).
> 
> Turning ECRC on or off can be a data integrity versus performance
> tradeoff.  In theory, turning it on will catch more data errors,
> turning it off means possibly better performance since CRC does not
> need to be calculated by the PCIe hardware and packet sizes are
> reduced.
> 
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> ---
> 

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
