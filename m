Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXK2JmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXK2JmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbXK2JmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:42:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:48508 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbXK2Jl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:41:59 -0500
Date: Thu, 29 Nov 2007 04:41:55 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: does /proc/sys/kernel/modprobe actually do anything?
Message-ID: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  (i asked about this earlier on the newbies list, but after poking
around a bit more, i thought i'd ask here.)

  according to Documentation/debugging-modules.txt:

The correct way of debugging module problems is something like this:

echo '#! /bin/sh' > /tmp/modprobe
echo 'echo "$@" >> /tmp/modprobe.log' >> /tmp/modprobe
echo 'exec /sbin/modprobe "$@"' >> /tmp/modprobe
chmod a+x /tmp/modprobe
echo /tmp/modprobe > /proc/sys/kernel/modprobe

  i've tried that and i don't see that it does anything whatsoever.  i
ran modprobe under "strace" and it doesn't appear to make any effort
to check /proc/sys/kernel/modprobe.  i even downloaded the source to
the module-init-tools package and scanned the source and ... nothing.

  so what's up with that?

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
