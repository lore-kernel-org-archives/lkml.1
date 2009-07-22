Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZGVUw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZGVUw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZGVUw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:52:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbZGVUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:52:56 -0400
Date: Wed, 22 Jul 2009 13:52:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] SPI driver for LMS283GF05 LCD
Message-Id: <20090722135243.ac1accfb.akpm@linux-foundation.org>
In-Reply-To: <200907161004.02552.marek.vasut@gmail.com>
References: <200907161004.02552.marek.vasut@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 10:04:02 +0200
Marek Vasut <marek.vasut@gmail.com> wrote:

> >From b7077676a3016327ca1010d3bbc80a0b9f2742e5 Mon Sep 17 00:00:00 2001                     
> From: Marek Vasut <marek.vasut@gmail.com>                                                  
> Date: Thu, 16 Jul 2009 04:49:47 +0200                                                      
> Subject: [PATCH] Samsung LMS283GF05 LCD SPI support                                        
> 
> This patch adds support for the SPI part of LMS283GF05 LCD. The LCD uses
> SPI for initialization and powerdown sequences. No further defails are  
> specified in the datasheet about the initialization/powerdown sequence, 
> just the magic numbers that have to be sent over SPI bus. This LCD can  
> be found in the Aeronix Zipit Z2 handheld.                              

The patch is wordwrapped and has all its tabs replaced with spaces.

> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index f9d19be..3f9cce3 100644                                                 
> --- a/drivers/video/backlight/Kconfig                                         
> +++ b/drivers/video/backlight/Kconfig                                         
> @@ -31,6 +31,13 @@ config LCD_CORGI                                           
>           Say y here to support the LCD panels usually found on SHARP         
>           corgi (C7x0) and spitz (Cxx00) models.                              
>                                                                               
> +config LCD_LMS283GF05                                                        
> +       tristate "Samsung LMS283GF05 LCD"                                     
> +       depends on LCD_CLASS_DEVICE && SPI_MASTER                             
> +       help                                                                  
> +         SPI driver for Samsung LMS283GF05. This provides basic support      
> +         for powering the LCD up/down through a sysfs interface.             
> +                                                                             

It generally looks OK to me.  Should it have a Kconfig dependency for
its use of the GPIO layer?

