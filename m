Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZJMKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZJMKSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZJMKST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:18:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46175
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759323AbZJMKSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:18:18 -0400
Date: Tue, 13 Oct 2009 03:18:14 -0700 (PDT)
Message-Id: <20091013.031814.100807531.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: herbert@gondor.apana.org.au, rjw@sisk.pl, Ralf.Hildebrandt@charite.de,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, yjwei@cn.fujitsu.com, tyasui@redhat.com,
       haoki@redhat.com
Subject: Re: [PATCH] udp: Fix udp_poll() and ioctl()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ACF4C1C.4050505@gmail.com>
References: <4AC78F7C.40908@gmail.com>
	<4ACCB6BE.5040602@gmail.com>
	<4ACF4C1C.4050505@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 09 Oct 2009 16:43:40 +0200

> [PATCH] udp: Fix udp_poll()
> 
> udp_poll() can in some circumstances drop frames with incorrect checksums.
> 
> Problem is we now have to lock the socket while dropping frames, or risk
> sk_forward corruption.
> 
> This bug is present since commit 95766fff6b9a78d1
> ([UDP]: Add memory accounting.)
> 
> While we are at it, we can correct ioctl(SIOCINQ) to also drop bad frames.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks good, applied, thanks Eric!
