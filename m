Return-Path: <linux-kernel-owner+w=401wt.eu-S1161480AbXBOWOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161480AbXBOWOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161478AbXBOWOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:14:02 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161466AbXBOWOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:14:00 -0500
Date: Thu, 15 Feb 2007 14:13:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] do_basic_setup: implicit declaration of function
 =?UTF-8?Q?=E2=80=98init=5Firq=5Fproc'?=
Message-Id: <20070215141337.c3effca2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0702151604230.13011@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0702151604230.13011@pademelon.sonytel.be>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 16:06:23 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Add missing #include <linux/irq.h>, which caused
> 
> | init/main.c: In function ‘do_basic_setup’:
> | init/main.c:705: warning: implicit declaration of function ‘init_irq_proc’
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> diff --git a/init/main.c b/init/main.c
> index 2421e15..8bba00e 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -52,6 +52,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/device.h>
> +#include <linux/irq.h>
>  

Russell will chuck a wobbly:  `head -10 include/linux/irq.h'

Probably the init_irq_proc() declaration is in the wrong header.
