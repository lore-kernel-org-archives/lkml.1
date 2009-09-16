Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbZIPMny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbZIPMny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZIPMnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:43:53 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43483 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZIPMnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g9cnPwWpT84gqOz9o6v4yAPeTRDvCp/zU2T2Xro7i45/R5shhsCIc/NIOHodbODQqz
         Qb/ZNqt/ztKzToneMQ5AJRdJNd0jYzuzj39ZeeYKpMtWg+bdC/N8vhDy/RCnzfj6HH6C
         zhk/iyzTI+U3aujCV0WWaM2IAS0F6wqj8urz8=
MIME-Version: 1.0
In-Reply-To: <1253103989-25635-1-git-send-email-andy.shevchenko@gmail.com>
References: <20090916120529.GB18050@centrinvest.ru>
	 <1253103989-25635-1-git-send-email-andy.shevchenko@gmail.com>
Date: Wed, 16 Sep 2009 15:43:55 +0300
X-Google-Sender-Auth: 0fe81d90cd4008af
Message-ID: <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com>
Subject: Re: [PATCH v2] media: video: pwc: Use kernel's simple_strtol()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 3:26 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> @@ -2078,13 +2066,13 @@ static int __init usb_pwc_init(void)
>                                }
>                                else {
>                                        /* No type or serial number specified, just a number. */
> -                                       device_hint[i].device_node = pwc_atoi(s);
> +                                       device_hint[i].device_node = (int)simple_strtol(s, NULL, 10);

What's with all the casting to int?
