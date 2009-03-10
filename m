Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZCJQ4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZCJQ4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZCJQ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:56:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25778 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZCJQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:56:22 -0400
Date: Tue, 10 Mar 2009 17:56:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 22/31] i2c: Auto-load i2c_dev module when device opened.
Message-ID: <20090310175612.7e5b8272@hyperion.delvare>
In-Reply-To: <c9e8ec654db2ee34fc9fda29222aee9dd085ddaa.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<c9e8ec654db2ee34fc9fda29222aee9dd085ddaa.1236702228.git.scott@canonical.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott,

Your clock is off by a significant number of days, isn't it?

On Mon, 2 Mar 2009 18:41:51 +0000, Scott James Remnant wrote:
> The i2c_dev module is missing the char-major-89-* alias that would cause
> it to be auto-loaded when a device of that type is opened.  This patch
> adds the alias.

Why not, however this is pretty pointless nowadays as /dev nodes tend
to be created dynamically by udev, so there is no way i2c-dev will
auto-load.

> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/i2c/i2c-dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index 7e13d2d..f3f83ba 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -618,6 +618,7 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
>  		"Simon G. Vogl <simon@tk.uni-linz.ac.at>");
>  MODULE_DESCRIPTION("I2C /dev entries driver");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CHARDEV_MAJOR(I2C_MAJOR);
>  
>  module_init(i2c_dev_init);
>  module_exit(i2c_dev_exit);


-- 
Jean Delvare
