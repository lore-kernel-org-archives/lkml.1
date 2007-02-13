Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXBMCM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXBMCM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXBMCM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:12:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51128 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXBMCM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:12:28 -0500
Date: Mon, 12 Feb 2007 18:12:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
Message-Id: <20070212181216.c55ca788.akpm@linux-foundation.org>
In-Reply-To: <200702130110.l1D1ADai012897@clem.clem-digital.net>
References: <200702130110.l1D1ADai012897@clem.clem-digital.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
> 2.6.20-git8 fails compile:
> 
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `svc_udp_recvfrom':
> svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> make: *** [.tmp_vmlinux1] Error 1
> 

Please send the .config.
