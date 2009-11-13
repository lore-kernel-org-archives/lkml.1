Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZKMPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZKMPJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZKMPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:09:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:38203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbZKMPI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:08:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,737,1249282800"; 
   d="scan'208";a="746670686"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 13 Nov 2009 15:09:00 +0000
Subject: RE: [PATCH] Add COH 901 318 DMA block driver v4
Thread-Topic: [PATCH] Add COH 901 318 DMA block driver v4
Thread-Index: AcphfE1bct5Ipe2aTIqVv5ztIXsO/gC9pOFw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B7C11778@irsmsx504.ger.corp.intel.com>
References: <1257798973-11943-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1257798973-11943-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> ChangeLog v3->v4
> - Removed the useless forward declaration of structs by arranging
>   #includes correctly. (Alan Cox)
> - NULL check ordering, exit on failure etc (Alan Cox)
> - Fixed a possible overflow in if statement. (Alan Cox)
> - Tag IO areas as __iomem (Alan Cox)
> - Check for base adresss NULL before operating on pointer on
>   several spots. (Alan Cox)
> - Removed dma_map() and dma_unmap() - clients shall do this.
>   (Maciej)
> - Add spin_unlock() in error path for coh901318_lli_fill_sg.
>   (Maciej)
> - Hope it is fine now!
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>