Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZFRCF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZFRCF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZFRCFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:05:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48983
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbZFRCFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:05:49 -0400
Date: Wed, 17 Jun 2009 19:05:52 -0700 (PDT)
Message-Id: <20090617.190552.127426863.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: correct off-by-one write allocations reports
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A389031.1060902@gmail.com>
References: <4A37F495.9030101@gmail.com>
	<4A37FC93.7070403@gmail.com>
	<4A389031.1060902@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 17 Jun 2009 08:41:53 +0200

> [PATCH] net: correct off-by-one write allocations reports
> 
> commit 2b85a34e911bf483c27cfdd124aeb1605145dc80 
> (net: No more expensive sock_hold()/sock_put() on each tx)
> changed initial sk_wmem_alloc value.
> 
> We need to take into account this offset when reporting
> sk_wmem_alloc to user, in PROC_FS files or various
> ioctls (SIOCOUTQ/TIOCOUTQ)
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
