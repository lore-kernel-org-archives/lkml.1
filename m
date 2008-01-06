Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYAFM77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYAFM77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYAFM7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:59:49 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1965 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752621AbYAFM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:59:48 -0500
Date: Sun, 6 Jan 2008 13:59:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>
Subject: Re: [patch 2.6.24-rc6-mm 8/9] gpiolib: pca9539 i2c gpio expander
 support
Message-ID: <20080106135945.2c21b8cd@hyperion.delvare>
In-Reply-To: <200801051140.56797.david-b@pacbell.net>
References: <200712281927.32575.david-b@pacbell.net>
	<200712281958.53694.david-b@pacbell.net>
	<200801051140.56797.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 11:40:55 -0800, David Brownell wrote:
> From: eric miao <eric.miao@marvell.com>
> Subject: [PATCH] gpiolib: support PCA9539 GPIO expander
> 
> This adds a new-style I2C driver with basic support for the sixteen
> bit PCA9539 GPIO expanders.  These chips have multiple registers,
> push-pull output drivers, and (not supported in this patch) pin
> change interrupts.
> 
> Board-specific code must provide "pca9539_platform_data" with each
> chip's "i2c_board_info".  That provides the GPIO numbers to be used
> by that chip, and callbacks for board-specific setup/teardown logic.
> 
> Derived from drivers/i2c/chips/pca9539.c (which has no current known
> users).  This is faster and simpler; it uses 16-bit register access,
> and cache the OUTPUT and DIRECTION registers for fast access
> 
> Signed-off-by: eric miao <eric.miao@marvell.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Incorporates cleanups noted by Jean Delvare.
> 
>  drivers/gpio/Kconfig        |   10 +
>  drivers/gpio/Makefile       |    1 
>  drivers/gpio/pca9539.c      |  271 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pca9539.h |   18 ++
>  4 files changed, 300 insertions(+)

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
