Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYBJTST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYBJTST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYBJTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:18:09 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:42620 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752914AbYBJTSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:18:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r9IpajrATzjwWatCA1ftQsqxU7AY9g3YPS87gqelGKhCFQRnCtMThSaRkzKq6QE0sbp23d4Qxo79l72rXUmNNp56/10yXuOGvmVcz3piVhB6QNQoUsH4EEN162YjTl1Brak9iGXpM5T1vayTNCnN+eo3H9cYUqYKkeElv8Yh58g=  ;
X-YMail-OSG: wkQkUt4VM1mAHeUg_rU0Ajw3LDRmIGCUwbjNjt1kGkU7j_Cxz81MZx9pqSZUdiZAr9vm4.dKuw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] introduce is_valid_gpio() predicate and use it in gpiolib.c
Date: Sun, 10 Feb 2008 11:18:04 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0802102002270.4417@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0802102002270.4417@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101118.04476.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like this, but can't resist making the "Andrew Comment":

> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -16,6 +16,8 @@
>  #define ARCH_NR_GPIOS		256
>  #endif
>  
> +#define is_valid_gpio(gpio)	((unsigned int)(gpio) < ARCH_NR_GPIOS)

Please make this an inline C function.  :)


> +
>  struct seq_file;
>  
>  /**
> 


