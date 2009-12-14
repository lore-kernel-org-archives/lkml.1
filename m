Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZLNHB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZLNHB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZLNHBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:01:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57794
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbZLNHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:01:55 -0500
Date: Sun, 13 Dec 2009 23:01:56 -0800 (PST)
Message-Id: <20091213.230156.160730048.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091214163338.f811722f.sfr@canb.auug.org.au>
References: <20091214163338.f811722f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Dec 2009 16:33:38 +1100

> Today's linux-next build (sparc defconfig) produced this warning:
> 
> In file included from arch/sparc/include/asm/uaccess.h:7,
>                  from include/net/checksum.h:26,
>                  from include/linux/skbuff.h:29,
>                  from net/core/pktgen.c:141:
> In function 'copy_from_user',
>     inlined from 'pktgen_if_write' at net/core/pktgen.c:867:
> arch/sparc/include/asm/uaccess_32.h:276: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

Rats, compiler version?
