Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0BIWTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:19:22 -0500
Received: from mail-iw0-f183.google.com ([209.85.223.183]:46929 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0BIWTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:19:21 -0500
MIME-Version: 1.0
In-Reply-To: <1265750032-2803-1-git-send-email-agust@denx.de>
References: <1265750032-2803-1-git-send-email-agust@denx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 15:18:57 -0700
X-Google-Sender-Auth: 851a0a8d598909a5
Message-ID: <fa686aa41002091418q2e97919ft2bcf8ad02e050afa@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] powerpc: mpc5121: PSC UART support
To: Anatolij Gustschin <agust@denx.de>, Greg Kroah-Hartman <greg@kroah.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jcrigby@gmail.com, dzu@denx.de, wd@denx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, since this touches powerpc stuff, do you mind if I pick up the
series into my tree?

Thanks,
g.

On Tue, Feb 9, 2010 at 2:13 PM, Anatolij Gustschin <agust@denx.de> wrote:
> The support for mpc5121 PSC UART currently only works with
> serial console. This patch series re-enable PSC UART support for
> all 12 PSCs and document added DTS bingings.
>
> Anatolij Gustschin (3):
>  serial: mpc52xx_uart: re-enable mpc5121 PSC UART support
>  powerpc: doc/dts-bindings: document mpc5121 psc uart  dts-bindings
>  powerpc: mpc5121: enable support for more PSC UARTs
>
>  .../powerpc/dts-bindings/fsl/mpc5121-psc.txt       |   70 ++++++
>  arch/powerpc/include/asm/mpc52xx_psc.h             |    4 +
>  drivers/serial/mpc52xx_uart.c                      |  251 ++++++++++++++++++--
>  3 files changed, 310 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
