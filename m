Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZIMV3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZIMV3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZIMV3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:29:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63506 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZIMV3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=kzc90YUQ2TruOA9mbxrkFiayX+By5TV5G5I70hLwAxCxohmynV3lZjddJjCkj86ZZi
         uP82OYuQ5yncseyGpKp3KpwvC0nGObvwCC8CJ92VdsR/K4qL4L9Hvh46/+ZtQxoWGxAG
         +0/J2EKxl3qgnizD9Ia0MZSlWs2wKdR3CHnzE=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Date: Sun, 13 Sep 2009 23:28:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-amd64; KDE/4.3.1; x86_64; ; )
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909132328.47079.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Ne 13. září 2009 23:05:59 Felipe Contreras napsal(a):
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/lib/delay.S |   16 ----------------
>  1 files changed, 0 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
> index 8d6a876..b741eb4 100644
> --- a/arch/arm/lib/delay.S
> +++ b/arch/arm/lib/delay.S
> @@ -42,22 +42,6 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
>  @ Delay routine
>  ENTRY(__delay)
>  		subs	r0, r0, #1
> -#if 0
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -		movls	pc, lr
> -		subs	r0, r0, #1
> -#endif
>  		bhi	__delay
>  		mov	pc, lr
>  ENDPROC(__udelay)
> 
Hi

why was this code there in the first place ?
