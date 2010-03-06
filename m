Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab0CFO04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 09:26:56 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31520 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0CFO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 09:26:55 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.479
Message-ID: <4B92662A.4080604@tremplin-utc.net>
Date: Sat, 06 Mar 2010 15:26:50 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>, Andrew Morton <akpm@osdl.org>
CC: pavel@ucw.cz, daniel@caiaq.de, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/6] lis3lv02d: click and threshold interrupts
References: <1266318571-31083-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1266318571-31083-1-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 16-02-10 12:09, Samu Onkalo schreef:
> This patch set replaces my previous one.
> (see http://www.spinics.net/lists/kernel/msg994446.html)
> 
> Power control of the chip is dropped out since it requires more work.
> Runtime-pm support was requested and that takes some time to implement
> and test. I'll send it as a separate patch.
> 
> patches 1 - 3 are not touched compared to patch set 1 and they
> are marked as tested-by Daniel Mack <daniel@caiaq.de> and
> acked-by Éric Piel <eric.piel@tremplin-utc.net>.
> Patch 4 is marked as tested-by Daniel Mack <daniel@caiaq.de>.
> 
:
> 
> Samu Onkalo (6):
>   lis3: Add missing constants for 8bit device
>   lis3: Separate configuration function for 8 bit device
>   lis3: Introduce platform data for second ff / wu unit
>   lis3: Add skeletons for interrupt handlers
>   lis3: Interrupt handlers for 8bit wakeup and click events
>   lis3: Setup poll interval limits
(sorry for the delay, I was on holidays)

Just had a look at the patches and they seem fine, so here is my
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

Andrew, would you mind to pick this series of patches to replace the
dropped one yesterday?

Thanks,
Eric
