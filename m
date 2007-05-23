Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXEWIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXEWIz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXEWIzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:55:13 -0400
Received: from [129.215.188.97] ([129.215.188.97]:42455 "EHLO just"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757484AbXEWIzM (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:55:12 -0400
X-Greylist: delayed 1981 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 04:55:11 EDT
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: richard.griffiths@windriver.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Date: Wed, 23 May 2007 09:21:32 +0100
User-Agent: KMail/1.9.6
Cc: Linux-kernel@vger.kernel.org
References: <1179871779.24163.11.camel@localhost.localdomain>
In-Reply-To: <1179871779.24163.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705230921.32974.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 23:09:39 Richard Griffiths wrote:
> Venerable cramfs fs Linear XIP patch originally from MontaVista, used in
> the embedded Linux community for years, updated for 2.6.21. Tested on
> several systems with NOR Flash. PXA270, TI OMAP2430, ARM Versatile and
> Freescale iMX31ADS.

> +#else /* CONFIG_CRAMFS_LINEAR */
> +        /*
> +         * The physical location of the cramfs image is specified as
> +         * a mount parameter.  This parameter is mandatory for obvious

You've used spaces here instead of tabs, probably worth replacing.

> +/*
> + * We hold the mm semaphore for reading and vma->vm_mm->page_table_lock
> + */
> +static inline void break_cow(struct vm_area_struct * vma, struct page * 
new_page, unsigned long address,
> +                pte_t *page_table)
> +{
> +        pte_t entry;

Here again.

> +                        /*
> +                         * Handle COW of XIP memory.
> +                         * Note that the source memory actually isn't a ram
> +                         * page so no struct page is associated to the 
source
> +                         * pte.
> +                         */

This whole section too.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
