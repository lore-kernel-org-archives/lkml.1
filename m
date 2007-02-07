Return-Path: <linux-kernel-owner+w=401wt.eu-S965471AbXBGEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965471AbXBGEwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 23:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXBGEwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 23:52:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965471AbXBGEwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 23:52:16 -0500
Date: Tue, 6 Feb 2007 20:52:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH] input: Schedule removal of compaq touchscreen emulation
 (tsdev.c)
Message-Id: <20070206205202.fde782ce.akpm@linux-foundation.org>
In-Reply-To: <1170780159.5826.71.camel@localhost.localdomain>
References: <1170780159.5826.71.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 16:42:39 +0000 Richard Purdie <rpurdie@rpsys.net> wrote:

>  ---------------------------
> +
> +What:   Compaq touchscreen device emulation
> +When:   Oct 2007
> +Files:  drivers/input/tsdev.c
> +Why:    The code says it was obsolete when it was written in 2001.
> +        tslib is a userspace library which does anything tsdev can do and
> +        much more besides in userspace where this code belongs. There is no
> +        longer any need for tsdev and applications should have converted to
> +        use tslib by now.
> +        The name "tsdev" is also extremely confusing and lots of people have
> +        it loaded when they don't need/use it.
> +Who:    Richard Purdie <rpurdie@rpsys.net>

I think it best to add a printk to the driver's initialisation routine warning
any remaining users that it is going away.
