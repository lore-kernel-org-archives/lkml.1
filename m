Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYLTU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYLTU2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYLTU2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:28:44 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:7429 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYLTU2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OqLR+KY7XZloodvFxDnRFRRzaGiM6RQmTeZrMZLpognBrOrjpWzIKhQapyiME0BVs0
         2S5V80IBl7H9xwnXO46uEFHvfe2gSZP5JbU8aeXipVtngk671202rrhPt5FK4A3MWoWE
         /mwnxd0Khs1+6hG/IlyDoSCau5wRznlhkNtqo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add Maple controller as a joystick device
Date: Sat, 20 Dec 2008 12:28:20 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-134.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>
References: <1229797614.6502.20.camel@localhost.localdomain>
In-Reply-To: <1229797614.6502.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200812201228.20767.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBKKSvki028935

On Saturday 20 December 2008 10:26:54 Adrian McMenamin wrote:> +       mdev = to_maple_dev(dev);> +       if (!mdev) {> +               error = EINVAL;> +               goto fail;> +       }> +       > +       mdrv = to_maple_driver(dev->driver);> +       if (!mdrv) {> +               error = EINVAL;> +               goto fail;> +       }
This will never happen - to_maple_* are simple wrappers around container_of and so the result will never be NULL but some small offset from it if dev is NULL. I'm staying on the old version of the patch with small fixups.
-- Dmitryÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
