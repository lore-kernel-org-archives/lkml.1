Return-Path: <linux-kernel-owner+w=401wt.eu-S1762458AbXFDXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbXFDXVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbXFDXU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:20:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:4342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbXFDXUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:20:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="235507336"
Date: Mon, 4 Jun 2007 16:17:18 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 01/10] DMAR detection and parsing logic
Message-ID: <20070604231717.GC9948@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.076940000@askeshav-devel.jf.intel.com> <20070604230356.GN20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604230356.GN20299@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 07:03:56PM -0400, Jeff Garzik wrote:
> 
> Is there no way at all, other than ACPI, to find this stuff?
This is as clean as possible without letting ACPI to parse this
DMA remapping unit. The only thing we might be using is the
acpi data struct.

-Anil
