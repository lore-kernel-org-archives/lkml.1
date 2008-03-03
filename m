Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbYCCVHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbYCCVHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761784AbYCCVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:06:49 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:57981 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858AbYCCVGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:06:48 -0500
Date: Mon, 3 Mar 2008 22:05:30 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Pavel Machek <pavel@ucw.cz>
Cc: huggie@earth.li, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080303220530.49201544@mjolnir.drzeus.cx>
In-Reply-To: <20080303203808.GH13869@elf.ucw.cz>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
	<20080302104031.GB3861@ucw.cz>
	<20080303204300.69cbe392@mjolnir.drzeus.cx>
	<20080303203808.GH13869@elf.ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 21:38:08 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2008-03-03 20:43:00, Pierre Ossman wrote:
> > The problem is that the kernel sleeps _less_ than asked for, not more. No hardware can be expected to work if its needed delays aren't respected.
> > 
> 
> Oops, that's bad. Can you perhaps create small testcase for
> scheduler/timer people to play with?
> 
> Also... you may want to switch timesources. notsc fixed "wait for much
> too long" for me.

I'm afraid I could never reproduce the problem. So it's Simon that will have to do the tests for now..


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
