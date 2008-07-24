Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYGXPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYGXPom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYGXPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:44:19 -0400
Received: from gw.goop.org ([64.81.55.164]:42107 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYGXPoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:44:17 -0400
Message-ID: <4888A34D.8040607@goop.org>
Date: Thu, 24 Jul 2008 08:44:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Xen: Use native_pte_flags instead of native_pte_val
 for .pte_flags
References: <1216912546-6971-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1216912546-6971-1-git-send-email-ehabkost@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> Using native_pte_val triggers the BUG_ON() in the paravirt_ops
> version of pte_flags().
>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>   

Good point.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
> ---
>  arch/x86/xen/enlighten.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 3fc0c15..6b169b7 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1378,7 +1378,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
>  	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
>  
>  	.pte_val = xen_pte_val,
> -	.pte_flags = native_pte_val,
> +	.pte_flags = native_pte_flags,
>  	.pgd_val = xen_pgd_val,
>  
>  	.make_pte = xen_make_pte,
>   

