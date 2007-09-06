Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbXIFINp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbXIFINp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXIFIN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:13:29 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:56125 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXIFIN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:13:28 -0400
Date: Thu, 6 Sep 2007 10:13:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, takamiya@po.ntts.co.jp
Subject: Re: net-26.24 broken with XFRM off
Message-Id: <20070906101326.34a81abb.dada1@cosmosbay.com>
In-Reply-To: <46DFAB7F.7060406@chelsio.com>
References: <46DFAB7F.7060406@chelsio.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 00:25:51 -0700
Divy Le Ray <divy@chelsio.com> wrote:

> Hi Dave,
> 
> I get this error compiling net-2.6.24 with XFRM off:
> 
> [root@aries net-2.6.24]# make O=/opt/build/net-2.6.24
> fatal: corrupted pack file 
> .git/objects/pack/pack-39c494e9d4c6488e5911ee5c06926450679e6b78.pack
> fatal: corrupted pack file 
> .git/objects/pack/pack-39c494e9d4c6488e5911ee5c06926450679e6b78.pack
>   Using /mnt/net-2.6.24 as source for kernel
>   GEN     /opt/build/net-2.6.24/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    /mnt/net-2.6.24/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o(.text+0x73ac2): In function `inet6_csk_xmit':
> : undefined reference to `flow_cache_genid'
> net/built-in.o(.text+0x73b9e): In function `inet6_csk_xmit':
> : undefined reference to `flow_cache_genid'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2
> 
> I believe this commit introduced it:
> commit a85d5450ddeb959bdf9e4603f9c06e9d79217cfa
> Author: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
> Date:   Fri Aug 24 23:31:39 2007 -0700
> 
>     [IPV6] XFRM: Fix connected socket to use transformation.
> 

Hi Divy

I believe this problem is known.

Please check http://marc.info/?l=linux-netdev&m=118881627028135&w=2 

Eric
