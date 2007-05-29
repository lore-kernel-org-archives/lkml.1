Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbXE2VBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbXE2VBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbXE2VBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:01:41 -0400
Received: from tim.rpsys.net ([194.106.48.114]:49481 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbXE2VBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:01:41 -0400
Subject: Re: [PATCH] Samsung LTV350QV LCD driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <11804683571524-git-send-email-hskinnemoen@atmel.com>
References: <11804683571524-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 22:01:17 +0100
Message-Id: <1180472477.5822.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 21:52 +0200, Haavard Skinnemoen wrote:
> This patch adds support for powering on and off the Samsung LTV350QV
> LCD panel via SPI. The driver responds to framebuffer power
> management, it powers off the panel on reboot/halt/poweroff, and it
> can also be controlled through sysfs. The panel is powered up when the
> module is loaded and off when the module is unloaded.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

The LCD class device bits look fine to me. The only change I'd request
is not to change the order of things in drivers/video/backlight/Kconfig.
If you do want to reword one of those entries (which is what I think you
wanted to do), send it as a separate patch please.

David, any objections to the SPI bits?

Richard

