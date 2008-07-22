Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYGVRkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYGVRkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYGVRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:40:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYGVRj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:39:59 -0400
Date: Tue, 22 Jul 2008 13:39:14 -0400
From: Andy Gospodarek <andy@greyhouse.net>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] tehuti: use request_firmware
Message-ID: <20080722173914.GH32408@gospo.rdu.redhat.com>
References: <1216741806.28669.6.camel@jaswinder.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216741806.28669.6.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 09:20:06PM +0530, Jaswinder Singh wrote:
> 
> Firmware blob is little endian.
> 
> Removed bdx_firmware_endianess() as firmware blob is already little endian
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  drivers/net/tehuti.c         |   29 +-
>  drivers/net/tehuti.h         |    1 +
>  drivers/net/tehuti_fw.h      |10712 ------------------------------------------
>  firmware/Makefile            |    1 +
>  firmware/WHENCE              |   12 +
>  firmware/tehuti/bdx.bin.ihex | 2678 +++++++++++
>  6 files changed, 2708 insertions(+), 10725 deletions(-)
>  delete mode 100644 drivers/net/tehuti_fw.h
>  create mode 100644 firmware/tehuti/bdx.bin.ihex
> 

This has been on my TODO list for a while, but just haven't gotten
around to it yet since I didn't feel like it was that crucial.  Thanks
for taking the time, Jaswinder.  Did you manage to test it?

I would like to try it out before ACKing, so I'll do that tonight or
tomorrow and post back my results.

