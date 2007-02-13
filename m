Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXBMCNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXBMCNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933128AbXBMCNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:13:44 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:54518 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbXBMCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:13:43 -0500
Date: Tue, 13 Feb 2007 11:13:45 +0900 (JST)
Message-Id: <20070213.111345.78160400.yoshfuji@linux-ipv6.org>
To: akpm@linux-foundation.org, clem@clem.clem-digital.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070212181216.c55ca788.akpm@linux-foundation.org>
References: <200702130110.l1D1ADai012897@clem.clem-digital.net>
	<20070212181216.c55ca788.akpm@linux-foundation.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070212181216.c55ca788.akpm@linux-foundation.org> (at Mon, 12 Feb 2007 18:12:16 -0800), Andrew Morton <akpm@linux-foundation.org> says:

> > On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
> > 2.6.20-git8 fails compile:
> > 
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `svc_udp_recvfrom':
> > svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> Please send the .config.

and, the gcc version...

--yoshfuji
