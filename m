Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXJAHdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXJAHdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXJAHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:33:24 -0400
Received: from tim.rpsys.net ([194.106.48.114]:40315 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbXJAHdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:33:24 -0400
Subject: Re: What's in linux-backlight.git for 2.6.24?
From: Richard Purdie <rpurdie@rpsys.net>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071001024304.GA10799@kroah.com>
References: <1191196327.6115.48.camel@localhost.localdomain>
	 <20071001024304.GA10799@kroah.com>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 08:33:09 +0100
Message-Id: <1191223989.5938.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-30 at 19:43 -0700, Greg KH wrote:
> On Mon, Oct 01, 2007 at 12:52:07AM +0100, Richard Purdie wrote:
> > I've become aware that I should be posting a merge plan, probably
> > slightly earlier than this but better late than never.
> 
> Can you post a diffstat too, so we get an idea of what is going to be
> changing?

Oops, yes...

 arch/arm/mach-pxa/corgi.c           |   18 +
 arch/arm/mach-pxa/spitz.c           |   18 +
 drivers/video/backlight/Kconfig     |   23 +-
 drivers/video/backlight/Makefile    |    2 
 drivers/video/backlight/backlight.c |    2 
 drivers/video/backlight/corgi_bl.c  |   22 +-
 drivers/video/backlight/cr_bllcd.c  |   35 ++-
 drivers/video/backlight/lcd.c       |    2 
 drivers/video/backlight/ltv350qv.c  |  330 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/ltv350qv.h  |   95 ++++++++++
 include/asm-arm/arch-pxa/sharpsl.h  |    6 
 include/linux/backlight.h           |    9 
 12 files changed, 518 insertions(+), 44 deletions(-)

-- 
Richard

