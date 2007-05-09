Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbXEIMxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbXEIMxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXEIMx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:53:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34895 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbXEIMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:53:24 -0400
Date: Wed, 9 May 2007 14:52:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: nbd problem.
In-Reply-To: <20070509123820.GA1618@bitwizard.nl>
Message-ID: <Pine.LNX.4.61.0705091452070.32349@yvahk01.tjqt.qr>
References: <20070508194053.GA23615@bitwizard.nl>
 <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com>
 <20070509111049.GA2362@bitwizard.nl> <20070509123820.GA1618@bitwizard.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9 2007 14:38, Rogier Wolff wrote:
>
>ozon:~> ps auxww | grep D
>USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>root       110  0.4  0.0      0     0 ?        D    10:28   0:31 [pdflush]
>root       112  0.0  0.0      0     0 ?        D<   10:28   0:05 [kswapd0]
>root      1649  0.0  0.1   1604   108 pts/0    D+   11:17   0:03 nbd-client petisuix 1234 /dev/nd0
>root      1654  0.9  4.5   4648  2816 pts/0    D+   11:17   0:44 rsync /usr/src/linux-2.6.21.ozon /mnt/test1 -av --progress
>wolff     1716  0.0  0.9   1648   560 pts/1    R+   12:33   0:00 grep D
>ozon:~> 
>
>Can anybody help me figure out what these proceses are waiting for?

echo t >/proc/sysrq-trigger

dumps a ton to /var/log/messages.



Jan
-- 
