Return-Path: <linux-kernel-owner+w=401wt.eu-S1750858AbXBUAqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858AbXBUAqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXBUAqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:46:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:38923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXBUAqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:46:02 -0500
From: Neil Brown <neilb@suse.de>
To: g3vbv@blueyonder.co.uk
Date: Wed, 21 Feb 2007 11:45:14 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17883.38426.615139.355511@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IPV6 build failure 2.6.20-git1x
In-Reply-To: message from Sid Boyce on Wednesday February 21
References: <45DB9429.20309@blueyonder.co.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday February 21, g3vbv@blueyonder.co.uk wrote:
> x86_64 builds without errors on openSUSE 10.2.
> x86 on openSUSE 10.3 Alpha1
>  gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> # CONFIG_IPV6_MIP6 is not set
> CONFIG_IPV6_SIT=m
> # CONFIG_IPV6_TUNNEL is not set
> CONFIG_IPV6_MULTIPLE_TABLES=y
> # CONFIG_IPV6_SUBTREES is not set
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> 
>   LD      arch/i386/lib/built-in.o
>   CC      arch/i386/lib/bitops.o
>   AS      arch/i386/lib/checksum.o
>   CC      arch/i386/lib/delay.o
>   AS      arch/i386/lib/getuser.o
>   CC      arch/i386/lib/memcpy.o
>   CC      arch/i386/lib/mmx.o
>   AS      arch/i386/lib/putuser.o
>   AS      arch/i386/lib/semaphore.o
>   CC      arch/i386/lib/strstr.o
>   CC      arch/i386/lib/usercopy.o
>   AR      arch/i386/lib/lib.a
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `svc_udp_recvfrom':
> svcsock.c:(.text+0x91f9c): undefined reference to `__ipv6_addr_type'
> make: *** [.tmp_vmlinux1] Error 1
> :/usr/src/linux-2.6.20-git15

Yes, known.  I really should get onto that....

Currently you cannot have IPV6=m and SUNRPC=y.  All other combinations
should work.

NeilBrown
