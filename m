Return-Path: <linux-kernel-owner+w=401wt.eu-S965358AbXHINwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358AbXHINwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939740AbXHINvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:51:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56058 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939606AbXHINvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:51:47 -0400
Date: Thu, 9 Aug 2007 15:51:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       e1000-devel@lists.sourceforge.net, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: 2.6.23-rc2-mm1: e1000e global symbols must be renamed
Message-ID: <20070809135131.GN6997@stusta.de>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
>...
> - There is a new e1000 driver in git-netdev-all, called e1000e.  I'm sure
>   the developers would like it tested.  Please cc netdev@vger.kernel.org on
>   any reports.
>...
> Changes since 2.6.23-rc2-mm1:
>...
>  git-netdev-all.patch
>...
>  git trees
>...

<--  snip  -->

...
  LD      drivers/net/built-in.o
drivers/net/e1000e/built-in.o: In function `e1000_read_mac_addr':
(.text+0x3470): multiple definition of `e1000_read_mac_addr'
drivers/net/e1000/built-in.o:(.text+0xb6cc): first defined here
drivers/net/e1000e/built-in.o: In function `e1000_set_ethtool_ops':
(.text+0x594d): multiple definition of `e1000_set_ethtool_ops'
drivers/net/e1000/built-in.o:(.text+0xc97a): first defined here
...
make[3]: *** [drivers/net/built-in.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

