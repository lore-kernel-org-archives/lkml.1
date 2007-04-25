Return-Path: <linux-kernel-owner+w=401wt.eu-S1161621AbXDYG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161621AbXDYG5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXDYG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:57:19 -0400
Received: from ns1.suse.de ([195.135.220.2]:39102 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161621AbXDYG5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:57:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Date: Wed, 25 Apr 2007 08:55:48 +0200
User-Agent: KMail/1.9.6
Cc: David Miller <davem@davemloft.net>, ashok.raj@intel.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <200704242312.54738.ak@suse.de> <200704250003.57968.ak@suse.de> <462EAB13.4040104@zytor.com>
In-Reply-To: <462EAB13.4040104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250855.49242.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 03:12:51 H. Peter Anvin wrote:

> You can probably find almost any possible bitmask if you look long 
> enough.  Hardware vendors are notorious for this kind of "optimizations".

The nice thing is if this was solved in the IOMMU code then we could drop
(or not initialize) GFP_DMA on systems with that hardware. I guess GFP_DMA32 
would still need to stay for the graphics devices though.

Not sure how much difference it would make though, but at least Christoph Lameter
seems to think it would.

-Andi
