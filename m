Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZHRUW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZHRUW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZHRUW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:22:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51262 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZHRUW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:22:57 -0400
Subject: Re: Make LSM_MMAP_MIN_ADDR default match its help text.
From: Eric Paris <eparis@redhat.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
In-Reply-To: <m2prasq3q2.fsf@igel.home>
References: <200908172100.n7HL08SR001061@hera.kernel.org>
	 <20090818174736.GA23352@redhat.com>  <m2prasq3q2.fsf@igel.home>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 16:22:46 -0400
Message-Id: <1250626966.2239.2.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 22:14 +0200, Andreas Schwab wrote:
> Dave Jones <davej@redhat.com> writes:
> 
> >  config LSM_MMAP_MIN_ADDR
> >  	int "Low address space for LSM to from user allocation"
> 
> This sentence no verb.
> 
> Andreas.
> ---
> From 4ba5116764386ceb1a9da4cb6800defd84f0e3c1 Mon Sep 17 00:00:00 2001
> From: Andreas Schwab <schwab@linux-m68k.org>
> Date: Tue, 18 Aug 2009 22:08:43 +0200
> Subject: [PATCH] Fix prompt for LSM_MMAP_MIN_ADDR.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Acked-by: Eric Paris <eparis@redhat.com>



> ---
>  security/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 9c60c34..4d1a2e3 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -114,7 +114,7 @@ config SECURITY_ROOTPLUG
>  	  If you are unsure how to answer this question, answer N.
>  
>  config LSM_MMAP_MIN_ADDR
> -	int "Low address space for LSM to from user allocation"
> +	int "Low address space for LSM to protect from user allocation"
>  	depends on SECURITY && SECURITY_SELINUX
>  	default 65535
>  	help
> -- 
> 1.6.4
> 


