Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZAFQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZAFQKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZAFQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:10:09 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:56133 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZAFQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:10:08 -0500
Date: Tue, 6 Jan 2009 16:10:06 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang M??es <wolfgang.mues@auerswald.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Message-ID: <20090106161006.GA28020@console-pimps.org>
References: <200901061517.01872.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901061517.01872.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:17:01PM +0100, Wolfgang M??es wrote:
> +
> +	/* The MMC framework does a good job of computing timeouts
> +           according to the mmc/sd standard. However, we found that in
> +           SPI mode, there are many cards which need a longer timeout
> +           of 1s after receiving a long stream of write data. */
> +	struct timeval tv = ktime_to_timeval(timeout);
> +	if (tv.tv_sec == 0)
> +		timeout = ktime_set(1,0);	
>  

Which cards are you having issues with?

Modifying the code to no longer abide by the standard doesn't seem like a
win to me.
