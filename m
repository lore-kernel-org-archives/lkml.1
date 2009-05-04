Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZEDU6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZEDU6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZEDU6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:58:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZEDU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:58:24 -0400
Date: Mon, 4 May 2009 13:53:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: galak@kernel.crashing.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] spi_mpc8xxx: s/83xx/8xxx/g
Message-Id: <20090504135327.13cd42af.akpm@linux-foundation.org>
In-Reply-To: <20090430234833.GI7901@oksana.dev.rtsoft.ru>
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
	<20090430234833.GI7901@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 03:48:33 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Since we renamed the file, we might want to rename the file
> internals too.
> 
> Though we don't bother with changing platform driver name and
> platform module alias. The stuff is legacy and hopefully we'll
> remove it soon.
> 

but but but

>
> -static struct of_platform_driver of_mpc83xx_spi_driver = {
> -	.name		= "mpc83xx_spi",
> -	.match_table	= of_mpc83xx_spi_match,
> -	.probe		= of_mpc83xx_spi_probe,
> -	.remove		= __devexit_p(of_mpc83xx_spi_remove),
> +static struct of_platform_driver of_mpc8xxx_spi_driver = {
> +	.name		= "mpc8xxx_spi",
> +	.match_table	= of_mpc8xxx_spi_match,
> +	.probe		= of_mpc8xxx_spi_probe,
> +	.remove		= __devexit_p(of_mpc8xxx_spi_remove),
>  };

It _did_ change the platform driver name, didn't it?


This patch series had quite a lot of conflicts with the already-pending

spi-move-common-spi_setup-functionality-into-core.patch
spi-move-more-spi_setup-functionality-into-core.patch

which I beleive I successfully fixed up.
