Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbZF1Qoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbZF1Qoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbZF1QmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:42:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:59207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760241AbZF1QmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:42:24 -0400
Subject: Re: [PATCH 11/62] arch/x86/kernel/ds.c: Remove unnecessary
 semicolons
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <2d424f9003647310e1d7a8a989d08427bd568a57.1246173680.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <2d424f9003647310e1d7a8a989d08427bd568a57.1246173680.git.joe@perches.com>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 22:10:48 +0530
Message-Id: <1246207248.4998.1.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 09:26 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/ds.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
> index 48bfe13..8025e2d 100644
> --- a/arch/x86/kernel/ds.c
> +++ b/arch/x86/kernel/ds.c
> @@ -517,7 +517,7 @@ static inline unsigned long bts_get(const char *base, enum bts_field field)
>  
>  static inline void bts_set(char *base, enum bts_field field, unsigned long val)
>  {
> -	base += (ds_cfg.sizeof_ptr_field * field);;
> +	base += (ds_cfg.sizeof_ptr_field * field);
>  	(*(unsigned long *)base) = val;
>  }
>  

This is already fix in -tip by :

commit feaa0457ec8351cae855edc9a3052ac49322538e
Author: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date:   Sat Jun 20 16:15:40 2009 +0530

    x86: ds.c fix invalid assignment

Thanks,
--
JSR

