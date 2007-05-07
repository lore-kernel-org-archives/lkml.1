Return-Path: <linux-kernel-owner+w=401wt.eu-S966799AbXEGUr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966799AbXEGUr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966550AbXEGUrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:47:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55670
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966539AbXEGUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:47:23 -0400
Date: Mon, 07 May 2007 13:47:26 -0700 (PDT)
Message-Id: <20070507.134726.21927689.davem@davemloft.net>
To: hskinnemoen@atmel.com
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fbdev: Add support for AVR32
From: David Miller <davem@davemloft.net>
In-Reply-To: <11785512332033-git-send-email-hskinnemoen@atmel.com>
References: <11785512332033-git-send-email-hskinnemoen@atmel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Date: Mon,  7 May 2007 17:20:33 +0200

> Provide framebuffer page protection flags and definitions of
> fb_readl/fb_writel for AVR32.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

This isn't directed to you specifically, I'm just making a general
comment.

We're at the point where these two snippets of code in the fb layer
are a total mess of ifdefs.

It's time we made an include/asm-foo/fb.h header file and abstracted
out the necessary details there.
