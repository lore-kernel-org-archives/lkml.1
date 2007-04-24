Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbXDXUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbXDXUex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXDXUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:34:53 -0400
Received: from mga06.intel.com ([134.134.136.21]:38062 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754378AbXDXUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233282859:sNHT20098673"
Message-ID: <462E69B0.6030908@linux.intel.com>
Date: Tue, 24 Apr 2007 13:33:52 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 7/8] Support for legacy ISA devices
References: <20070424060259.426374000@intel.com> <20070424061038.252959000@intel.com> <200704242131.10139.ak@suse.de>
In-Reply-To: <200704242131.10139.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:06 Ashok Raj wrote:
>> Floppy disk drivers dont work well with DMA remapping.
> 
> What is the problem? You can't allocate mappings <16MB?
>
floppy doesn't use the DMA mapping API :)
that's the problem
