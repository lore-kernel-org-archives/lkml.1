Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYGCVGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYGCVGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYGCVGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:06:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15620 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYGCVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:06:39 -0400
Message-ID: <29631811.1215119177276.JavaMail.oracle@acsmt302.oracle.com>
Date: Thu, 3 Jul 2008 16:06:17 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] doc: remove incorrect config option location
Cc: trivial@kernel.org
In-Reply-To: <20080703172257.GA1498@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <20080703172257.GA1498@debian>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Original Message ---
> CONFIG_INITRAMFS_SOURCE is no longer under Devices->Block
> Devices, but
> is now in General Setup.  The correct location is easily found
> using menuconfig's search, so remove the mention of the incorrect
> location from the docs.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  .../filesystems/ramfs-rootfs-initramfs.txt         |   11
> +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
> b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
> index 7be232b..08547cf 100644
> --- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
> +++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
> @@ -130,12 +130,11 @@ The 2.6 kernel build process always
> creates a gzipped cpio format initramfs
>  archive and links it into the resulting kernel binary.  By
> default, this
>  archive is empty (consuming 134 bytes on x86).
>  
> -The config option CONFIG_INITRAMFS_SOURCE (for some reason
> buried under
> -devices->block devices in menuconfig, and living in usr/Kconfig)
> can be used
> -to specify a source for the initramfs archive, which will
> automatically be
> -incorporated into the resulting binary.  This option can point
> to an existing
> -gzipped cpio archive, a directory containing files to be
> archived, or a text
> -file specification such as the following example:
> +The config option CONFIG_INITRAMFS_SOURCE can be used to
> specify a source for
> +the initramfs archive, which will automatically be incorporated
> into the
> +resulting binary.  This option can point to an existing gzipped
> cpio archive, a
> +directory containing files to be archived, or a text file
> specification such as
> +the following example:
>  
>    dir /dev 755 0 0
>    nod /dev/console 644 0 0 c 5 1
> -- 
> 1.5.6
> 

