Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXCVOsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXCVOsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXCVOsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:48:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbXCVOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:48:00 -0400
From: Christian <christiand59@web.de>
To: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rsdl improvements
Date: Thu, 22 Mar 2007 15:46:57 +0100
User-Agent: KMail/1.9.6
Cc: ck list <ck@vds.kolivas.org>
References: <200703220429.45311.kernel@kolivas.org>
In-Reply-To: <200703220429.45311.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221546.57330.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX19viJD7XJNBAOvfj/SAvHwTHctei3n5QXsoGob
 16TUrRh0ZiyRTfw25M0isvkANEkWlpGF24DcpNIw/OLBaPfbtr
 HFts5pOeAN20mZi7z9MxA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List!

I'm using the new scheduler since a few days and I have to say that this is an 
amazing improvement for gaming loads. When playing enemy-territory the 
animations are completly smooth and fluid, without any hiccups. Et runs now 
clearly better on Linux than on my Win XP partition (same HW). I have never 
seen such smooth animations on any OS before.
(I have LD_PRELOADED a libnoyield ripped from a post here on lkml)

I can play et and have a 'nice make -j4' in the background and the only thing 
you notice is longer load-times/more latency on disk access. I can't tell if 
the compilation is finished or not while gaming ;-)

On everyday dektop usage there is a slight improvement too. But for me the 
current mainline scheduler has no problems. I couldn't tell which scheduler 
is in use by only doing desktop related things. Mainline scheduler is good 
and has no probs there.

I didn't find any severe regressions on my dual core system. No problems with 
sound or video even with make -j8 kernel compile in the background.

When I start a single cpu-hog it tends to jump around cores every second or 
so. I think that this is a regression to the current scheduler which tends to 
have a better affinity management on multicore.

Really nice work Con! ;-)

-Christian
