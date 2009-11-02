Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZKBLaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZKBLaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZKBLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:30:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621AbZKBLaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:30:20 -0500
Date: Mon, 02 Nov 2009 03:30:44 -0800 (PST)
Message-Id: <20091102.033044.206266489.davem@davemloft.net>
To: sposelenov@emcraft.com
Cc: sledz@dresearch.de, sledz@zone42.org, wd@denx.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Patch: Fix userland build failure in linux/if_tunnel.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091102135750.436a7b54@emcraft.com>
References: <4AEDCBA6.7040206@dresearch.de>
	<20091102135750.436a7b54@emcraft.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Poselenov <sposelenov@emcraft.com>
Date: Mon, 2 Nov 2009 13:57:50 +0300

> Hm, I received a confirmation, that my fix was applied
> http://www.spinics.net/lists/netdev/msg103860.html
> 
> However, it indeed didn't find their way into the mainline.
> I have no idea why, received no objections.

That posting doesn't say that your patch got applied, it says
that Joe Perches's MAINTAINERS file patch got applied.

Look at the context of what I'm replying to, rather than the
fact that you see "Applied." and it happens to be in a thread
you started with another patch.

Your patch is not necessary, current iproute2 sources compile
just fine without your change.  iproute2 got changed to include
a local copy of linux/ip_tunnel.h which is modified so that it
compiles properly in userspace.
