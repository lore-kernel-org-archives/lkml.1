Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYGFNpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYGFNpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYGFNoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:44:55 -0400
Received: from wasp.net.au ([203.190.192.17]:47839 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbYGFNoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:44:54 -0400
Message-ID: <4870CC50.5070004@wasp.net.au>
Date: Sun, 06 Jul 2008 17:44:48 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11039] 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.tp.QzLcIB@albercik>
In-Reply-To: <uBi7uNfg81L.A.tp.QzLcIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11039
> Subject		: 2.6.28-rc8-git3 forcedeth WARNING (kills the interface)
> Submitter	: Brad Campbell <brad@wasp.net.au>
> Date		: 2008-07-03 10:07 (4 days old)
> References	: http://marc.info/?l=linux-netdev&m=121508714430752&w=4

While it is certainly a problem I can't verify it as a regression. When I got the machine I ran it 
with 2.6.25 but found SATA errors were locking the box.

The SATA issue is resolved with 2.6.26-rc and I'm not terribly keen to risk my data to go back and 
check unless someone absolutely needs me to.

It does appear to be quite a problem though.

brad@srv:~$ dmesg | head -n5
[    0.000000] Linux version 2.6.26-rc8-git4 (brad@srv) (gcc version 4.1.2 20061115 (prerelease) 
(Debian 4.1.1-21)) #5 SMP Fri Jul 4 23:08:38 GST 2008
[    0.000000] Command line: root=/dev/md1 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)

brad@srv:~$ dmesg | grep 'eth1: tx_timeout' | wc -l
27

brad@srv:~$ uptime
  17:40:25 up 1 day,  1:15,  5 users,  load average: 0.73, 0.61, 0.49

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
