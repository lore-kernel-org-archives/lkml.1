Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbYCGXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbYCGXVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYCGXU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:20:57 -0500
Received: from ns.suse.de ([195.135.220.2]:35353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761965AbYCGXUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:20:55 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64: reserve dma32 early for gart
Date: Sat, 8 Mar 2008 00:20:50 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
References: <86802c440803071502o50a06199i6afeb5996f207c6d@mail.gmail.com>
In-Reply-To: <86802c440803071502o50a06199i6afeb5996f207c6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803080020.50474.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 March 2008 00:02:50 Yinghai Lu wrote:
> 
> 



>solution will be:
>1. make memmap allocation get memory above 4G...
>2. reserve some dma32 range early before we try to set up memmap for all.
>and release that before pci_iommu_alloc, so gart or swiotlb could get some
>range under 4g limit for sure.

Funny we had (1) before vmemmap for some time, but it looks like
that regressed with vmemmap Anyways I think (1) alone should be enough, is (2) 
really needed?

-Andi
