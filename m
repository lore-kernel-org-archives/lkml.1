Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZEEP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZEEP3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZEEP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:29:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54093 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZEEP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:29:40 -0400
Date: Tue, 5 May 2009 17:31:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       linux-xtensa@linux-xtensa.org
Subject: Re: [PATCH] xtensa: generalize logic for variant/irq.h inclusion
Message-ID: <20090505153150.GA18084@uranus.ravnborg.org>
References: <4A0054A0.3030104@emlix.com> <1241535734-17479-1-git-send-email-dg@emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1241535734-17479-1-git-send-email-dg@emlix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 05:02:14PM +0200, Daniel Glöckner wrote:
> CONFIG_VARIANT_IRQ_SWITCH has been replaced by CONFIG_VARIANT_IRQ_EXT
> and a #define VARIANT_HAS_IRQ_ENABLE in variant/irq.h.
> 
> This change was made to allow further extensions to the irq handling by
> the variant in variant/irq.h independent of the CONFIG_VARIANT_IRQ_SWITCH
> functionality and without forcing all variants to provide this header.
> 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> ---
>  arch/xtensa/Kconfig                              |    4 ++--
>  arch/xtensa/configs/s6105_defconfig              |    2 +-
>  arch/xtensa/include/asm/irq.h                    |    6 ++++--
>  arch/xtensa/variants/s6000/include/variant/irq.h |    1 +
>  4 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index ac02f3c..76dee02 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -57,7 +57,7 @@ source "kernel/Kconfig.freezer"
>  config MMU
>  	def_bool n
>  
> -config VARIANT_IRQ_SWITCH
> +config VARIANT_IRQ_EXT
>  	def_bool n

Common practice is to name such symbols "HAVE_*".
So in your case:

config HAVE_VARIANT_IRQ_EXT

	Sam
