Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZKBQAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZKBQAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZKBQAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:00:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:34815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbZKBQAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:00:44 -0500
Date: Mon, 2 Nov 2009 17:00:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
In-Reply-To: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911021658110.4203@wotan.suse.de>
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-569044745-1257177648=:4203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-569044745-1257177648=:4203
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 31 Oct 2009, André Goddard Rosa wrote:

> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> index f7b9cdc..b52c1f8 100644
> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
> 
>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>  	d_cache = CPLB_L1_CHBL;
> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH

As this one is fixing a *real* bug, please separate it out from the other 
changes which basically just fix typos in comments.


On the other hand, please merge all the other changes together into one 
larger patch. We don't want gazillions of commits because you have found 
gazillions of words typed wrongly in comments.

Thanks for taking care,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-569044745-1257177648=:4203--
