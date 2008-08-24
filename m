Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYHXIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYHXIew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYHXIen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:34:43 -0400
Received: from main.gmane.org ([80.91.229.2]:50458 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYHXIem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:34:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sun, 24 Aug 2008 11:34:32 +0300
Organization: Private
Message-ID: <878wum24mf.fsf@jondo.cante.net>
References: <87od3k2egi.fsf@jondo.cante.net>
	<m3vdxrhq0o.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:bV1TsPpJ2rQBJH9/j/xXf5F2QBU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Jari Aalto <jari.aalto@cante.net> writes:
>
>>         [1] Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:00:0d.0
>>         model name      : AMD Athlon(tm) X2 Dual Core Processor
>>         BE-2400
>
> grep GART_IOMMU .config

>From Debian stock kernel:

$ grep -Ei 'iommu|agp' /boot/config-2.6.25-2-amd64
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_IOMMU_HELPER=y
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m

Jari

