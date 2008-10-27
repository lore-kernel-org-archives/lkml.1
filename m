Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYJ0UYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYJ0UYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJ0UY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:24:29 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:24790 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYJ0UY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:24:29 -0400
Date: Mon, 27 Oct 2008 22:27:28 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: "Vlada Peric" <vlada.peric@gmail.com>
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl
Subject: Re: [PATCH] cirrusfb: remove unused variables
Message-Id: <20081027222728.b9d55137.krzysztof.h1@poczta.fm>
In-Reply-To: <6e4284620810270231y7d03d898p8d2d832bec42b10e@mail.gmail.com>
References: <6e4284620810270231y7d03d898p8d2d832bec42b10e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-EMID: 4ee2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 10:31:59 +0100
"Vlada Peric" <vlada.peric@gmail.com> wrote:

> After commit a1d35a7a (cirrusfb: use modedb and add mode_option parameter),
> these variables are no longer used, so remove them to fix compilation warning.
> 
> Signed-off-by: Vlada Periæ <vlada.peric@gmail.com>
> CC: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/cirrusfb.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
> index 048b139..ace4001 100644
> --- a/drivers/video/cirrusfb.c
> +++ b/drivers/video/cirrusfb.c
> @@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
> 
>  #ifndef MODULE
>  static int __init cirrusfb_setup(char *options) {
> -	char *this_opt, s[32];
> -	int i;
> +	char *this_opt;
> 
>  	DPRINTK("ENTER\n");
> 
> -- 

----------------------------------------------------------------------
Konkurs! Wygraj m.in. telewizor LCD!
Sprawdz >> http://link.interia.pl/f1f52 

