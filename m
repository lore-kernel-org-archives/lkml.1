Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXDHPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXDHPYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXDHPYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:24:12 -0400
Received: from hera.cwi.nl ([192.16.191.8]:38301 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXDHPYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:24:11 -0400
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 11:24:10 EDT
Date: Sun, 8 Apr 2007 17:00:08 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] partitions: Enhance Kconfig help text for EESOX and MSDOS formats
Message-ID: <20070408150008.GB15236@apps.cwi.nl>
References: <alpine.DEB.0.83.0704071322440.9798@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0704071322440.9798@sigma.j-a-k-j.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 01:27:09PM -0400, John Anthony Kazos Jr. wrote:
> From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> improves help text for MSDOS_PARTITION in fs/partitions/Kconfig.

> @@ -108,7 +112,11 @@ config MSDOS_PARTITION
>  	bool "PC BIOS (MSDOS partition tables) support" if PARTITION_ADVANCED
>  	default y
>  	help
> -	  Say Y here.
> +	  Standard PC-compatible partition table support for Linux. Used by
> +	  i386 systems, Linux/Windows dual-boot systems, and many others.
> +	  Unless you are certain your system does not use this partition
> +	  table format, and you're not using any disks from a system that
> +	  does, say Y.
>  
>  config BSD_DISKLABEL
>  	bool "BSD disklabel (FreeBSD partition tables) support"

This is not an improvement. "Say Y here" is the correct advice
to everybody. In cases where someone does not have any DOS-type
partition tables on his machine, he probably has a digital camera,
or MP3 player or USB stick or other device that uses such partition tables.
