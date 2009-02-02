Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZBBT3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZBBT3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZBBT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:28:53 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49294 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBBT2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:28:52 -0500
Subject: Re: [PATCH] jfs: needs crc32_le
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090202112055.5ad37047.randy.dunlap@oracle.com>
References: <20090202201637.28896d2f.sfr@canb.auug.org.au>
	 <20090202112055.5ad37047.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 13:28:45 -0600
Message-Id: <1233602925.5943.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 11:20 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> JFS needs crc32_le(), so select its library config symbol:

Thanks Randy.  I'll push this one right away.

Shaggy

> 
> fs/built-in.o: In function `jfs_statfs':
> super.c:(.text+0x7c8c0): undefined reference to `crc32_le'
> super.c:(.text+0x7c8d5): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Dave Kleikamp <shaggy@austin.ibm.com>
> ---
>  fs/jfs/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090202.orig/fs/jfs/Kconfig
> +++ linux-next-20090202/fs/jfs/Kconfig
> @@ -1,6 +1,7 @@
>  config JFS_FS
>  	tristate "JFS filesystem support"
>  	select NLS
> +	select CRC32
>  	help
>  	  This is a port of IBM's Journaled Filesystem .  More information is
>  	  available in the file <file:Documentation/filesystems/jfs.txt>.
-- 
David Kleikamp
IBM Linux Technology Center

