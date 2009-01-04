Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZADKaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZADKaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZADK35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:29:57 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22942 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZADK34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:29:56 -0500
X-BigFish: VPS-28(zz1432R98dR1805M936fO7cf0izzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KCXZTA-04-6VL-01
Date: Sun, 4 Jan 2009 11:29:33 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: iommu build failure
Message-ID: <20090104102933.GA25848@amd.com>
References: <alpine.LNX.1.10.0901040152430.5377@jikos.suse.cz> <20090104090700.GA12938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090104090700.GA12938@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Jan 2009 10:29:33.0525 (UTC) FILETIME=[55AB0050:01C96E57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 10:07:00AM +0100, Ingo Molnar wrote:
> 
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > Hi,
> > 
> > current Linus' tree (7d3b56ba37) doesn't build for me (config can be found 
> > on [1]):
> > 
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `alloc_iommu': drivers/pci/dmar.c:510: undefined reference to `iommu_calculate_agaw'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> yep, i already reported this yesterday.

Ingo queued a fix for this in his urgent-branch. I guess it will be
upstream soon.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

