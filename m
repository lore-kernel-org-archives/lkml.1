Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0CCPIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:08:46 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:60603 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0CCPIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:08:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] USB: pl2303: switch to generic write implementation
Date: Wed, 3 Mar 2010 16:08:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Feuerer <peter@piie.net>
References: <20100303145046.GB15162@localhost> <1267628493-30080-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1267628493-30080-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003031608.20277.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. März 2010 16:01:33 schrieb Johan Hovold:
> @@ -941,10 +665,8 @@ static void pl2303_release(struct usb_serial *serial)
>  
>         for (i = 0; i < serial->num_ports; ++i) {
>                 priv = usb_get_serial_port_data(serial->port[i]);
> -               if (priv) {
> -                       pl2303_buf_free(priv->buf);
> +               if (priv)
>                         kfree(priv);
> -               }
>         }
>  }

No need to test for NULL.

	Regards
		Oliver
