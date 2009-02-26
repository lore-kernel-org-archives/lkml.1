Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZBZTzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZBZTzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZBZTz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:55:26 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:43334 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbZBZTzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:55:25 -0500
Message-ID: <49A6F39F.9040801@krogh.cc>
Date: Thu, 26 Feb 2009 20:55:11 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-rc6 seems to have trouble running ntpd reliable under load. My 
nagios system has just alerted me of drifting time on the machine upgraded.

Feb 26 19:09:25 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 26 19:10:31 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 26 19:25:21 quad12 ntpd[4901]: time reset -0.915488 s
Feb 26 19:29:11 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 26 19:31:21 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 19:34:37 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 26 19:37:53 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 19:46:27 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 26 19:46:27 quad12 ntpd[4901]: time reset -0.961386 s
Feb 26 19:50:30 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 26 19:51:34 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 26 20:01:55 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 20:06:18 quad12 ntpd[4901]: time reset -0.979177 s
Feb 26 20:10:15 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 26 20:11:21 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 20:14:52 quad12 ntpd[4901]: synchronized to 10.194.133.12, stratum 4
Feb 26 20:19:10 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 20:26:00 quad12 ntpd[4901]: time reset -0.923268 s
Feb 26 20:30:01 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13
Feb 26 20:30:30 quad12 ntpd[4901]: synchronized to 10.194.133.13, stratum 4
Feb 26 20:45:36 quad12 ntpd[4901]: time reset -0.919609 s
Feb 26 20:49:49 quad12 ntpd[4901]: synchronized to LOCAL(0), stratum 13

2.6.26.8 doesnt have this problem.

The "current_clocsource" is the same on both systems.

$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc


-- 
Jesper
