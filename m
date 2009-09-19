Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZISN0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZISN0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 09:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZISN0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 09:26:47 -0400
Received: from fifo99.com ([67.223.236.141]:38449 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZISN0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 09:26:46 -0400
Subject: Re: [PATCH] wistron_btns.c: Add DMI entry for Medion WIM2030 laptop
From: Daniel Walker <dwalker@fifo99.com>
To: Sebastian Frei <dr.nop@gmx.net>
Cc: mitr@volny.cz, linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
In-Reply-To: <200909191243.09243.dr.nop@gmx.net>
References: <200909191243.09243.dr.nop@gmx.net>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 06:26:50 -0700
Message-Id: <1253366810.6699.56.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 12:43 +0200, Sebastian Frei wrote:
> This patch adds a DMI entry for the Medion WIM2030 laptop.
> 
> Signed-off-by: Sebastian Frei <dr.nop@gmx.net>
> 
> --- linux-2.6.31.orig/drivers/input/misc/wistron_btns.c
> +++ linux-2.6.31/drivers/input/misc/wistron_btns.c
> @@ -669,6 +669,15 @@
>         },
>         {
>                 .callback = dmi_matched,
> +               .ident = "Medion MD 42200",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2030"),
> +               },
> +               .driver_data = keymap_fs_amilo_pro_v2000
> +       },
> +       {
> +               .callback = dmi_matched,
>                 .ident = "Fujitsu N3510",
>                 .matches = {
>                         DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),

Form email below (your the second person to do this today),

Your patch is whitespace damaged .. All the tabs have been removed from
your code, and the context code in the patch. That usually means the
patch can't be applied .. It can happen when you X copy&paste the patch
into an email. If your using quilt you can use "quilt mail" , or have
your mailer "insert text file" instead of copy&paste.

Daniel


