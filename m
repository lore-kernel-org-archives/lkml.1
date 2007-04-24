Return-Path: <linux-kernel-owner+w=401wt.eu-S1423050AbXDXTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423050AbXDXTdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423063AbXDXTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:33:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:47952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423050AbXDXTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:33:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 7/8] Support for legacy ISA devices
Date: Tue, 24 Apr 2007 21:31:09 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <20070424061038.252959000@intel.com>
In-Reply-To: <20070424061038.252959000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242131.10139.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 08:03:06 Ashok Raj wrote:
> Floppy disk drivers dont work well with DMA remapping.

What is the problem? You can't allocate mappings <16MB?

> Its possible to  
> extend the current use for x86_64, but the gain is very little. If someone
> feels compelled to clean this up, its up for grabs. Since these use 16M, we 
> just provide a unity map for the ISA bridge device.
> 

While it's probably not worth for the floppy there are other devices
with similar weird addressing limitations. Some generic handling of it
would be nice.

-Andi
