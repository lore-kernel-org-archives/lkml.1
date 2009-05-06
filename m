Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZEFHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZEFHQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZEFHQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:16:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35271 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZEFHQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:16:42 -0400
Date: Wed, 6 May 2009 08:15:48 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean Delvare <khali@linux-fr.org>, linux-next@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Wolfram Sang <w.sang@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the i2c tree with the arm-current
	tree
Message-ID: <20090506071547.GA29466@flint.arm.linux.org.uk>
References: <20090506131031.83f1b04d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506131031.83f1b04d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:10:31PM +1000, Stephen Rothwell wrote:
> Hi Jean,
> 
> Today's linux-next merge of the i2c tree got a conflict in
> arch/arm/configs/kirkwood_defconfig arch/arm/configs/mv78xx0_defconfig
> arch/arm/configs/orion5x_defconfig between various commits from the
> arm-current tree and commit c637675d24618d8e0afe344096a1ad96986c4f50
> ("i2c/chips: Move max6875 to drivers/misc/eeprom") from the i2c tree.

Since defconfig updates are always going to create lots of noise, and
the files are normally out of date, the *only* sensible way to handle
updates is to have one tree dealing with them per architecture.

Spreading them across multiple trees and then expecting merges to sort
out the resulting mess is unreasonable; they just change far too much
when updates happen.  Moreover, defconfig updates should be in their
own separate commit and not combined with other changes.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
