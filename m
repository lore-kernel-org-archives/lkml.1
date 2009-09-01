Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZIAH0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZIAH0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZIAH03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:26:29 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55897 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZIAH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eQXVDbtrosga3svcnqw/lY/cKC9CUTeb7ukikLF6xLLZfLEivZAoDYajq/vWOxlyBh
         DCpvpHTGNU8yd7ogthMXzEsyqxHUaVCZ/2KL+XREiXNHAaUUIK9rdBSyXBfRXmHgxvZl
         P0i0l/W7xlWPLt9nNWlyrVCea5Q2wThBDVRwU=
MIME-Version: 1.0
In-Reply-To: <1251668944-32222-1-git-send-email-linus.walleij@stericsson.com>
References: <1251668944-32222-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 1 Sep 2009 09:26:29 +0200
Message-ID: <63386a3d0909010026x72cd4adcyc86927fbf4966c24@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] AB3100 RTC support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/30 Linus Walleij <linus.walleij@stericsson.com>:

> This adds support for the RTC found inside the AB3100 Mixed Signal chip.
> The symbols used for communicating with the chip is found in the
> mfd/ab3100-core.c driver that also provides the platform device.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Changelog v3->v4
> - Remove error message that will be given by the RTC core anyway.
> - Suggest to push this through Sam's MFD tree if it's OK with Sam.

No further comments on this it seems, Sam can you pick it into the
MFD tree or shall I send it en route to akpm?

Linus
