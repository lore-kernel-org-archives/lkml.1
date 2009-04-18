Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZDRQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZDRQv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZDRQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:51:48 -0400
Received: from mail-qy0-f126.google.com ([209.85.221.126]:55464 "EHLO
	mail-qy0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZDRQvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OkHAjE40XYW6K5QVFeK6YuyD7bBMSRr9YT9OwrdGOMad0ywPN5W6HlVDOWWfENhvHd
         7CFMBjYV11bGm0k9r2mXAXmf1lzQpAln/waOZuGCbJhxGw44awwnXCXzufkgX+LF1eWs
         oLtvGjWruA+qATuGhHitPgGeDK4kxDXAiJf04=
MIME-Version: 1.0
In-Reply-To: <875730ecbea83bcb28e8698e47f8146e.squirrel@webmail.it-technology.at>
References: <875730ecbea83bcb28e8698e47f8146e.squirrel@webmail.it-technology.at>
Date: Sat, 18 Apr 2009 12:51:43 -0400
Message-ID: <9e4733910904180951o5ca28479n6eb49bbe1e603248@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb driver for intellon int51x1 based PLC like devolo 
	dlan duo
From: Jon Smirl <jonsmirl@gmail.com>
To: Peter Holik <peter@holik.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 12:43 PM, Peter Holik <peter@holik.at> wrote:
> usb driver for intellon int51x1 based PLC like devolo dlan duo
> with improvements suggested by the guys of the mailinglist:
> - name and prefix with int51x1 (Florian Fainelli)
> - use conversion functions cpu_to_le16 / le16_to_cpu (Oliver Neukum)
> - use pskb_may_pull instead of skb->len (Ilpo Järvinen)
> - better code in tx_fixup (Ilpo Järvinen)
> - use gotos for error handling (Ilpo Järvinen)
>
> Signed-off-by: Peter Holik <peter@holik.at>
> ---
>  drivers/net/usb/Kconfig   |    8 ++
>  drivers/net/usb/Makefile  |    1 +
>  drivers/net/usb/int51x1.c |  253 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 262 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/usb/int51x1.c
>
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 8ee2103..86c9e86 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -345,4 +345,12 @@ config USB_HSO
>          To compile this driver as a module, choose M here: the
>          module will be called hso.
>
> +config USB_NET_INT51X1
> +       tristate "Intellon PLC based usb adapter"
> +       depends on USB_USBNET
> +       help
> +         Choose this option if you're using a USB-based PLC
> +         (Powerline Communications) solution with an Intellon
> +         int51x1 chip, like the "devolo dLan duo".

A few more details...

+         Choose this option if you're using a 14Mb USB-based PLC
+         (Powerline Communications) solution with an Intellon
+         INT51x1/INT5200 chip, like the "devolo dLan duo".

Is Homeplug a valid name too for this device? There are so many
Home... "standards" I get them confused.

-- 
Jon Smirl
jonsmirl@gmail.com
