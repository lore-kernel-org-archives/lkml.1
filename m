Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbYF0RJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbYF0RJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYF0RIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:08:52 -0400
Received: from 8bytes.org ([88.198.83.132]:57196 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbYF0RIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:08:51 -0400
Date: Fri, 27 Jun 2008 18:40:10 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627164010.GC10197@8bytes.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080627142558.GG18644@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627142558.GG18644@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 05:25:58PM +0300, Adrian Bunk wrote:
> On Thu, Jun 26, 2008 at 09:27:37PM +0200, Joerg Roedel wrote:
> > This patch adds the Kconfig entry for the AMD IOMMU driver.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/Kconfig |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index e0edaaa..5a82f18 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -549,6 +549,13 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
> >  	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
> >  	  If unsure, say Y.
> >  
> > +config AMD_IOMMU
> > +	bool "AMD IOMMU support"
> > +	select SWIOTL
> > +	depends on X86_64 && PCI
> > +	help
> > +	  Select this to get support for AMD IOMMU hardware in your system.
> > +
> >...
> 
> This tells neither what as IOMMU is nor whether my system actually has 
> one.
> 
> Please shortly describe in the help text what an IOMMU is and which
> AMD systems have an IOMMU.
> 
> The goal is that a system administrator building a kernel for his system 
> gets enough information for deciding whether to enable or disable this 
> option.

Ok, I will provide a new help text as an update to this patch series.

Joerg
