Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXHEDXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXHEDXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 23:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763915AbXHEDX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 23:23:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51050
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756676AbXHEDX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 23:23:26 -0400
Date: Sat, 04 Aug 2007 20:23:26 -0700 (PDT)
Message-Id: <20070804.202326.39158668.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: fix fallout from O_CLOEXEC changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070804203005.GA7668@martell.zuzino.mipt.ru>
References: <20070804203005.GA7668@martell.zuzino.mipt.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 5 Aug 2007 00:30:05 +0400

> Just "#define O_CLOEXEC" is OK, because asm-generic/fcntl.h will check if it's
> already defined.
> 
> Loads of "struct flock inside parameter list" warnings and
> "O_WRONLY undefined" errors.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Mark F. already posted a fix to sparclinux@vger.kernel.org for
this, but thanks.
