Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZI3XWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZI3XWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZI3XWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:22:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45991
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbZI3XWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:22:14 -0400
Date: Wed, 30 Sep 2009 16:22:33 -0700 (PDT)
Message-Id: <20090930.162233.208543104.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: samuel.thibault@ens-lyon.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090930161939.8c6d140a.akpm@linux-foundation.org>
References: <4AC3DF7B.5060407@zytor.com>
	<20090930230138.GZ6451@const.famille.thibault.fr>
	<20090930161939.8c6d140a.akpm@linux-foundation.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 30 Sep 2009 16:19:39 -0700

> From: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
> memory clobber, as it is only passed the address of the buffer, not a
> memory reference to the buffer itself.
> 
> This caused failures in Hurd's pfinetv4 when we tried to compile it with
> gcc-4.3 (bogus checksums).
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I'm happy to see this go in via the x86 tree, and thus:

Acked-by: David S. Miller <davem@davemloft.net>
