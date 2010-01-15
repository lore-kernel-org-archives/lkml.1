Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0AOOKS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729Ab0AOOKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:10:16 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47521 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab0AOOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:10:15 -0500
Message-ID: <4B5076E2.2090203@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 15:08:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
References: <1263505677.2074.2.camel@yio.site>
In-Reply-To: <1263505677.2074.2.camel@yio.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>  config DEVTMPFS_MOUNT
> -	bool "Automount devtmpfs at /dev"
> +	bool "Automount devtmpfs at /dev, after the kernel mouted the rootfs"

mouted -> mounted

>  	depends on DEVTMPFS
> +	default y
>  	help
> -	  This will mount devtmpfs at /dev if the kernel mounts the root
> -	  filesystem. It will not affect initramfs based mounting.
> -	  If unsure, say N here.
> +	  This will instruct the kernel to automatically mount the
> +	  devtmpfs filesystem at /dev, directly after the kernel has
> +	  mounted the root filesystem. The behavior can be overridden
> +	  with the commandline parameter: devtmpfs.mount=0|1.
> +	  This option does not affect initramfs based booting, here
> +	  the devtmpfs filesystem always needs to be mouted manually

Here too.
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
