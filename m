Return-Path: <linux-kernel-owner+w=401wt.eu-S937105AbXG0KAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937105AbXG0KAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbXG0KAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:00:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55561 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655AbXG0KAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:00:05 -0400
Date: Fri, 27 Jul 2007 11:00:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, dhowells@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
Message-ID: <20070727100004.GV27237@ftp.linux.org.uk>
References: <200707270944.LAA17167@ifs.emn.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707270944.LAA17167@ifs.emn.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:44:35AM +0200, Yoann Padioleau wrote:
>  	pte = pte_alloc_kernel(pme, va);
> -	if (pte != 0) {
> +	if (pte != NULL) {
>  		err = 0;
>  		set_pte(pte, mk_pte_phys(pa & PAGE_MASK, prot));
>  	}
> @@ -99,7 +99,7 @@ void *consistent_alloc(gfp_t gfp, size_t
>  
>  	/* allocate some common virtual space to map the new pages */
>  	area = get_vm_area(size, VM_ALLOC);
> -	if (area == 0) {
> +	if (area == NULL) {
>  		free_pages(page, order);
>  		return NULL;

Same comment about comparisons with NULL after allocation...
