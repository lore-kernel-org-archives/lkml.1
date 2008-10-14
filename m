Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbYJNNt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbYJNNt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYJNNtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:49:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21825 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYJNNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VBMj7Dljs/3EMUQssLSatQ/bkCeUF8PEFUO3cPodmmT9Lusvrs8cA6Eue6mOY418nx
         9ay16fC2x+Jg1pd/kbVfkWnO/IG1ztg6S2KW3eIjemXD81TOcDnkyv3dPtxDP01ESr7H
         Lj1m8TxB6i309l2DyCzqXdTKiQreOCbX9yuUc=
Message-ID: <48F4A344.1060005@gmail.com>
Date: Tue, 14 Oct 2008 15:48:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix numlock led on Dell keyboard (413c:2105)
References: <20081014102821.2693b15e@pedra.chehab.org>
In-Reply-To: <20081014102821.2693b15e@pedra.chehab.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab napsal(a):
> This keyboard needs to re-sync numlock after probing.
>     
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/hid/hid-dell.c b/drivers/hid/hid-dell.c
> index 98ee40e..1a0d0df 100644
> --- a/drivers/hid/hid-dell.c
> +++ b/drivers/hid/hid-dell.c
> @@ -47,6 +47,7 @@ err_free:
>  
>  static const struct hid_device_id dell_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_SK8115) },

Add the line also to hid_blacklist in hid-core.c.

Thanks.
