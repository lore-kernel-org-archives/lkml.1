Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXG2Pgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXG2Pgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763289AbXG2Pgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:36:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36248 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761047AbXG2Pgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:36:38 -0400
Date: Sun, 29 Jul 2007 16:22:48 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, spyro@f2s.com, James.Bottomley@SteelEye.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the broken SCSI_ACORNSCSI_3 driver
Message-ID: <20070729152248.GB25431@flint.arm.linux.org.uk>
References: <20070729145915.GF16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729145915.GF16817@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 04:59:15PM +0200, Adrian Bunk wrote:
> The SCSI_ACORNSCSI_3 driver:
> - has been marked as BROKEN for more than one year and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.

NAK.  I've had a patch to resurect it for some time.  Notice that this
merge window I applied some patches to the other acorn scsi drivers -
once I get enough time to separate out the changes I'll be applying
those patches.  It's relatively low priority for me though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
