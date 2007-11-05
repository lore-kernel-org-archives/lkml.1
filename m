Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXKEEBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXKEEBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 23:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXKEEBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 23:01:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58185
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbXKEEBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 23:01:34 -0500
Date: Sun, 04 Nov 2007 20:01:33 -0800 (PST)
Message-Id: <20071104.200133.103599780.davem@davemloft.net>
To: bunk@kernel.org
Cc: mingo@elte.hu, sam@ravnborg.org, thomas@archlinux.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071104152930.GL12045@stusta.de>
References: <20071104100429.GA12311@elte.hu>
	<20071104.023133.241080055.davem@davemloft.net>
	<20071104152930.GL12045@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 4 Nov 2007 16:29:30 +0100

> On Sun, Nov 04, 2007 at 02:31:33AM -0800, David Miller wrote:
> > People can't have it both ways.  CFLAGS has global meaning in every
> > Makefile based build tree, it's not an "autoconf" thing.  This is well
> > established practice, and I think it's a good thing the kernel does it
> > now too.
> 
> Makefiles do normally not pick such variables from the environment.

The absolutely do.

All of the default builtin compilation rules inside of GNU
make, and every other UNIX make out there, do.
