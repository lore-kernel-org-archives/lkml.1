Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZBMTIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZBMTIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZBMTHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:07:54 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40144 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBMTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:07:53 -0500
X-BigFish: VPS-52(z21eWz1432R62a3L98dR936eQ1805Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KF0QGN-02-W0B-01
Date: Fri, 13 Feb 2009 20:07:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc4 regression (was: Re: 2.6.28-rc9: oprofile
	regression)
Message-ID: <20090213190740.GD25042@erda.amd.com>
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49932C35.3020300@klingt.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 19:07:40.0749 (UTC) FILETIME=[579EEFD0:01C98E0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

still, I can not reproduce this with my tests with v2.6.29-rc4. The
regression on the systems I have runs fine on rc4. On the system you
have, is commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 the first bad
one? If so, I will split the patch into smaller pieces to find the
change that introduces the bug.

-Robert

On 11.02.09 20:51:17, Tim Blechmann wrote:
> i am not sure, whether it is related to my problem with 2.6.28, but
> running oprofile on kernel 2.6.29-rc4 (today's linus/master to be
> exact), i do not get _any_ NMI:
> 
> tim@thinkpad:~$ sudo opcontrol -s
> Using 2.6+ OProfile kernel interface.
> Using log file /var/lib/oprofile/samples/oprofiled.log
> Daemon started.
> Profiler running.
> tim@thinkpad:~$ cat /proc/interrupts |grep NMI
> NMI:          0          0   Non-maskable interrupts
> tim@thinkpad:~$ sudo opcontrol -d
> tim@thinkpad:~$ cat /proc/interrupts |grep NMI
> NMI:          0          0   Non-maskable interrupts
> 
> dmesg tells me:
> oprofile: using NMI interrupt.
> 
> best, tim
> 
> -- 
> tim@klingt.org
> http://tim.klingt.org
> 
> When you open windows, bugs get in.
> 



-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

