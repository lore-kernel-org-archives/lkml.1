Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXDXVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXDXVNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965336AbXDXVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:13:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:53103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXDXVNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:13:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Date: Tue, 24 Apr 2007 23:12:54 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <200704242133.16219.ak@suse.de> <20070424203304.GB27911@linux-os.sc.intel.com>
In-Reply-To: <20070424203304.GB27911@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242312.54738.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 22:33:04 Ashok Raj wrote:

> With PCIE there is some benefit to keep dma addr low for performance reasons, 
> since it will use 	32bit Transaction level packets instead of 64bit.
> 
> This reservation is only required if we have some legacy device under a p2p 
> where its required to share its addr space with other devices. We could 
> implement a default when one is not specified to keep things simple.

We already have a couple of other IOMMU architectures who essentially have the same
problem. Have you checked how they solve this?

-Andi



