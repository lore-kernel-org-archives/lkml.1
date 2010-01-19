Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587Ab0ASI4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0ASI4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468Ab0ASI4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:56:15 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:53976 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170Ab0ASI4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:56:15 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPYBVUtbssBB/2dsb2JhbADWFgqEKQQ
Date: Tue, 19 Jan 2010 09:56:13 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Joe Perches <joe@perches.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdogs: constify struct watchdog_info
Message-ID: <20100119085613.GA3804@infomag.iguana.be>
References: <1263865537.18117.23.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263865537.18117.23.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/watchdog/acquirewdt.c     |    2 +-
...
>  drivers/watchdog/wm8350_wdt.c     |    2 +-
>  51 files changed, 52 insertions(+), 52 deletions(-)

NAK (Although the patch itself is good).
I created another patch that does this and moves the struct out of the ioctl call as part of the generic watchdog conversion.
Will be sent to LKML in a short time together with other stuff.

Kind regards,
Wim.

