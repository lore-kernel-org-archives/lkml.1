Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbZDXUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbZDXUFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDXUFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:05:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:44692 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751924AbZDXUFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:05:45 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18vQHFkoo0vtJaWt+dL5bimUsrbMdzOjx9Vd8S75p
	d/NABmbyUREstr
Date: Fri, 24 Apr 2009 22:05:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Kumar Gala <galak@kernel.crashing.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Regarding the linkstation defconfig
In-Reply-To: <20090424065816.GA15525@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0904242158210.8309@axis700.grange>
References: <20090424065816.GA15525@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Rogério Brito wrote:

> Hi, Guennadi, Kumar & Co.
> 
> Guennadi, since you seem to be the one responsible for the
> linkstation/kurobox in the kernel,

That's not howI interpret my role in linkstation development / support.

> I would like to ask you a few things
> that I couldn't quite understand. Please, forgive my ignorance here
> while I ask you some things:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>  01. why is anticipatory the default scheduler for linkstations when CFQ
>      is the default scheduler for the rest of the kernel?
> 
>  02. since kuroboxes/linkstations are meant to store files, is there any
>      reason why they don't have support for large blk devs enabled by
>      default?
> 
>  03. why is CONFIG_MIGRATION enabled in such low memory devices?
> 
>  04. why is CONFIG_BLK_DEV_RAM enabled by default?
> 
>  05. why is SCSI_LOWLEVEL enabled, if no device under that tree is used?
> 
>  06. idem for CONFIG_NETDEV_10000.
> 
>  07. idem for CONFIG_WIRELESS.
> 
>  08. idem for CONFIG_HWMON.
> 
>  09. idem for CONFIG_CRYPTO_HW.
> 
>  10. any reason why CONFIG_VIDEO_OUTPUT_CONTROL is configured as a
>      module?
> 
>  11. any reason why CIFS is not configured with extended attributes,
>      while both ext3 and nfs are?
> 
>  12. wouldn't it be a good thing to enable CONFIG_PRINTK_TIME?
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

As I already replied to you earlier, I am not particularly interested in 
fine-tuning and optimisation of defconfigs. IMHO *_defconfigs are only 
examples of board configuration, that are known to build and work. The 
rest is up to the user / packager.

> Perhaps similar remarks would apply to the other device that you
> maintain? I forgot its name.
> 
> Again, please, forgive my ignorance here regarding the questions above.
> I'm really looking for some clarification and to get things in shape
> both on my systems and in the default kernel configuration, in general.

Feel free to submit patches with reasoning to the powerpc ML and 
respective maintainer as per MAINTAINERS file.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
