Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZFRT6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZFRT6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZFRT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:58:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:8772 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZFRT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p5FbgWT29OO+DCDhrZKnC2OY+0r1uGw6puJDLQ7bEamPANcB9wKy7GVaI4Tl07NB0s
         I8Cee2B2pTbqNOf3rHbNF91MXpRhjBObJLjZelk52n1RicYnsDdMuHjNVblGkJzrdqis
         17ujqj6ulobgp7SoavljlU7BgI2yCQXCawPlg=
MIME-Version: 1.0
In-Reply-To: <1245200079-6323-2-git-send-email-rob@emanuele.us>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
	 <1245200079-6323-2-git-send-email-rob@emanuele.us>
Date: Thu, 18 Jun 2009 21:58:37 +0200
Message-ID: <cd73a99e0906181258v51372258n5fd134be9605cb11@mail.gmail.com>
Subject: Re: [PATCH 2/6] atmel-mci: Platform configuration to the the 
	atmel-mci driver
From: Andrew Victor <avictor.za@gmail.com>
To: Rob Emanuele <rob@emanuele.us>
Cc: nicolas.ferre@atmel.com, haavard.skinnemoen@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> +          if (data->slot[i].bus_width) {
> +                       /* input/irq */
> +                       if (data->slot[i].detect_pin) {
> +                               at91_set_gpio_input(data->slot[i].detect_pin, 1);
> +                               at91_set_deglitch(data->slot[i].detect_pin, 1);
> +                       }
> +                       if (data->slot[i].wp_pin)
> +                               at91_set_gpio_input(data->slot[i].wp_pin, 1);

The current at91_mci also allows the driver to control the "vcc_pin".
Can that functionality be merged into atmel_mci driver?


Regards.
  Andre Victor
