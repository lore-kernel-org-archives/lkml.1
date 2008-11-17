Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYKQDci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYKQDci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYKQDc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:32:28 -0500
Received: from main.gmane.org ([80.91.229.2]:53033 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbYKQDc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:32:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: seeing some "Bad page state in process.." msgs....
Date: Sun, 16 Nov 2008 21:32:16 -0600
Message-ID: <4920E5C0.5050602@shaw.ca>
References: <49188EFB.7070601@atl.lmco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <49188EFB.7070601@atl.lmco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautam Thaker wrote:
> I am running 2.6.26.6-rt11-1.2944.fc6.emulab-highmem #1 SMP PREEMPT RT
> 
> My test pgm is a java pgm that has about 650 threads in it (i am doing 
> some stress testing). This test runs w/o any kernel messages when run on 
> vanilla 2.6.25 kernel. But w/ the above RT kernel I see some kernel msgs 
> that I do not understand.
> 
> ANy hints?
> 
> root@node0>  time java -classpath .:../../../utils/hist Test1 500 10001 
> 1 > out.500_senders_RT
> 
> Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
> node0 kernel: Bad page state in process 'java'
> 
> Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
> node0 kernel: page:c8a690b8 flags:0x80000000 mapping:c8a690c8 mapcount:0 
> count:0
> 
> Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
> 
> Message from syslogd@node0 at Mon Nov 10 18:54:14 2008 ...
> node0 kernel: Trying to fix it up, but a reboot is needednode0
>  kernel: Backtrace:
> 
> <MY ADDED NOTE: NO Backtrace is produced.>

You should be able to get this from dmesg, or from /var/log/messages if 
you rebooted already..

> 
> root@node0> uname -a
> Linux node0.onepc2950rtnode.atlqos.emulab.atl.lmco.com 
> 2.6.26.6-rt11-1.2944.fc6.emulab-highmem #1 SMP PREEMPT RT Sat Nov 8 
> 20:10:03MST 2008 i686 i686 i386 GNU/Linux
> root@node0>
> 

