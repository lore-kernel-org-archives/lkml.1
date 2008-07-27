Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYG0Ll1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYG0Ll1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYG0LlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:41:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36958
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYG0LlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:41:19 -0400
Date: Sun, 27 Jul 2008 04:41:18 -0700 (PDT)
Message-Id: <20080727.044118.102038262.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing bits of net-namespace / sysctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080727075933.GB28946@ZenIV.linux.org.uk>
References: <20080727075933.GB28946@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 27 Jul 2008 08:59:33 +0100

> Piss-poor sysctl registration API strikes again, film at 11...
> What we really need is _pathname_ required to be present in
> already registered table, so that kernel could warn about bad
> order.  That's the next target for sysctl stuff (and generally
> saner and more explicit order of initialization of ipv[46]
> internals wouldn't hurt either).
> 
> For the time being, here are full fixups required by ..._rotable()
> stuff; we make per-net sysctl sets descendents of "ro" one and
> make sure that sufficient skeleton is there before we start registering
> per-net sysctls.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
