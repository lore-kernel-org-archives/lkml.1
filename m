Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZLNUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZLNUQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZLNUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:16:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62956 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZLNUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:16:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] fs: fix compat_ioctl build for CONFIG_BLOCK=n
Date: Mon, 14 Dec 2009 20:16:13 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00048-g652c393; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au> <20091214091005.b4df65d9.randy.dunlap@oracle.com>
In-Reply-To: <20091214091005.b4df65d9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142016.13631.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18jUTCfLKBUwU/mZiQkH0PPmY1IBMutDc0+SCf
 mC065qMuOe/Oq3soN75kpOgUwRlxgMZrVHKS5wg6HY/89U5v3M
 vfGfhB9tx/vqQJc9URC2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009 17:10:05 Randy Dunlap wrote:
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build failure when CONFIG_BLOCK=n:
> 
> fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Your patch is obviously correct, but I wonder if we could just drop
the line completely, given that no driver in the kernel actually
implements this ioctl command. It was part of the ide-scsi driver
until 2.6.28, but that driver was removed in 2.6.29.

	Arnd
