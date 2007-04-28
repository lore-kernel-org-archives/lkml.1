Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXD1Kap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXD1Kap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXD1Kap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:30:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbXD1K37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:29:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
Date: Sat, 28 Apr 2007 12:25:15 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4632AE54.7030200@goop.org>
In-Reply-To: <4632AE54.7030200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281225.15849.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ===================================================================
> --- a/arch/i386/mm/hugetlbpage.c
> +++ b/arch/i386/mm/hugetlbpage.c
> @@ -183,6 +183,7 @@ follow_huge_addr(struct mm_struct *mm, u
>  	return page;
>  }
>  
> +#undef pmd_huge
>  int pmd_huge(pmd_t pmd)

Please handle that in the headers or rename it

-Andi
