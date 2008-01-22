Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYAVRqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYAVRqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYAVRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:46:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40049 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYAVRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:46:38 -0500
Date: Tue, 22 Jan 2008 09:44:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johann Felix Soden <johfel@gmx.de>
Cc: torvalds@linux-foundation.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix file references in documentation and Kconfig
Message-Id: <20080122094434.294ba251.randy.dunlap@oracle.com>
In-Reply-To: <1200836478.16588.4.camel@localhost>
References: <1200836478.16588.4.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2008 14:41:18 +0100 Johann Felix Soden wrote:

> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> Fix typo in arch/powerpc/boot/flatdevtree_env.h.
> There is no Documentation/networking/ixgbe.txt.
> 
> README.cycladesZ is now in Documentation/.
> wavelan.p.h is now in drivers/net/wireless/.
> HFS.txt is now Documentation/filesystems/hfs.txt.
> OSS-files are now in sound/oss/.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  Documentation/networking/wavelan.txt |    4 ++--
>  arch/powerpc/boot/flatdevtree_env.h  |    2 +-
>  drivers/char/Kconfig                 |    2 +-
>  drivers/net/Kconfig                  |    3 ---
>  drivers/net/wireless/Kconfig         |    2 +-
>  drivers/scsi/Kconfig                 |    2 +-
>  fs/Kconfig                           |    4 ++--
>  sound/oss/Kconfig                    |    4 ++--
>  8 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/networking/wavelan.txt b/Documentation/networking/wavelan.txt
> index c1acf5e..afa6e52 100644
> --- a/Documentation/networking/wavelan.txt
> +++ b/Documentation/networking/wavelan.txt
> @@ -12,8 +12,8 @@ and many Linux driver to support it.
>  "wavelan" driver (old ISA Wavelan)
>  ----------------
>  	o Config :	Network device -> Wireless LAN -> AT&T WaveLAN
> -	o Location :	.../drivers/net/wavelan*
> -	o in-line doc :	.../drivers/net/wavelan.p.h
> +	o Location :	.../drivers/net/wireless/wavelan*
> +	o in-line doc :	.../drivers/net/wireless/wavelan.p.h
>  	o on-line doc :
>  	    http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Wavelan.html
>  
> diff --git a/arch/powerpc/boot/flatdevtree_env.h b/arch/powerpc/boot/flatdevtree_env.h
> index ad0420d..66e0ebb 100644
> --- a/arch/powerpc/boot/flatdevtree_env.h
> +++ b/arch/powerpc/boot/flatdevtree_env.h
> @@ -2,7 +2,7 @@
>   * This file adds the header file glue so that the shared files
>   * flatdevicetree.[ch] can compile and work in the powerpc bootwrapper.
>   *
> - * strncmp & strchr copied from <file:lib/strings.c>
> + * strncmp & strchr copied from <file:lib/string.c>
>   * Copyright (C) 1991, 1992  Linus Torvalds
>   *
>   * Maintained by: Mark A. Greer <mgreer@mvista.com>
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index ef1ed5d..2e3a0d4 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -137,7 +137,7 @@ config CYCLADES
>  	  your Linux box, for instance in order to become a dial-in server.
>  
>  	  For information about the Cyclades-Z card, read
> -	  <file:drivers/char/README.cycladesZ>.
> +	  <file:Documentation/README.cycladesZ>.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called cyclades.
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 9ae3166..9af05a2 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2465,9 +2465,6 @@ config IXGBE
>  
>  	  <http://support.intel.com>
>  
> -	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/ixgbe.txt>.
> -
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ixgbe.
>  
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index c98fc62..2c08c0a 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -68,7 +68,7 @@ config WAVELAN
>  	  <http://www.tldp.org/docs.html#howto>. Some more specific
>  	  information is contained in
>  	  <file:Documentation/networking/wavelan.txt> and in the source code
> -	  <file:drivers/net/wavelan.p.h>.
> +	  <file:drivers/net/wireless/wavelan.p.h>.
>  
>  	  You will also need the wireless tools package available from
>  	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index a6676be..184c7ae 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -732,7 +732,7 @@ config SCSI_GDTH
>  	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
>  	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
>  	  in the kernel source in <file:drivers/scsi/gdth.c> and
> -	  <file:drivers/scsi/gdth.h.>
> +	  <file:drivers/scsi/gdth.h>.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called gdth.
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 487236c..781b47d 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -1112,8 +1112,8 @@ config HFS_FS
>  	help
>  	  If you say Y here, you will be able to mount Macintosh-formatted
>  	  floppy disks and hard drive partitions with full read-write access.
> -	  Please read <file:fs/hfs/HFS.txt> to learn about the available mount
> -	  options.
> +	  Please read <file:Documentation/filesystems/hfs.txt> to learn about
> +	  the available mount options.
>  
>  	  To compile this file system support as a module, choose M here: the
>  	  module will be called hfs.
> diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
> index af37cd0..857008b 100644
> --- a/sound/oss/Kconfig
> +++ b/sound/oss/Kconfig
> @@ -75,7 +75,7 @@ config SOUND_TRIDENT
>  
>  
>  	  This driver differs slightly from OSS/Free, so PLEASE READ the
> -	  comments at the top of <file:drivers/sound/trident.c>.
> +	  comments at the top of <file:sound/oss/trident.c>.
>  
>  config SOUND_MSNDCLAS
>  	tristate "Support for Turtle Beach MultiSound Classic, Tahiti, Monterey"
> @@ -564,7 +564,7 @@ config SOUND_AEDSP16
>  	  questions.
>  
>  	  Read the <file:Documentation/sound/oss/README.OSS> file and the head of
> -	  <file:drivers/sound/aedsp16.c> as well as
> +	  <file:sound/oss/aedsp16.c> as well as
>  	  <file:Documentation/sound/oss/AudioExcelDSP16> to get more information
>  	  about this driver and its configuration.
>  
> -- 

---
~Randy
