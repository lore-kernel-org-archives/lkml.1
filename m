Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbYKJUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbYKJUFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYKJUFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:05:03 -0500
Received: from mailgw3a.lmco.com ([192.35.35.7]:46063 "EHLO mailgw3a.lmco.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYKJUFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:05:01 -0500
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 15:05:01 EST
Date: Mon, 10 Nov 2008 14:43:55 -0500
From: Gautam Thaker <gautam.h.thaker@lmco.com>
Subject: seeing some "Bad page state in process.." msgs....
To: linux-kernel@vger.kernel.org
Message-id: <49188EFB.7070601@atl.lmco.com>
Organization: Lockheed Martin -- Advanced Technology Laboratories
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
X-Enigmail-Version: 0.95.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running 2.6.26.6-rt11-1.2944.fc6.emulab-highmem #1 SMP PREEMPT RT

My test pgm is a java pgm that has about 650 threads in it (i am doing some stress testing). This test runs w/o any 
kernel messages when run on vanilla 2.6.25 kernel. But w/ the above RT kernel I see some kernel msgs that I do not 
understand.

ANy hints?

root@node0>  time java -classpath .:../../../utils/hist Test1 500 10001 1 > out.500_senders_RT

Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
node0 kernel: Bad page state in process 'java'

Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
node0 kernel: page:c8a690b8 flags:0x80000000 mapping:c8a690c8 mapcount:0 count:0

Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...

Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
node0 kernel: Trying to fix it up, but a reboot is needednode0
  kernel: Backtrace:

<MY ADDED NOTE: NO Backtrace is produced.>

root@node0> uname -a
Linux node0.onepc2950rtnode.atlqos.emulab.atl.lmco.com 2.6.26.6-rt11-1.2944.fc6.emulab-highmem #1 SMP PREEMPT RT Sat Nov 
8 20:10:03MST 2008 i686 i686 i386 GNU/Linux
root@node0>

