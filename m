Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYKFSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYKFSyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYKFSyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:54:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52420 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYKFSyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:54:09 -0500
Message-ID: <49133D15.4020607@garzik.org>
Date: Thu, 06 Nov 2008 13:53:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU fixes for 2.6.28
References: <20081106141555.GD22503@amd.com>
In-Reply-To: <20081106141555.GD22503@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi Ingo,
> 
> The following changes since commit 1e19b16a30c34c042f1eaa23db4c99bfad1dac0e:
>   Thomas Gleixner (1):
>         AMD IOMMU: use iommu_device_max_index, fix
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
> 
> Joerg Roedel (2):
>       AMD IOMMU: fix detection of NP capable IOMMUs
>       AMD IOMMU: fix lazy IO/TLB flushing in unmap path
> 
>  arch/x86/kernel/amd_iommu.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> This are 2 important bugfixes which fix lazy IO/TLB flushing with the
> driver. Please pull.

Even though the x86 maintainers probably don't require it, it would be 
nice if you could include the changes being pushed in the same email 
(provided the patch is under 400k).  Every little bit of additional 
review helps.

Regards,

	Jeff



