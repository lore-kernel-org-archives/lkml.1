Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYCCToe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYCCToe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYCCTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:44:26 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:58510 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbYCCToZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:44:25 -0500
Date: Mon, 3 Mar 2008 20:43:00 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Pavel Machek <pavel@ucw.cz>
Cc: huggie@earth.li, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080303204300.69cbe392@mjolnir.drzeus.cx>
In-Reply-To: <20080302104031.GB3861@ucw.cz>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
	<20080302104031.GB3861@ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 11:40:31 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Is mmc slow or does it just break down? Slow would be expected, but
> breaking down should be fixed in MMC, too...
> 

The problem is that the kernel sleeps _less_ than asked for, not more. No hardware can be expected to work if its needed delays aren't respected.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
