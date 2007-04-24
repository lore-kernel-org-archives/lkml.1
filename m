Return-Path: <linux-kernel-owner+w=401wt.eu-S1423064AbXDXTaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064AbXDXTaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423063AbXDXTaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:30:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:47686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423064AbXDXTaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:30:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 4/8] Supporting Zero Length Reads in Intel IOMMU.
Date: Tue, 24 Apr 2007 21:28:11 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <20070424061037.821838000@intel.com>
In-Reply-To: <20070424061037.821838000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242128.12057.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 08:03:03 Ashok Raj wrote:
> PCI specs permit zero length reads (ZLR) even if the mapping for that region 
> is write only. Support for this feature is indicated by the presence of a bit 
> in the DMAR capability. If a particular DMAR does not support this capability
> we map write-only regions as read-write.
> 
> This option can also provides a workaround for some drivers that request
> a write-only mapping when they really should request a read-write.
> (We ran into one such case in eepro100.c in handling rx_ring_dma)

Better just fix the drivers instead of adding such hacks

-Andi
