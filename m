Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbZHQUuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbZHQUuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZHQUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:50:51 -0400
Received: from yop.chewa.net ([91.121.105.214]:34494 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZHQUuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:50:50 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 16:50:50 EDT
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] phonet: fix build when PROC_FS is disabled
Date: Mon, 17 Aug 2009 23:43:43 +0300
User-Agent: KMail/1.12.0 (Linux/2.6.30.4; KDE/4.3.0; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-next" <linux-next@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4A89BF25.9010404@oracle.com>
In-Reply-To: <4A89BF25.9010404@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908172343.44744.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 août 2009 23:35:49 Randy Dunlap, vous avez écrit :
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix phonet build when PROC_FS is not enabled:
>
> net/built-in.o: In function `pn_sock_open':
> socket.c:(.text+0x23c649): undefined reference to `seq_open_net'
> net/built-in.o:(.rodata+0x21018): undefined reference to `seq_release_net'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>


-- 
Rémi Denis-Courmont
http://www.remlab.net/
