Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXJDDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXJDDkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 23:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXJDDj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 23:39:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:43538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXJDDj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 23:39:58 -0400
Subject: Re: [patch take 2][Intel-IOMMU] Fix for IOMMU early crash
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com, paulus@samba.org,
       kristen.c.accardi@intel.com
In-Reply-To: <20071004013606.GA14755@askeshav-devel.jf.intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
	 <18148.12140.21118.252581@cargo.ozlabs.ibm.com>
	 <20070911174231.GC24627@askeshav-devel.jf.intel.com>
	 <20070912192854.GA32610@askeshav-devel.jf.intel.com>
	 <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
	 <20071003211327.GA14159@askeshav-devel.jf.intel.com>
	 <1191460773.22572.139.camel@pasglop>
	 <20071004013606.GA14755@askeshav-devel.jf.intel.com>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 13:39:39 +1000
Message-Id: <1191469179.22572.145.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Why don't you use the new struct dev_archdata mechanism ? That's what I
> > use on powerpc to provide optional iommu linkage to any device in the
> > system.
> Good one. I will certainly try out your idea and will update the list
> tomorrow.

The advantage is that it allows to completely isolate the iommu code
from any dependency to PCI, which means you can implement DMA ops
support for various platform devices or other fancy things. Maybe not
the most useful in x86-land, but still ;-)

Ben.


