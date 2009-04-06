Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZDFSp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZDFSp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZDFSpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:45:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:47066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZDFSpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="679222528"
Date: Mon, 6 Apr 2009 11:44:48 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH v2] PCI: Add support for turning PCIe ECRC on or off
Message-ID: <20090406114448.1403297f@hobbes>
In-Reply-To: <20090403220136.22113.83729.stgit@bob.kio>
References: <20090403220131.22113.56040.stgit@bob.kio>
	<20090403220136.22113.83729.stgit@bob.kio>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Apr 2009 16:01:36 -0600
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

Applied to my for-linus branch, thanks Andrew.

-- 
Jesse Barnes, Intel Open Source Technology Center
