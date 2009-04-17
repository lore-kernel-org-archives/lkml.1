Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbZDQSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbZDQSjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbZDQSjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:39:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760775AbZDQSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:39:37 -0400
Date: Fri, 17 Apr 2009 11:34:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: randy.dunlap@oracle.com, david-b@pacbell.net, jordan@cosmicpenguin.net,
       katzj@redhat.com, tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: +
 cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch added
 to -mm tree
Message-Id: <20090417113441.a7392103.akpm@linux-foundation.org>
In-Reply-To: <20090412215203.45e2a876@ephemeral>
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
	<49DFA576.6040005@oracle.com>
	<20090412215203.45e2a876@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 21:52:03 -0400
Andres Salomon <dilinger@queued.net> wrote:

> Force GPIO_CS553X to select GPIOLIB, which it makes use of.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 797ff45..17d7364 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -148,6 +148,7 @@ comment "PCI GPIO expanders:"
>  config GPIO_CS553X
>  	tristate "AMD cs5535/cs5536 GPIO support"
>  	depends on PCI && !CS5535_GPIO && !MGEODE_LX
> +	select GPIOLIB
>  	help
>  	  The AMD cs5535 and cs5536 southbridges support 28 GPIO pins that
>  	  can be used for quite a number of things.  The cs553x is found on

x86_64 allmodconfig:


drivers/gpio/Kconfig:28:error: found recursive dependency: GPIOLIB -> GPIO_CS553X -> GPIOLIB
