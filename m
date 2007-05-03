Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXECKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXECKLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXECKLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:11:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59095
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbXECKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:11:49 -0400
Date: Thu, 03 May 2007 03:11:49 -0700 (PDT)
Message-Id: <20070503.031149.51495514.davem@davemloft.net>
To: dhowells@redhat.com
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       geert@linux-m68k.org
Subject: Re: [PATCH 2/2] AFS/AF_RXRPC: Miscellaneous fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070501174752.19112.82814.stgit@warthog.cambridge.redhat.com>
References: <20070501174747.19112.1985.stgit@warthog.cambridge.redhat.com>
	<20070501174752.19112.82814.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 01 May 2007 18:47:52 +0100

> Make miscellaneous fixes to AFS and AF_RXRPC:
> 
>  (*) Make AF_RXRPC select KEYS rather than RXKAD or AFS_FS in Kconfig.
> 
>  (*) Don't use FS_BINARY_MOUNTDATA.
> 
>  (*) Remove a done 'TODO' item in a comemnt on afs_get_sb().
> 
>  (*) Don't pass a void * as the page pointer argument of kmap_atomic() as this
>      breaks on m68k.  Patch from Geert Uytterhoeven <geert@linux-m68k.org>.
> 
>  (*) Use match_*() functions rather than doing my own parsing.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
