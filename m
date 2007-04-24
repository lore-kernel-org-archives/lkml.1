Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXDXWEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXDXWEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161819AbXDXWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:04:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161172AbXDXWEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:04:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Miller <davem@davemloft.net>
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Date: Wed, 25 Apr 2007 00:03:57 +0200
User-Agent: KMail/1.9.6
Cc: ashok.raj@intel.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com, shaohua.li@intel.com
References: <200704242312.54738.ak@suse.de> <20070424213835.GB31920@linux-os.sc.intel.com> <20070424.145026.128110905.davem@davemloft.net>
In-Reply-To: <20070424.145026.128110905.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250003.57968.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 23:50:26 David Miller wrote:
> From: Ashok Raj <ashok.raj@intel.com>
> Date: Tue, 24 Apr 2007 14:38:35 -0700
> 
> > Its not clear if we have a very generic device breakage.. most devices
> > on these platforms are going to be more recent, (except maybe some
> > legacy fd)... 
> 
> I'm not so sure, there are some "modern" sound cards that have
> a 31-bit DMA addressing limitation because they use the 31st
> bit as a status bit in their DMA descriptors :-)

There's also a 2GB only megaraid RAID controller that's pretty popular 
because Dell shipped it for a long time.

-Andi



