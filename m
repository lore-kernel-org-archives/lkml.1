Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbYHDV14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbYHDV14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbYHDV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:27:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33665
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757672AbYHDV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:27:36 -0400
Date: Mon, 04 Aug 2008 14:27:33 -0700 (PDT)
Message-Id: <20080804.142733.193699664.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] sparc64: rename iommu_num_pages function to
 iommu_nr_pages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217865890-3593-3-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
	<1217865890-3593-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 4 Aug 2008 18:04:42 +0200

> @@ -35,7 +35,7 @@
>  
>  #define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
>  
> -static inline unsigned long iommu_num_pages(unsigned long vaddr,
> +static inline unsigned long iommu_nr_pages(unsigned long vaddr,
>  					    unsigned long slen)

Please, when you change the name of a function, fix up the indentation
of the arguments in the following lines of the declaration so that they
still line up properly.
