Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZERUUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZERUUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZERUUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:20:41 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1957 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZERUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:20:40 -0400
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Joe Perches <joe@perches.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <cone.1242669880.118150.4276.1000@deskpiie>
References: <cone.1240858632.795110.5316.1000@onepiie>
	 <20090428072519.GA12170@liondog.tnic>
	 <1240913055.29860.14.camel@maxim-laptop>
	 <cone.1240949852.549814.7466.1000@mentalhome>
	 <1240950704.3781.12.camel@maxim-laptop>
	 <cone.1241299309.265715.3948.1000@mentalhome>
	 <20090503184617.GA3555@liondog.tnic>
	 <cone.1241648222.299676.7476.1000@mentalhome>
	 <20090509171432.GA31126@liondog.tnic>
	 <cone.1242065107.695268.13534.1000@onepiie>
	 <20090512060231.GB26286@liondog.tnic>
	 <cone.1242669880.118150.4276.1000@deskpiie>
Content-Type: text/plain
Date: Mon, 18 May 2009 13:20:32 -0700
Message-Id: <1242678032.1572.122.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 20:04 +0200, Peter Feuerer wrote:
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> new file mode 100644
> index 0000000..99ae2e6
> --- /dev/null
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -0,0 +1,530 @@
[]
> +#define acerhdf_printk(loglevel, fmt, args...) \
> +	printk(loglevel "acerhdf: " fmt, ## args);
> +
> +#define acerhdf_notice(fmt, args...) \
> +	acerhdf_printk(KERN_NOTICE, fmt, ## args);
> +
> +#define acerhdf_error(fmt, args...) \
> +	acerhdf_printk(KERN_ERR, fmt, ## args);

Could you please not create new prefixes for printk?

I think:

#define pr_fmt(fmt) "acerhdf:" fmt
and use of pr_err and pr_notice would be better.

cheers, Joe

