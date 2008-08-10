Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYHJLmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYHJLmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYHJLmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:42:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48557 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYHJLmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:42:04 -0400
Date: Sun, 10 Aug 2008 12:41:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix watchdog/ixp4xx_wdt.c compilation
Message-ID: <20080810114121.GA4441@flint.arm.linux.org.uk>
References: <20080810110341.GC16146@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810110341.GC16146@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 02:03:41PM +0300, Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 20d35f3e50ea7e573f9568b9fce4e98523aaee5d
> ([WATCHDOG 22/57] ixp4xx_wdt: unlocked_ioctl):

Thanks Adrian.

I've merged all these into one big "Fix a pile of broken watchdog drivers"
commit along with the remaining fixes for s3c2410_wdt that were missed
from my patch.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
