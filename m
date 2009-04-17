Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZDQEqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZDQEqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZDQEq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:46:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZDQEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:46:26 -0400
Date: Fri, 17 Apr 2009 01:45:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
Message-ID: <20090417014524.2b61cdf1@pedra.chehab.org>
In-Reply-To: <1239204949.32726.37.camel@localhost>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	<1239167872-8179-3-git-send-email-joe@perches.com>
	<20090408111344.56818f9e@pedra.chehab.org>
	<1239204949.32726.37.camel@localhost>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 08:35:49 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2009-04-08 at 11:13 -0300, Mauro Carvalho Chehab wrote:
> > IMO, we should add a more generic entry to cover both. Something like:
> > 
> > MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
> > P:	Mauro Carvalho Chehab
> > M:	mchehab@infradead.org
> > L:	linux-media@vger.kernel.org
> > W:	http://linuxtv.org
> > T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> > S:	Maintained
> > F:	drivers/media
> 
> Perhaps:
> 
> commit 5c32246e24b601e3fbb4bb7d430a5cf4d3851ad5
> Author: Joe Perches <joe@perches.com>
> Date:   Wed Apr 8 08:34:04 2009 -0700
> 
>     MAINTAINERS - Coalesce sections "DVB" and "Video for Linux"
>     
>     Creating new section MEDIA INPUT INFRASTRUCTURE
>     
>     Signed-off-by: Joe Perches <joe@perches.com>

It seems ok to me.

> ---
>  MAINTAINERS |   40 +++++++++++++++-------------------------
>  1 files changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d6979e6..34c7903 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1842,17 +1842,6 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/wan/dscc4.c
>  
> -DVB SUBSYSTEM AND DRIVERS
> -P:	LinuxTV.org Project
> -M:	linux-media@vger.kernel.org
> -W:	http://linuxtv.org/
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> -S:	Maintained
> -F:	Documentation/dvb/
> -F:	drivers/media/dvb/
> -F:	drivers/media/common/saa7146*.c
> -F:	include/linux/dvb/
> -
>  DZ DECSTATION DZ11 SERIAL DRIVER
>  P:	Maciej W. Rozycki
>  M:	macro@linux-mips.org
> @@ -3625,6 +3614,21 @@ S:	Maintained
>  F:	Documentation/hwmon/max6650
>  F:	drivers/hwmon/max6650.c
>  
> +MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
> +P:	Mauro Carvalho Chehab
> +M:	mchehab@infradead.org
> +P:	LinuxTV.org Project
> +L:	linux-media@vger.kernel.org
> +W:	http://linuxtv.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> +S:	Maintained
> +F:	Documentation/dvb/
> +F:	Documentation/video4linux/
> +F:	drivers/media/
> +F:	include/media/
> +F:	include/linux/dvb/
> +F:	include/linux/videodev*.h
> +
>  MEGARAID SCSI DRIVERS
>  P:	Neela Syam Kolli
>  M:	megaraidlinux@lsi.com
> @@ -6007,20 +6011,6 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/via-velocity.*
>  
> -VIDEO FOR LINUX (V4L)
> -P:	Mauro Carvalho Chehab
> -M:	mchehab@infradead.org
> -L:	linux-media@vger.kernel.org
> -W:	http://linuxtv.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> -S:	Maintained
> -F:	Documentation/video4linux/
> -F:	drivers/media/video/
> -F:	drivers/media/radio/
> -F:	include/linux/videodev.h
> -F:	include/linux/videodev2.h
> -F:	include/media/
> -
>  VLAN (802.1Q)
>  P:	Patrick McHardy
>  M:	kaber@trash.net
> 
> 




Cheers,
Mauro
