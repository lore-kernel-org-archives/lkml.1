Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYFZUiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYFZUiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYFZUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:38:13 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:11705 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYFZUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:38:12 -0400
X-BigFish: VPS-35(zz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K337Z6-03-0WC-01
Date: Thu, 26 Jun 2008 22:37:58 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080626203758.GK1303@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <200806262237.15864.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200806262237.15864.rjw@sisk.pl>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 26 Jun 2008 20:37:58.0682 (UTC) FILETIME=[851FE7A0:01C8D7CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:37:14PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 26 of June 2008, Joerg Roedel wrote:
> > Hi,
> 
> Hi,
> 
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
> Do you implement suspend/resume callbacks for the IOMMU and if so, which patch
> in the series does introduce them?

No, These callbacks are not implemented yet. But I plan to do so in a
later version.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

