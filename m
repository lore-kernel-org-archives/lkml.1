Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbXE1ThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbXE1ThX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXE1ThM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:37:12 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3757 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbXE1ThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:37:10 -0400
Date: Mon, 28 May 2007 20:36:58 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM/ARM26: Enable arbitary speed tty ioctls and split input/output speed
Message-ID: <20070528193658.GF5737@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070523172739.1d3a918c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523172739.1d3a918c@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 05:27:39PM +0100, Alan Cox wrote:
> Add the ioctls and values needed for this to the ARM26/ARM32 ports. The
> actual code has been in the base kernel for a while and automatically
> turns on when a port sets the required defines.

Did you forget to provide a termios2 structure for ARM?  Hope you
remembered for the other arches:

drivers/char/tty_ioctl.c: In function `set_termios':
drivers/char/tty_ioctl.c:429: error: invalid application of `sizeof' to incomplete type `termios2'
drivers/char/tty_ioctl.c: In function `n_tty_ioctl':
drivers/char/tty_ioctl.c:732: error: invalid application of `sizeof' to incomplete type `termios2'

Will copy the i386 version into ARM's termbits.h

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
