Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYHXNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYHXNmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHXNmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 09:42:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:34852 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYHXNmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 09:42:35 -0400
To: Jari Aalto <jari.aalto@cante.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
References: <87od3k2egi.fsf@jondo.cante.net>
	<m3vdxrhq0o.fsf@maximus.localdomain>
	<200808231458.39206.alistair@devzero.co.uk>
	<874p5a24gt.fsf@jondo.cante.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 24 Aug 2008 15:42:32 +0200
In-Reply-To: <874p5a24gt.fsf@jondo.cante.net> (Jari Aalto's message of "Sun\, 24 Aug 2008 11\:37\:54 +0300")
Message-ID: <m3iqtqzfzr.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jari Aalto <jari.aalto@cante.net> writes:

>>From Debian stock kernel:
>
> $ grep -Ei 'iommu|agp' /boot/config-2.6.25-2-amd64
> CONFIG_GART_IOMMU=y
> CONFIG_CALGARY_IOMMU=y
> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=m
> CONFIG_AGP_SIS=m
> CONFIG_AGP_VIA=m

Should be fine. SWIOTLB is there for a backup, most (?) Intel machines
don't have IOMMU (even the newest desktop boards).

> Are these the correct boot options, without swiotlb?
>
>    iommu=noagp,noaperture,off
>
> Or just:
>
>    iommu=off

Do you have problems without "iommu=XXX"?
-- 
Krzysztof Halasa
