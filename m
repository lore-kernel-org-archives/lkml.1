Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXDSAGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXDSAGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXDSAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:06:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48645
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030522AbXDSAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:06:34 -0400
Date: Wed, 18 Apr 2007 17:06:36 -0700 (PDT)
Message-Id: <20070418.170636.77057313.davem@davemloft.net>
To: xemul@sw.ru
Cc: netdev@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       devel@openvz.org, kaber@trash.net, dev@openvz.org
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <4625D3D2.9030507@sw.ru>
References: <4625D3D2.9030507@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelianov <xemul@sw.ru>
Date: Wed, 18 Apr 2007 12:16:18 +0400

> The proposal it to make sock_orphan before detaching the callback
> in netlink_release() and to check for the sock to be SOCK_DEAD in
> netlink_dump_start() before setting a new callback.

As discussed in this thread there might be other ways to a
approach this, but this fix is good for now.

Patch applied, thank you.
