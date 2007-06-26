Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbXFZULN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbXFZULN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXFZUK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:10:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:63360 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbXFZUK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:10:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="243650403"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Date: Tue, 26 Jun 2007 13:10:15 -0700
User-Agent: KMail/1.9.7
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <46813E0F.1060806@linux.intel.com> <20070626173157.GD5244@one.firstfloor.org>
In-Reply-To: <20070626173157.GD5244@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261310.16221.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 26, 2007 10:31:57 Andi Kleen wrote:
> > >>(and I think it mostly already doesn't even without that)
> > >
> > >It uses /sys/bus/pci/* which is not any better as seen from the
> > > IOMMU.
> > >
> > >Any interface will need to be explicit because user space needs to
> > > know which
> > >DMA addresses to put into the hardware. It's not enough to just
> > >transparently
> > >translate the mappings.
> >
> > that's what DRM is used for nowadays...
>
> But DRM does support much less hardware than the X server?

Yeah, the number of DRM drivers is relatively small compared to X or 
fbdev, but for simple DMA they're fairly easy to write.

> Perhaps we just need an ioctl where an X server can switch this.

Switch what?  Turn on or off transparent translation?

Jesse
