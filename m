Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXCHNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXCHNqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXCHNqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:46:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53666 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXCHNqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:46:06 -0500
Date: Thu, 8 Mar 2007 14:42:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Thibaut VARENE <T-Bone@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make elv_register() output atomic
Message-ID: <20070308134200.GI9671@kernel.dk>
References: <20070308140608.2b034013@Alucard.r3z0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308140608.2b034013@Alucard.r3z0>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08 2007, Thibaut VARENE wrote:
> Hi,
> 
> Booting 2.6.21-rc3-g45592145 I noticed the following on one of my
> machines in the bootlog:
> 
> io scheduler noop registered<6>Time: jiffies clocksource has been installed.
> 
> io scheduler deadline registered (default)
> 
> 
> Looking at block/elevator.c, it appears that elv_register() uses two
> consecutive printks in a non-atomic way, leading to the above glitch. The
> attached trivial patch fixes this issue, by using a single printk.

Thanks, looks like a good fix!

-- 
Jens Axboe

