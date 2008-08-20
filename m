Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYHTX2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYHTX2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbYHTX15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:27:57 -0400
Received: from khc.piap.pl ([195.187.100.11]:51451 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYHTX14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:27:56 -0400
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA Kconfig cleanup: sort the driver list and modify some text
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
	<18598.42334.73411.476062@harpo.it.uu.se>
	<20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
	<5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 21 Aug 2008 01:27:52 +0200
In-Reply-To: <5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com> (Grant Coady's message of "Mon\, 18 Aug 2008 11\:47\:46 +1000")
Message-ID: <m3vdxvqnbb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady <grant_lkml@dodo.com.au> writes:

> --- linux-2.6.27-rc3a/drivers/ata/Kconfig	2008-07-14 07:51:29.000000000 +1000
> +++ linux-2.6.27-rc3c/drivers/ata/Kconfig	2008-08-18 11:29:20.871422237 +1000
> @@ -3,7 +3,7 @@
>  #
>  
>  menuconfig ATA
> -	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
> +	tristate "Serial ATA and Parallel ATA (SATA/PATA) drivers"

I don't think so. Maybe
> +	tristate "Serial ATA (SATA) and Parallel ATA (PATA) drivers"

>  config ATA_SFF
>  	bool "ATA SFF support"
>  	default y
> @@ -93,123 +93,15 @@
>  
>  if ATA_SFF

How the user compiling the kernel knows what ATA_SFF stands for?
Why not "select ATA_SFF" instead (when any driver using this is
selected)?
-- 
Krzysztof Halasa
