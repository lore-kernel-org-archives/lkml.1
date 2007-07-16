Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbXGPCeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbXGPCeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 22:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbXGPCe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 22:34:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34194 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898AbXGPCe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 22:34:27 -0400
Date: Mon, 16 Jul 2007 04:33:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/mmc/core/: make 4 functions static
Message-ID: <20070716023345.GO3565@stusta.de>
References: <20070712235602.GV3492@stusta.de> <20070715185234.584f7e1c@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070715185234.584f7e1c@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 06:52:34PM +0200, Pierre Ossman wrote:
> On Fri, 13 Jul 2007 01:56:02 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > This patch makes the following needlessly global functions static:
> > - sd_ops.c: mmc_wait_for_app_cmd()
> > - core.c: mmc_start_request()
> 
> I am a bit torn about these two. Even though we don't cater to
> out-of-tree stuff, having these as exported symbols shows that they are
> part of the API. Removing them might risk people going about doing
> something silly because they don't know the functionality exists, and
> we might not spot it at patch review time.

If mmc_start_request() is considered part of an API people should use, 
why isn't there a prototype in a header file?

> Rgds

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

