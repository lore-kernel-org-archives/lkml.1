Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXKEEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXKEEDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 23:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXKEEDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 23:03:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39703
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbXKEEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 23:03:14 -0500
Date: Sun, 04 Nov 2007 20:03:13 -0800 (PST)
Message-Id: <20071104.200313.236511775.davem@davemloft.net>
To: bunk@kernel.org
Cc: cate@cateee.net, mingo@elte.hu, sam@ravnborg.org, thomas@archlinux.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071104163439.GM12045@stusta.de>
References: <20071104152930.GL12045@stusta.de>
	<472DF121.8000509@cateee.net>
	<20071104163439.GM12045@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 4 Nov 2007 17:34:39 +0100

> But the main point that stuff like e.g. -I/usr/local/dist/include that 
> might in some environments be correct for all and required for most 
> userspace software should not leak into the kernel still stands.

You can have a "myconfigure" shell script that runs ./configure
in the current directory with the args you want for stuff like
that.

There is no need to contaminate your environment by setting
CFLAGS globally.
