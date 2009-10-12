Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZJLGrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZJLGrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZJLGrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:47:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41004 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbZJLGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:47:30 -0400
X-Sasl-enc: 9X4rTiWsYV+nPVXrdpTfPklpEv7KygBIqIT/u5Dw0HNt 1255329989
Message-ID: <4AD2D0C2.40307@ladisch.de>
Date: Mon, 12 Oct 2009 08:46:26 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
       linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: Re: [PATCH] [snd-usb-audio] Add match for JMTek USB sound	card
References: <1255173329-20485-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1255173329-20485-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lubomir Rintel wrote:
> Entry for JMTek LLC., SSS USB Headphone Set in the quirk table.

Please add an explaination why this entry is needed.  At first glance,
this entry seems to describe a class-compliant device that should not
need a quirk.

> +/* JMTek, LLC. SSS USB Headphone Set */
> +{
> +	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
> +		       USB_DEVICE_ID_MATCH_DEV_CLASS |
> +		       USB_DEVICE_ID_MATCH_INT_CLASS |
> +		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
> +	.idVendor = 0x0c76,
> +	.idProduct = 0x1605,
> +	.bDeviceClass = USB_CLASS_PER_INTERFACE,
> +	.bInterfaceClass = USB_CLASS_AUDIO,
> +	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
> +},


Best regards,
Clemens
