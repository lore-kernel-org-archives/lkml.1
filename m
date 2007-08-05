Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXHEAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXHEAP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765229AbXHEAPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:15:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:59502 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765231AbXHEAPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:15:48 -0400
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA
	mapping"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       Olaf Hering <olh@suse.de>, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B4B7C6.1040107@s5r6.in-berlin.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca>  <46B4B7C6.1040107@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 10:15:26 +1000
Message-Id: <1186272926.938.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > If setting 32-bit DMA mask fails on ppc64, that sounds like a problem
> > with the DMA implementation on that architecture. There are enough cards
> > out there that only support 32-bit DMA that this really needs to work..
> 
> Yes, could the PPC folks please have a look at it?  Thanks.

Smells like we may have a bug there. No worries though, all current PPC
machines have an iommu that will not give out addresses above 32 bits
anyway, but I'll double check what's up.

Do you see something in dmesg when that happens ?

Ben.


