Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbZJIOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbZJIOae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbZJIOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:30:33 -0400
Received: from bu3sch.de ([62.75.166.246]:43133 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbZJIOac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:30:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Miguel Boton <waninkoko@gmail.com>
Subject: Re: [PATCH] b43: add 'struct b43_wl' missing declaration
Date: Fri, 9 Oct 2009 16:29:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de
References: <200910091613.53960.mboton@gmail.com>
In-Reply-To: <200910091613.53960.mboton@gmail.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910091629.54616.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009 16:13:53 Miguel Boton wrote:
> 'struct b43_wl' declaration is missing at 'leds.h'.
> It should be declared to avoid getting some GCC warnings at 'b43_leds_unregister'.
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>

ack
(That was fast enough, eh? :D)

> 
> ---
> 
>  drivers/net/wireless/b43/leds.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/leds.h b/drivers/net/wireless/b43/leds.h
> index 4c56187..32b66d5 100644
> --- a/drivers/net/wireless/b43/leds.h
> +++ b/drivers/net/wireless/b43/leds.h
> @@ -1,6 +1,7 @@
>  #ifndef B43_LEDS_H_
>  #define B43_LEDS_H_
>  
> +struct b43_wl;
>  struct b43_wldev;
>  
>  #ifdef CONFIG_B43_LEDS
> 
> 



-- 
Greetings, Michael.
