Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZKJKXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZKJKXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZKJKXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:23:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37447 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbZKJKXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:23:31 -0500
Date: Tue, 10 Nov 2009 10:25:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] parport_pc.c: Use correct length in strncmp
Message-ID: <20091110102518.7c3fc47c@lxorguk.ukuu.org.uk>
In-Reply-To: <1257825083.12852.83.camel@Joe-Laptop.home>
References: <1257825083.12852.83.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Nov 2009 19:51:23 -0800
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 2597145..ad113b0 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -3403,7 +3403,7 @@ static int __init parport_parse_param(const char *s, int *val,
>  		*val = automatic;
>  	else if (!strncmp(s, "none", 4))
>  		*val = none;
> -	else if (nofifo && !strncmp(s, "nofifo", 4))
> +	else if (nofifo && !strncmp(s, "nofifo", 6))
>  		*val = nofifo;

I just hope nobody is booting with =nofif due to a typo ;)

Acked-by: Alan Cox <alan@linux.intel.com>
