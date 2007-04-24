Return-Path: <linux-kernel-owner+w=401wt.eu-S1422926AbXDXTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422926AbXDXTdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423063AbXDXTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:33:22 -0400
Received: from mx1.suse.de ([195.135.220.2]:35039 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422926AbXDXTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:33:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Date: Tue, 24 Apr 2007 21:33:15 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <20070424061038.389587000@intel.com>
In-Reply-To: <20070424061038.389587000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242133.16219.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 08:03:07 Ashok Raj wrote:
> Some devices may not support entire 64bit DMA. In a situation where such 
> devices are co-located in a shared domain, we need to ensure there is some 
> address space reserved for such devices without the low addresses getting
> depleted by other devices capable of handling high dma addresses.

Sorry, but you need to find some way to make this usually work without special
options. Otherwise users will be unhappy.

An possible way would be to allocate space upside down from the limit of the
device. Then the lower areas should be usually free.

-Andi
