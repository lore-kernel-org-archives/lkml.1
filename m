Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXFZRcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXFZRcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXFZRcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:32:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45771 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbXFZRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:32:00 -0400
Date: Tue, 26 Jun 2007 19:31:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-ID: <20070626173157.GD5244@one.firstfloor.org>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org> <200706260912.45838.ak@suse.de> <20070626111324.GB4320@rhun.ibm.com> <p73645a675q.fsf@bingen.suse.de> <46812D79.8080306@linux.intel.com> <20070626153358.GA5244@one.firstfloor.org> <46813E0F.1060806@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46813E0F.1060806@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>(and I think it mostly already doesn't even without that)
> >
> >It uses /sys/bus/pci/* which is not any better as seen from the IOMMU.
> >
> >Any interface will need to be explicit because user space needs to know 
> >which
> >DMA addresses to put into the hardware. It's not enough to just 
> >transparently
> >translate the mappings.
> 
> that's what DRM is used for nowadays...

But DRM does support much less hardware than the X server?

Perhaps we just need an ioctl where an X server can switch this.

-Andi

