Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYHGRGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYHGRGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYHGRF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:05:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:38476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYHGRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:05:57 -0400
Subject: Re: [PATCH] radeon_cp: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200808070624.12214.gene.heskett@gmail.com>
References: <1218095497.4016.3.camel@jaswinder.satnam>
	 <200808070624.12214.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 22:34:08 +0530
Message-Id: <1218128648.14483.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gene,

On Thu, 2008-08-07 at 06:24 -0400, Gene Heskett wrote:

> When applied to 2.6.27-rc2, firmware/Makefile was rejected, so I manually added 
> the blob list to that Makefile in what looked to be the correct place.  And added a
> "make firmware_install" to my kernel builder script.
> 
> Unforch:
>   MK_FW   firmware/R100_cp.bin.ihex.gen.S
> make[1]: *** No rule to make target `firmware/R100_cp.bin.ihex', needed by `firmware/R100_cp.bin.ihex.gen.o'.  Stop.
> make[1]: *** Waiting for unfinished jobs....
> make: *** [firmware] Error 2
> 

It seems your firmware/Makefile is not good.

it should look like this :-

fw-shipped-$(CONFIG_DRM_RADEON) += radeon/R100_cp.bin radeon/R200_cp.bin \
                                   radeon/R300_cp.bin radeon/R420_cp.bin \
                                   radeon/RS600_cp.bin radeon/RS690_cp.bin \
                                   radeon/R520_cp.bin


I think you forget to write radeon before R100_cp.bin

And you can collect my updated patch from :
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git

Thank you,

Jaswinder Singh.

