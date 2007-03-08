Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXCHIKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXCHIKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXCHIKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:10:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:46087 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965776AbXCHIKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:10:12 -0500
Subject: Re: Linux v2.6.21-rc3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200703072152.26479.arnd@arndb.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <1173263132.9349.47.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
	 <200703072152.26479.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 09:10:01 +0100
Message-Id: <1173341401.8635.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 21:52 +0100, Arnd Bergmann wrote:
> On Wednesday 07 March 2007 16:39:00 Linus Torvalds wrote:
> > So did you hunt it down to a particular cases where it triggers?
> 
> IIRC, it crashed on boot in the powerpc iommu code when slab
> debugging is enabled. Not sure if it was on Cell or on benh's
> powerbook though.

Not iommu code, but dma_alloc_coherent() for non-iommu 32 bits
machines :-) Oh and it wasn't slab but DEBUG_PAGEALLOC :-)

Ben.


