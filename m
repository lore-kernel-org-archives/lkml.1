Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbZD3LGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbZD3LGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZD3LGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:06:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39092
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbZD3LGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:06:12 -0400
Date: Thu, 30 Apr 2009 04:06:06 -0700 (PDT)
Message-Id: <20090430.040606.154074536.davem@davemloft.net>
To: mingo@elte.hu
Cc: netdev@vger.kernel.org, shemminger@vyatta.com, kaber@trash.net,
       panther@balabit.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build bug in 2.6.30-rc4:
 xt_socket.c:(.text+0x57780): undefined reference to
 `nf_conntrack_untracked'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090430075554.GA12204@elte.hu>
References: <20090430075554.GA12204@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 30 Apr 2009 09:55:54 +0200

>     Revert "netfilter: Kconfig: TProxy doesn't depend on NF_CONNTRACK"
>     
>     This reverts commit 4b0706624930dc75c3b0d0df463d89759ef7de29.

Thanks Ingo, I'll apply this revert soon unless Patrick wants to
handle it differently.
