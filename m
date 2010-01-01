Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475Ab0AAHpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0AAHpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 02:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339Ab0AAHpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 02:45:09 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:44011 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0AAHpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 02:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kg7PWkxSUcWYmva3EuIbQMS74v/fwHH1+49yCBqMKmr9qe7ZwI44qX8J0EYhriDkMt
         8r6cfA6oWJLlGZI9LgyNx8SwP4k1e1g3opUG6s4X063nVLbFvHWrmXCwtdaxEAjbIHX6
         iJ/6eoMyWTALWdr8u8f6PDPKMcfpmj4OUlZ6g=
MIME-Version: 1.0
In-Reply-To: <f17812d70912312343x31656af6sdb4f3556e7022c05@mail.gmail.com>
References: <f17812d70912312343x31656af6sdb4f3556e7022c05@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 1 Jan 2010 15:44:45 +0800
Message-ID: <f17812d70912312344u4944906cj9310fe973d4854f3@mail.gmail.com>
Subject: Re: driver core: make platform_device_id table const
To: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget to make linux-kernel CC'ed.

On Fri, Jan 1, 2010 at 3:43 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> The platform ID table is normally const, force that by adding the attribute.
>
>    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
>
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 71ff887..f5c1e7b 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -21,7 +21,7 @@ struct platform_device {
>        u32             num_resources;
>        struct resource * resource;
>
> -       struct platform_device_id       *id_entry;
> +       const struct platform_device_id *id_entry;
>
>        /* arch specific additions */
>        struct pdev_archdata    archdata;
>
