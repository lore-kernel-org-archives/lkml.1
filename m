Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYF0VZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYF0VZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbYF0VZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:25:01 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:7521 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbYF0VY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:24:58 -0400
X-BigFish: VPS-35(zz1432R98dR7efV1805Mzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K34BVV-03-GTS-01
Date: Fri, 27 Jun 2008 12:59:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080627105954.GN1303@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <20080627081807.GA6562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080627081807.GA6562@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 27 Jun 2008 10:59:55.0288 (UTC) FILETIME=[EE9FB980:01C8D844]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 10:18:08AM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi,
> > 
> > this is the first post of the initial driver for AMD IOMMU hardware. 
> > The driver is tested on hardware with various loads (disk and network) 
> > and showed no problems.
> > 
> > It currently supports DMA remapping using the dma_ops API in the x86 
> > architecture code. It also supports isolation of device DMA address 
> > spaces as far as the hardware allows that (means each device can get 
> > its own DMA address space and can't access the DMA memory of other 
> > devices).
> 
> the code looks very clean. I guess down the line we might want to think 
> about making all the externally visible knobs transparent: there should 
> be only one way to disable the iommu via the boot command line (be that 
> an AMD or Intel one), etc.
> 
> i have created a new -tip topic for this: tip/x86/amd-iommu and have 
> applied your patches there - thanks Joerg. You can pick up the 
> integrated tree via:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> please check whether the integrated end result still works fine.
> [ Obviously nobody but you can test this on real hw ;-) ]

Ok, I am testing the tip-branch for AMD IOMMU currently on real hardware
and everything looks very good. I will continue with load tests over the
weekend to be sure.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

