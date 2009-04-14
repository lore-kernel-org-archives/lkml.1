Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZDNVUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZDNVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZDNVUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:20:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52021
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbZDNVUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:20:23 -0400
Date: Tue, 14 Apr 2009 14:20:14 -0700 (PDT)
Message-Id: <20090414.142014.53605891.davem@davemloft.net>
To: dhowells@redhat.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix velocity_intr() in the VIA Velocity driver to have
 the right return type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090414155325.27548.90325.stgit@warthog.procyon.org.uk>
References: <20090414155325.27548.90325.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 14 Apr 2009 16:53:25 +0100

> Fix velocity_intr() in the VIA Velocity driver to have the right return type.
> As it stands, it returns the right values, but as type int, not type
> irqreturn_t.  This leads to the following compiler warning:
> 
>   CC      drivers/net/via-velocity.o
> drivers/net/via-velocity.c: In function 'velocity_open':
> drivers/net/via-velocity.c:1924: warning: passing argument 2 of 'request_irq' from incompatible pointer type
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Already fixed in net-2.6
