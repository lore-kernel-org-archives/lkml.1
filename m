Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZA2FqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZA2FqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZA2FqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:46:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56240 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbZA2FqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:46:10 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and clean up maple bus driver (3/3)
Date: Thu, 29 Jan 2009 00:46:05 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.28; KDE/4.1.4; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
References: <1233186456.6734.16.camel@localhost.localdomain> <1233187750.6734.27.camel@localhost.localdomain> <1233188287.6734.32.camel@localhost.localdomain>
In-Reply-To: <1233188287.6734.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290046.07659.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 19:18:07 Adrian McMenamin wrote:
> --- a/drivers/input/keyboard/maple_keyb.c
> +++ b/drivers/input/keyboard/maple_keyb.c
> -	if (!kbd || !idev) {
> -		error = -ENOMEM;
> +	if (!kbd) {
> +		error = ENOMEM;
>  		goto fail;
>  	}
> ...
> -	return error;
> +fail:
> +	return -error;

this driver has the weird/broken error inverting other patches of yours have 
had recently ... that stuff really needs to stop showing up ;)
-mike
