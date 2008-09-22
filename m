Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYIVLRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYIVLRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIVLR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:17:29 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:47282 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYIVLR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:17:28 -0400
Date: Mon, 22 Sep 2008 13:17:24 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] ep93xx: add ethernet support for edb9302
Message-ID: <20080922111724.GB7678@xi.wantstofly.org>
References: <1222034443-6732-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222034443-6732-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 07:00:43PM -0300, Thadeu Lima de Souza Cascardo wrote:

> EDB9302 board use EP9302 controller, which include an ethernet device.
> Register the platform device to enable it.
> 
> Using edb9302a won't work for these boards because they do not include
> the chip ID. Ethernet wouldn't work without this patch and it seems
> there is no edb9302 board without ethernet. So, this is the correct fix.
> ---
>  arch/arm/mach-ep93xx/edb9302.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Please submit to the ARM Linux patch tracker.
