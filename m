Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXFCPSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXFCPSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXFCPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:17:52 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:36992 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbXFCPRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:17:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=Kzq0GFNQS4OKI5DGHKvMba2+k99qYVVibQjGnWCblkIOuWUCu5FL+VwtaFjUNPF47bLcjEtPPRiFDTg0VfEcSaEiU85b/Fy7atbtL7lf2bV06YX0mogf8h7BeZbpj3sl;
Message-ID: <4662DB9B.400@simon.arlott.org.uk>
Date: Sun, 03 Jun 2007 16:17:47 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Doug Thompson <norsk5@yahoo.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 23/36] drivers edac Lindent amd76x driver
References: <616955.99525.qm@web50111.mail.re2.yahoo.com>
In-Reply-To: <616955.99525.qm@web50111.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/07 16:11, Doug Thompson wrote:
> Run this driver through Lindent for cleanup purposes
>  amd76x_edac.c |   54
>  1 file changed, 25 insertions(+), 29 deletions(-)
> --- linux-2.6.22-rc1.orig/drivers/edac/amd76x_edac.c
> +++ linux-2.6.22-rc1/drivers/edac/amd76x_edac.c
> @@ -86,11 +86,9 @@ struct amd76x_dev_info {
>  
>  static const struct amd76x_dev_info amd76x_devs[] = {
>  	[AMD761] = {
> -		.ctl_name = "AMD761"
> -	},
> +		    .ctl_name = "AMD761"},
>  	[AMD762] = {
> -		.ctl_name = "AMD762"
> -	},
> +		    .ctl_name = "AMD762"},
>  };
>  

You're adding a *lot* of spaces...

>From CodingStyle: "Outside of comments, documentation and except in
Kconfig, spaces are never used for indentation".

-- 
Simon Arlott
