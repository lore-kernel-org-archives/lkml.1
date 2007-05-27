Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbXE0QKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbXE0QKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXE0QKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:10:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:65385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbXE0QKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D19r2jsWZg6YGes813dH8LcZYBqpW2LwtFGMUiFiMqji2GLmAPhc8w6VmcNVEcigE3W1oxQGZLwiVcjlbJirw4euclHU1Wob5Kmjk+EKBu8ymsk1D0krBECY3WOlopS6WwO52pnKVIbI0noRs8VfD4gvuF735fPaB4cC6kW5W1E=
Message-ID: <9a8748490705270910q2fde0e19i1e60393cef7b86d4@mail.gmail.com>
Date: Sun, 27 May 2007 18:10:41 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: USB: set default y for CONFIG_USB_DEVICE_CLASS
Cc: "Greg KH" <greg@kroah.com>, "bert hubert" <bert.hubert@netherlabs.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070527150458.GA3803@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070527150458.GA3803@vrfy.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: USB: set default y for CONFIG_USB_DEVICE_CLASS
>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>
> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> index f493fb1..346fc03 100644
> --- a/drivers/usb/core/Kconfig
> +++ b/drivers/usb/core/Kconfig
> @@ -40,21 +40,25 @@ config USB_DEVICEFS
>  config USB_DEVICE_CLASS
>         bool "USB device class-devices (DEPRECATED)"
>         depends on USB
> -       default n
> +       default y

It puzzles me why a deprecated option should be default 'Y'...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
