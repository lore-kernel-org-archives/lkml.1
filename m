Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112Ab0A0KFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0A0KFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104Ab0A0KFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:05:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0A0KFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:05:30 -0500
Date: Wed, 27 Jan 2010 11:04:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [git pull] IOMMU fixes for 2.6.33-rc5
Message-ID: <20100127100457.GB8642@elte.hu>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc5
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes
> 
> Joerg Roedel (5):
>       x86/amd-iommu: Fix possible integer overflow
>       x86/amd-iommu: Fix NULL pointer dereference in __detach_device()
>       x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
>       x86/amd-iommu: Fix deassignment of a device from the pt_domain
>       Merge branches 'amd-iommu/fixes' and 'dma-debug/fixes' into iommu/fixes
> 
> Thiago Farina (1):
>       lib/dma-debug.c: mark file-local struct symbol static.
> 
>  arch/x86/include/asm/amd_iommu_proto.h |    1 +
>  arch/x86/kernel/amd_iommu.c            |   23 ++++++++++++++++-------
>  arch/x86/kernel/amd_iommu_init.c       |    3 +++
>  lib/dma-debug.c                        |    2 +-
>  4 files changed, 21 insertions(+), 8 deletions(-)
> 
> The patches fix several issues with device kvm device assignement when the 
> amd iommu driver is configured to run in passthrough mode. One patch fixes a 
> possible integer overflow in the driver as well. The last patch in the 
> series fixes a build warning in the dma-api debug code. Please pull.

Pulled, thanks a lot Joerg!

	Ingo
