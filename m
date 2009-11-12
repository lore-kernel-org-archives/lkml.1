Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZKLCxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZKLCxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759999AbZKLCxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:53:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50100
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759976AbZKLCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:53:12 -0500
Date: Wed, 11 Nov 2009 18:53:38 -0800 (PST)
Message-Id: <20091111.185338.253345558.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: linux-next: net tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091112132424.e010e3c5.sfr@canb.auug.org.au>
References: <20091112132424.e010e3c5.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 13:24:24 +1100

> Hi Dave,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> net/ipv6/addrconf.c: In function 'inet6_dump_ifinfo':
> net/ipv6/addrconf.c:3833: warning: unused variable 'err'
> 
> Introduced by commit 84d2697d9649339215675551eae28ba04068dea1 ("ipv6:
> speedup inet6_dump_ifinfo()").

I just pushed a fix for this into net-next-2.6, thanks!
