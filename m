Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbZJIXhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbZJIXhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbZJIXho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:37:44 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:6831 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761550AbZJIXhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:37:43 -0400
Date: Fri, 9 Oct 2009 16:37:07 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Message-ID: <20091009233707.GA24745@hexapodia.org>
References: <20091009061729.GA31242@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009061729.GA31242@hexapodia.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 11:17:29PM -0700, Andy Isaacson wrote:
> I'm testing DMAR support on 2.6.32 on Intel VT-d laptop platforms.  It
> was pretty stable circa 2.6.31-rc5 (we have dozens of machines running
> 2.6.31-rc8), but in the last two weeks I've had a bunch of instability
> on Linus' tip kernels that looked potentially like IOMMU badness.
> 
> For example,
> <20090928191644.GR12922@hexapodia.org>
> http://lkml.org/lkml/2009/9/28/201
> 
> Today while running 817b33d38 I got the following (on a Thinkpad X200
> I'd replaced the Dell with, just in case it was previously-good hardware
> going bad).
> 
> [   29.450550] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
> [   30.022328] DRHD: handling fault status reg 3
> [   30.022328] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
> [   30.022328] DMAR:[fault reason 05] PTE Write access is not set
> [   30.146136] DRHD: handling fault status reg 3
> [   30.248938] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
> [   30.248939] DMAR:[fault reason 05] PTE Write access is not set
> 
> The full output of fsck and full dmesg are at the URL below.

I also have a "e2image -r" for this filesystem.  Please let me know if
you'd like any further information.

-andy
