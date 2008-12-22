Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYLVQid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYLVQid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 11:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYLVQiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 11:38:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36075 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYLVQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 11:38:23 -0500
Date: Mon, 22 Dec 2008 16:33:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] arch/arm/plat-mxc: Add local_irq_restore in error handling code
Message-ID: <20081222163309.GA16392@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.0812212153570.3635@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812212153570.3635@ask.diku.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 09:54:23PM +0100, Julia Lawall wrote:
> There is a call to local_irq_restore in the normal exit case, so it would
> seem that there should be one on an error return as well.

Please check what's queued up for the next merge; a similar change is
already merged as part of a larger patch.  (which is more correct
since it calls local_irq_restore before the printk.)
