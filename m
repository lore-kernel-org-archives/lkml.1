Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbYBUL03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbYBUL03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYBUL0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:26:19 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:17228 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYBUL0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:26:18 -0500
Subject: Re: [patch 3/3] s390: cleanup - drop .data.idt section in
	vmlinux.lds script
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: gorcunov@gmail.com
Cc: takata@linux-m32r.org, dhowells@redhat.com, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220194444.348896940@gmail.com>
References: <20080220194123.114692303@gmail.com>
	 <20080220194444.348896940@gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 21 Feb 2008 12:26:13 +0100
Message-Id: <1203593173.3489.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 22:41 +0300, gorcunov@gmail.com wrote:
> The section .data.idt is not used at all - so drop it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

> ---
> 
>  vmlinux.lds.S |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: linux-2.6.git/arch/s390/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/s390/kernel/vmlinux.lds.S	2008-02-06 23:15:14.000000000 +0300
> +++ linux-2.6.git/arch/s390/kernel/vmlinux.lds.S	2008-02-20 22:30:30.000000000 +0300
> @@ -71,11 +71,6 @@ SECTIONS
>  	. = ALIGN(PAGE_SIZE);
>  	__nosave_end = .;
> 
> -	. = ALIGN(PAGE_SIZE);
> -	.data.page_aligned : {
> -		*(.data.idt)
> -	}
> -
>  	. = ALIGN(0x100);
>  	.data.cacheline_aligned : {
>  		*(.data.cacheline_aligned)
> 
-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


