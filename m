Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYGHUcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYGHUcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYGHUcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:32:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33472 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbYGHUcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:32:02 -0400
Date: Tue, 8 Jul 2008 14:45:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080708124504.GA16313@elf.ucw.cz>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-26 21:27:37, Joerg Roedel wrote:
> This patch adds the Kconfig entry for the AMD IOMMU driver.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/Kconfig |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e0edaaa..5a82f18 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -549,6 +549,13 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
>  	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
>  	  If unsure, say Y.
>  
> +config AMD_IOMMU
> +	bool "AMD IOMMU support"
> +	select SWIOTL

SWIOTLB?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
