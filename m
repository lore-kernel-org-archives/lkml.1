Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZFETun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZFETun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZFETug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:50:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZFETug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:50:36 -0400
Date: Fri, 5 Jun 2009 12:50:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       biblbroks@sezampro.rs
Subject: Re: add bcm47xx watchdog driver
Message-Id: <20090605125023.d968c58e.akpm@linux-foundation.org>
In-Reply-To: <4A282D98.6020004@free.fr>
References: <4A282D98.6020004@free.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009 22:24:56 +0200
matthieu castet <castet.matthieu@free.fr> wrote:

> This add watchdog driver for broadcom 47xx device.
> It uses the ssb subsytem to access embeded watchdog device.
> 
> ...
>
> --- linux-2.6.orig/drivers/watchdog/Kconfig	2009-05-25 22:22:02.000000000 +0200
> +++ linux-2.6/drivers/watchdog/Kconfig	2009-05-25 22:26:06.000000000 +0200
> @@ -764,6 +764,12 @@
>  	help
>  	  Hardware driver for the built-in watchdog timer on TXx9 MIPS SoCs.
>  
> +config BCM47XX_WDT
> +    tristate "Broadcom BCM47xx Watchdog Timer"
> +    depends on BCM47XX
> +    help
> +      Hardware driver for the Broadcom BCM47xx Watchog Timer.

Shouldn't there be some SSB dependencies in Kconfig here?
