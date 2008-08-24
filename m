Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYHXWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYHXWQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYHXWQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:16:26 -0400
Received: from main.gmane.org ([80.91.229.2]:50777 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYHXWQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:16:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Mon, 25 Aug 2008 01:16:01 +0300
Organization: Private
Message-ID: <87d4jyys7y.fsf@jondo.cante.net>
References: <fa.c8YPWdZHXAabbZwTVLAgq9ahOlE@ifi.uio.no>
	<fa.9B7J3O7801PlFtm4WwuBX/J0kU8@ifi.uio.no>
	<fa.ES0QYHe349FfrOTaqTun1n3qaYk@ifi.uio.no>
	<fa.8FK+C3lDiXBnZCV9FTofTkm6PJE@ifi.uio.no>
	<fa.cN6j0N4TRlTlG7oLEhhT8Wj2N7A@ifi.uio.no>
	<fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no> <48B1D82C.5000107@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:TQCUiTgalTp0w0Ar3V1odlnGAsY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:

> Jari Aalto wrote:
>>>> $ grep -Ei 'iommu|agp' /boot/config-2.6.25-2-amd64
>>>> CONFIG_GART_IOMMU=y
>>>> CONFIG_CALGARY_IOMMU=y
>>>> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
>>>> CONFIG_IOMMU_HELPER=y
>>>> CONFIG_AGP=y
>>>> CONFIG_AGP_AMD64=y
>>>> CONFIG_AGP_INTEL=m
>>>> CONFIG_AGP_SIS=m
>>>> CONFIG_AGP_VIA=m
>>> Do you have problems without "iommu=XXX"?
>>
>> ...whole harddisk to corrupt and I had to reinstall everything.
>> It might have been a little older kernel (2.6.23?), but I don't recall
>> it exactly.
>>
>> Would you suggest that "immu=off" would be best option?
>
> No, you can't use iommu=off. If you have memory located over 4GB and
> devices which can only do 32-bit DMA then you need some kind of IOMMU
> support, otherwise things will just blow up.
>
> If you use no options and it's enabled in the kernel config it should be
> using the GART IOMMU built into the CPU on this machine..

So, with newest kernel I should just leave 'iommu' out from boot
options. I could try to upgrade even to 2.6.26, which Debian has in
unstable repository.

What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
there still appears "Out of Iommu space" messages? What kind of logs
should I post?

I'm a bit nervous due to past experience of complete hardd disk
corruption. But if that was problem with the old kernel and more later
versions are safer in this repect, I could once more.

Jari

