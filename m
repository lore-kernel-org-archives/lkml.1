Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZFDHrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZFDHrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZFDHqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:46:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbZFDHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:46:55 -0400
Date: Thu, 4 Jun 2009 00:46:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=9A=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: Added MC33880 driver
Message-Id: <20090604004648.2e8c9088.akpm@linux-foundation.org>
In-Reply-To: <4A262981.90203@mocean-labs.com>
References: <4A262981.90203@mocean-labs.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 09:42:57 +0200 Richard R____jfors  <richard.rojfors.ext@mocean-labs.com> wrote:

> Supplied is a GPIO driver for the Freescale MC33880 High/Low side switch
> 

Is the Freescale MC33880 a powerpc-specific thing?  Seems not.

>
> ...
>
> +	mutex_destroy(&mc->lock);

hm, using mutex_destroy() was very formal of you.

> +config GPIO_MC33880
> +	tristate "Freescale MC33880 high-side/low-side switch"
> +	depends on SPI_MASTER
> +	help
> +	  SPI driver for Freescale MC33880 high-side/low-side switch.
> +	  This provides GPIO interface supporting inputs and outputs.
> +

What a neat little driver.  I'll queue it for 2.6.31, thanks.
