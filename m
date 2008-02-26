Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbYBZFWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbYBZFWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbYBZFW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:22:27 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:14004 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758951AbYBZFWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:22:25 -0500
Date: Tue, 26 Feb 2008 14:22:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] maple: remove unused variable
Message-ID: <20080226052223.GE19814@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1203205053.6737.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203205053.6737.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:37:33PM +0000, Adrian McMenamin wrote:
> Remove an unused variable from the definition of struct maple_device
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> 
> diff -ruN a/include/linux/maple.h b/include/linux/maple.h
> --- a/include/linux/maple.h	2008-02-16 20:52:09.000000000 +0000
> +++ b/include/linux/maple.h	2008-02-16 21:42:06.000000000 +0000
> @@ -64,7 +64,6 @@
>  	int (*connect) (struct maple_device * dev);
>  	void (*disconnect) (struct maple_device * dev);
>  	struct device_driver drv;
> -	int registered;
>  };
>  
Applied, thanks.
