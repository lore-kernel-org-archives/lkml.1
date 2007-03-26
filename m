Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXCZBdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXCZBdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXCZBdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:33:22 -0400
Received: from web36707.mail.mud.yahoo.com ([209.191.85.41]:31195 "HELO
	web36707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933340AbXCZBdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:33:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3tT1zjzRrBJq3CNEKWai1sRwBFbhpmWpNyh3QT8n19xCtS15wlL0OG9jLYxATSz88T9mWKwAghAYLdXTqgprEb+P7HLwBeuXjFkqWrnzYDeLfiKpVtqvLzNv9l6FF5HjROlnj5ILnjploIQpL3bzu8c7cCgP2vQQXEya0CQK36s=;
X-YMail-OSG: Wi2NDBUVM1lN1QjiEVi1Q1kpP4sjP.ueSAy_mOUcJuxxO_AOjZmRlG7r8iENZwa06fg2amXIYOcuO5ID2JHiLwp0mGkyl8LuRkSohfMU__g_hXNZTdhJo5rddofbSe_vOkubAR682RyqztwuJibTIdLv
Date: Sun, 25 Mar 2007 18:33:20 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] tifm_sd: add missing \n
To: Daniel Drake <dsd@gentoo.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070325222414.C16C57B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <302069.50522.qm@web36707.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, this is fixed in already queued patch set.

--- Daniel Drake <dsd@gentoo.org> wrote:

> Noticed this in user logs.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
> Index: linux/drivers/mmc/tifm_sd.c
> ===================================================================
> --- linux.orig/drivers/mmc/tifm_sd.c
> +++ linux/drivers/mmc/tifm_sd.c
> @@ -676,7 +676,7 @@ static void tifm_sd_abort(unsigned long 
>  	struct tifm_sd *host = (struct tifm_sd*)data;
>  
>  	printk(KERN_ERR DRIVER_NAME
> -	       ": card failed to respond for a long period of time");
> +	       ": card failed to respond for a long period of time\n");
>  
>  	tifm_sd_terminate(host);
>  	tifm_eject(host->dev);
> 



 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
