Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYGHUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYGHUPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYGHUPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:15:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYGHUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:15:15 -0400
Date: Tue, 8 Jul 2008 21:10:02 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nwflash: Push down BKL
Message-ID: <20080708201002.GC31327@flint.arm.linux.org.uk>
References: <20080522221610.5b339e0d@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522221610.5b339e0d@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:16:10PM +0100, Alan Cox wrote:
> Push the BKL down into the driver ready for the BKL ioctl removal

I'm nervous about large changes to this driver, since it's possible to
brick Netwinders with it, but this change is simple enough.

> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
