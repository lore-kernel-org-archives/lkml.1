Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZLBThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZLBThU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZLBThT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:37:19 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:52664 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755311AbZLBThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:37:18 -0500
Message-ID: <4B16C233.6020808@ru.mvista.com>
Date: Wed, 02 Dec 2009 22:38:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: pancho horrillo <pancho@pancho.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
References: <20091202191942.GA7362@pancho.name> <20091202193104.GB7362@pancho.name>
In-Reply-To: <20091202193104.GB7362@pancho.name>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

pancho horrillo wrote:

> Please, review and push the patch, if you deem it adequate.

> Thanks a bunch!

> Signed-off-by: pancho horrillo <pancho@pancho.name>

> diff -purN a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
> --- a/drivers/usb/misc/appledisplay.c	2009-11-10 01:32:31.000000000 +0100
> +++ b/drivers/usb/misc/appledisplay.c	2009-12-02 20:05:00.000000000 +0100
> @@ -72,8 +72,8 @@ struct appledisplay {
>  	struct usb_device *udev;	/* usb device */
>  	struct urb *urb;		/* usb request block */
>  	struct backlight_device *bd;	/* backlight device */
> -	char *urbdata;			/* interrupt URB data buffer */
> -	char *msgdata;			/* control message data buffer */
> +	uint8_t *urbdata;		/* interrupt URB data buffer */
> +	uint8_t *msgdata;		/* control message data buffer */

    That 'uint8_t' is for userspace, use 'u8' instead.

WBR, Sergei
