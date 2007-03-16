Return-Path: <linux-kernel-owner+w=401wt.eu-S965893AbXCPU2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbXCPU2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965896AbXCPU2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:28:31 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5911 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965894AbXCPU22 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:28:28 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: System hang on athlon64 cpufreq change
Date: Fri, 16 Mar 2007 15:28:11 -0500
Message-ID: <1449F58C868D8D4E9C72945771150BDFD96725@SAUSEXMB1.amd.com>
In-Reply-To: <c43b2e150703161151i3bf45074v54208542ca2212d3@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: System hang on athlon64 cpufreq change
Thread-Index: Acdn/Dp6XfQAgim7QFS8tNMMJd7zbwADQEnQ
References: <c43b2e150703161151i3bf45074v54208542ca2212d3@mail.gmail.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "wixor" <wixorpeek@gmail.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 16 Mar 2007 20:28:11.0120 (UTC)
 FILETIME=[9D960F00:01C76809]
X-WSS-ID: 69E422512EW1274736-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My kernel boots up with performance cpufreq governor, thus setting
> frequency to 2hgz. Then I change it to powersave governor, thus
> setting frequency to 1ghz just like that:
> 
> echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> 
> Everything works well. Then I launch mplayer and in 1/4 - 1/5 cases
> system hangs (I mean nothing works, including numlock and sysrq key).
> I suspect it's something with video card driver, and here comes my
> problem. I use ati's proprietary fglrx driver (i guess they may be
> calibrating they own delay loop, or something, and cputfreq change
> ruins it), so kernel is tainted, so you are unable to track the
> problem down.... eh.... well, but i hope there is some tiny chance
> there is something wrong i do, or maybe cpu doesn't like so drastic
> freq changes... well, if anybody has some idea, or just experience
> like mine, I ask for help. Thanks in advance.

The processor is not changing frequency in response to your
launch of mplayer.  The powersave governor forces it to the
lowest frequency regardless of system load.  You really want
to use ondemand for dynamic frequency scaling.

Can you use a serial or network console to capture any messages
the kernel is sending when mplayer starts?

-Mark Langsdorf
AMD, Inc.


