Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZASR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZASR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZASR7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:59:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56817 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZASR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:59:24 -0500
Date: Mon, 19 Jan 2009 09:59:19 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: garyhade@us.ibm.com, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: get_nid_for_pfn() returns int
Message-ID: <20090119175919.GA7476@us.ibm.com>
References: <4973AEEC.70504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4973AEEC.70504@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 11:36:28PM +0100, Roel Kluin wrote:
> get_nid_for_pfn() returns int
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> vi drivers/base/node.c +256
> static int get_nid_for_pfn(unsigned long pfn)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 43fa90b..f8f578a 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -303,7 +303,7 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
>  	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
>  	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
>  	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
> -		unsigned int nid;
> +		int nid;
> 
>  		nid = get_nid_for_pfn(pfn);
>  		if (nid < 0)

My mistake.  Good catch.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
