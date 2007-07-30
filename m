Return-Path: <linux-kernel-owner+w=401wt.eu-S937584AbXG3KpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937584AbXG3KpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXG3KpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:45:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18767 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbXG3KpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:45:03 -0400
Message-ID: <46ADDEDA.1070201@sw.ru>
Date: Mon, 30 Jul 2007 16:51:38 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, devel@openvz.org
Subject: Re: [2.6.22] negative time jump
References: <46AD57BF.8090106@sw.ru>
In-Reply-To: <46AD57BF.8090106@sw.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Groundhog Day?

Vasily Averin wrote:
> [root@ts28 ~]# echo 1 > /proc/timer_stats
> [root@ts28 ~]# cat /proc/timer_stats
> Timer Stats Version: v0.1
> Sample period: 17.992 s
> 0 total events
> [root@ts28 ~]# cat /proc/timer_stats
> Timer Stats Version: v0.1
> Sample period: -4366.278 s
> 0 total events
> [root@ts28 ~]# cat /proc/timer_stats
> Timer Stats Version: v0.1
> Sample period: -4359.840 s
> 0 total events

[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -5.060 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 0.365 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 8.675 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4355.978 s
0 total events
[skip]

next loop:
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 9.968 s
0 total events
[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 11:10:17 ts28 now at 29196596844685 nsecs

[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 14.104 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 17.666 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 19.791 s
0 total events
[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: 21.278 s
0 total events
[root@ts28 ~]# echo q > /proc/sysrq-trigger
Jul 30 11:10:28 ts28 now at 24810199356545 nsecs

[root@ts28 ~]# cat /proc/timer_stats
Timer Stats Version: v0.1
Sample period: -4373.161 s
0 total events

Node is still alive and I'm able to look at proc files and press sysrq keys.

Thank you,
	Vasily Averin
