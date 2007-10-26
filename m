Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXJZMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXJZMNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXJZMNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:13:10 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:46991 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXJZMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:13:09 -0400
X-Greylist: delayed 3032 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 08:13:09 EDT
Subject: Re: [patch] raid6: generate raid6tables.c with proper style
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071026081752.GA1232@elte.hu>
References: <20071026081752.GA1232@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Fri, 26 Oct 2007 13:26:31 +0200
Message-Id: <1193397991.7078.5.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fre, 26 10 2007 kl. 10:17 +0200, skrev Ingo Molnar:
> Subject: raid6: generate raid6tables.c with proper style
> From: Ingo Molnar <mingo@elte.hu>

[snip]

> Index: linux/drivers/md/mktables.c
> ===================================================================
> --- linux.orig/drivers/md/mktables.c
> +++ linux/drivers/md/mktables.c
> @@ -69,7 +69,9 @@ int main(int argc, char *argv[])
>      for ( j = 0 ; j < 256 ; j += 8 ) {
>        printf("\t\t");
>        for ( k = 0 ; k < 8 ; k++ ) {
> -	printf("0x%02x, ", gfmul(i,j+k));
> +        if (k)
> +	  printf(" ");
> +	printf("0x%02x,", gfmul(i,j+k));

What happened with the coding style here?


Simon Holm Thøgersen

