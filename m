Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbXGOQwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbXGOQwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbXGOQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:52:36 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:57378 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbXGOQwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:52:36 -0400
Date: Sun, 15 Jul 2007 18:52:34 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/mmc/core/: make 4 functions static
Message-ID: <20070715185234.584f7e1c@poseidon.drzeus.cx>
In-Reply-To: <20070712235602.GV3492@stusta.de>
References: <20070712235602.GV3492@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 01:56:02 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> This patch makes the following needlessly global functions static:
> - sd_ops.c: mmc_wait_for_app_cmd()
> - core.c: mmc_start_request()

I am a bit torn about these two. Even though we don't cater to
out-of-tree stuff, having these as exported symbols shows that they are
part of the API. Removing them might risk people going about doing
something silly because they don't know the functionality exists, and
we might not spot it at patch review time.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
