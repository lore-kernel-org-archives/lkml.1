Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXJaUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXJaUDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXJaUDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:03:14 -0400
Received: from mta13.adelphia.net ([68.168.78.44]:36285 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXJaUDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:03:14 -0400
Message-ID: <4728DF7E.9090606@rqdq.com>
Date: Wed, 31 Oct 2007 16:03:10 -0400
From: Benjamin Yates <benjamin@rqdq.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22+, CONFIG_NO_HZ=n, but irq/s looks like NO_HZ=y
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    can't find many references on this one, so posting here...

    CONFIG_NO_HZ=n, but vmstat output shows int/sec which looks like a 
dynticks setup.

    vmstat lies?

    vmstat needs an update?

    -benjamin

   

root@blahblah /usr/src/linux # uname -a
Linux blahblah 2.6.23.1 #2 SMP Sun Oct 14 23:40:05 EDT 2007 i686 Dual 
Core AMD Opteron(tm) Processor 185 AuthenticAMD GNU/Linux

root@blahblah /usr/src/linux # zcat /proc/config.gz | grep HZ
# CONFIG_NO_HZ is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100

root@blahblah /usr/src/linux # vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa
 3  0      0 265492  85576 105432    0    0    45   153   26  230 24 28 
47  1
 0  0      0 265480  85576 105432    0    0     0     0    6   52  0  0 
100  0
 0  0      0 264976  85576 105432    0    0     0     0    9   65  1  3 
96  0
 0  0      0 265876  85576 105432    0    0     0     0   10   65  1  2 
97  0

