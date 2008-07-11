Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYGKOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYGKOLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYGKOLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:11:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34777 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbYGKOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:11:42 -0400
X-BigFish: VPS-2(zz1432R98dR7efV1805M9320iv19c2kzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UI33-03-R66-01
Date: Fri, 11 Jul 2008 16:11:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080711141124.GU14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <m1d4lk90vq.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m1d4lk90vq.fsf@frodo.ebiederm.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 11 Jul 2008 14:11:24.0689 (UTC) FILETIME=[009FB010:01C8E360]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:22:01AM -0700, Eric W. Biederman wrote:
> Joerg Roedel <joerg.roedel@amd.com> writes:
> 
> > Hi,
> >
> > this is the first post of the initial driver for AMD IOMMU hardware. The driver
> > is tested on hardware with various loads (disk and network) and showed no
> > problems.
> >
> > It currently supports DMA remapping using the dma_ops API in the x86
> > architecture code. It also supports isolation of device DMA address spaces as
> > far as the hardware allows that (means each device can get its own DMA address
> > space and can't access the DMA memory of other devices).
> >
> > Please give this code a good review and send me your comments about it so that
> > I can fix all possible bugs and objections and move this driver forward to
> > merging quality.
> 
> Small question.  Does this IOMMU also support irq remapping?
> 
> Intel is starting to merge support for their iommu that supports irq
> remapping and I am curious what the implications are going to be to
> support both of these iommus?

Yes, AMD IOMMU also has interrupt remapping support.

> Assuming their is irq remapping support it isn't tied to x2apic
> support in the cpus is it?

Not sure what you mean here. I am not aware of an x2apic on AMD.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

