Return-Path: <linux-kernel-owner+w=401wt.eu-S942268AbXHMNkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942268AbXHMNkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933721AbXHMJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:58:58 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:63739 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932325AbXHMJ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:58:56 -0400
Date: Mon, 13 Aug 2007 11:59:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [231/2many] MAINTAINERS - I2C SUBSYSTEM
Message-ID: <20070813115921.1fac3ccd@hyperion.delvare>
In-Reply-To: <46bffa2e.Gcwew3sHyZdFHycV%joe@perches.com>
References: <46bffa2e.Gcwew3sHyZdFHycV%joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:29:02 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 491a5a6..2c78350 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2199,6 +2199,9 @@ M:	khali@linux-fr.org
>  L:	i2c@lm-sensors.org
>  T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
>  S:	Maintained
> +F:	Documentation/i2c/
> +F:	drivers/i2c/
> +F:	include/linux/i2c*

As far as the i2c subsystem itself is concerned, the relevant header
files are only:

F: include/linux/i2c.h
F: include/linux/i2c-dev.h
F: include/linux/i2c-id.h

All the other i2c*.h files are driver-specific.

>  
>  I2C-TINY-USB DRIVER
>  P:	Till Harbaum


-- 
Jean Delvare
