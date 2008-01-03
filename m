Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYACSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYACSPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYACSPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:15:11 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46068 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbYACSPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:15:09 -0500
Date: Thu, 3 Jan 2008 20:14:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH 20/52] KVM: Add missing #include <asm/pgtable.h>
Message-ID: <20080103181448.GB7141@does.not.exist>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com> <1198998638-22713-21-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1198998638-22713-21-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 09:10:06AM +0200, Avi Kivity wrote:
> Needed for empty_zero_page.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---
>  drivers/kvm/kvm_main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
> index 469e6b4..d6c5191 100644
> --- a/drivers/kvm/kvm_main.c
> +++ b/drivers/kvm/kvm_main.c
> @@ -46,6 +46,7 @@
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
>  #include <asm/desc.h>
> +#include <asm/pgtable.h>
>  
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");

Can you merge this patch into the previous one for the final submission?

For being able to bisect (which has proven to be a very valuable help) 
we aim at having the tree between any two commits both compiling and 
working.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

