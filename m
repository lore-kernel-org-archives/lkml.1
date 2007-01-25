Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbXAYIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbXAYIbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXAYIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:31:25 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41058 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbXAYIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:31:25 -0500
Message-ID: <45B86AD8.8050802@drzeus.cx>
Date: Thu, 25 Jan 2007 09:31:20 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: au1xmmc R6 response support
References: <20070123100814.GA5001@roarinelk.homelinux.net> <45B65A73.90308@drzeus.cx> <20070124055202.GA6446@roarinelk.homelinux.net> <45B72F13.4040707@drzeus.cx> <20070125072000.GA8257@roarinelk.homelinux.net> <20070125081944.GA8358@roarinelk.homelinux.net>
In-Reply-To: <20070125081944.GA8358@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> 
> Actually, the bug is that because of MMC_RSP_R6 not being handled in
> the switch in au1xmmc_send_command(), the controller gets told that
> no response is expected. I changed the R6 to R1 in mmc.h, thats why
> it worked in the demoboard, and it also works now on the previously
> thought-to-be-broken HW.
> 

So in order to detect any similar problems in the future, I'd like a
patch that adds a "default:" to that switch statement.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
