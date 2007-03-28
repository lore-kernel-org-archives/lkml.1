Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXC1SEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXC1SEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXC1SEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:04:48 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55054 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbXC1SEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:04:47 -0400
Date: Wed, 28 Mar 2007 20:04:46 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: tty OOPS (Re: 2.6.21-rc5-mm2)
Message-ID: <20070328180446.GA7528@rhlx01.hs-esslingen.de>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de> <20070328173310.GA4682@rhlx01.hs-esslingen.de> <20070328174524.GA25709@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328174524.GA25709@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[unrelated maintainers removed, Alexey added]

On Wed, Mar 28, 2007 at 07:45:24PM +0200, Andreas Mohr wrote:
> Hi,
> 
> just wanted to add that when analyzing the backtrace I found the comment
> at drivers/char/vt.c/con_close() to be VERY suspicious...
> (need to take tty_mutex to prevent concurrent thread tty access).
> This might just be what happened here despite trying to protect against it.

OK, can we assume that one of

+protect-tty-drivers-list-with-tty_mutex.patch
+tty-minor-merge-correction.patch
+tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

is responsible / not implemented fully?

Andreas Mohr
