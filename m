Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZJ1J2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZJ1J2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZJ1J2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:28:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45472
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbZJ1J2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:28:33 -0400
Date: Wed, 28 Oct 2009 02:28:56 -0700 (PDT)
Message-Id: <20091028.022856.178916261.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, opurdila@ixiacom.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] net: fold network name hash (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AE7DF8E.3020607@gmail.com>
References: <20091027102251.244ee681@nehalam>
	<20091027150436.56e673cd@nehalam>
	<4AE7DF8E.3020607@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 28 Oct 2009 07:07:10 +0100

> You should therefore use hash_32(hash, NETDEV_HASHBITS),
> not hash_long() that maps to hash_64() on 64 bit arches, which is
> slower and certainly not any better with a 32bits input.

Agreed.
