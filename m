Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYHXPI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYHXPI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYHXPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:08:51 -0400
Received: from main.gmane.org ([80.91.229.2]:36502 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYHXPIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:08:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sun, 24 Aug 2008 18:08:33 +0300
Organization: Private
Message-ID: <87y72mzc0e.fsf@jondo.cante.net>
References: <87od3k2egi.fsf@jondo.cante.net>
	<m3vdxrhq0o.fsf@maximus.localdomain>
	<200808231458.39206.alistair@devzero.co.uk>
	<874p5a24gt.fsf@jondo.cante.net> <m3iqtqzfzr.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:Cg46hg7JJi29HMAn/7Bkw3vxHkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Jari Aalto <jari.aalto@cante.net> writes:
>
>>>From Debian stock kernel:
>>
>> $ grep -Ei 'iommu|agp' /boot/config-2.6.25-2-amd64
>> CONFIG_GART_IOMMU=y
>> CONFIG_CALGARY_IOMMU=y
>> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
>> CONFIG_IOMMU_HELPER=y
>> CONFIG_AGP=y
>> CONFIG_AGP_AMD64=y
>> CONFIG_AGP_INTEL=m
>> CONFIG_AGP_SIS=m
>> CONFIG_AGP_VIA=m
>
> Should be fine. SWIOTLB is there for a backup, most (?) Intel machines
> don't have IOMMU (even the newest desktop boards).
>
>> Are these the correct boot options, without swiotlb?
>>
>>    iommu=noagp,noaperture,off
>>
>> Or just:
>>
>>    iommu=off
>
> Do you have problems without "iommu=XXX"?

Initially when the PC was installed (and had no IOMMU) options, that
cause the whole harddisk to corrupt and I had to reinstall everything.
It might have been a little older kernel (2.6.23?), but I don't recall
it exactly.

According to messages in syslog I tried to track down similar incidents
and found the iommu articles. But the information was like trial and
error.

Would you suggest that "immu=off" would be best option?

Thanks,
Jari

