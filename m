Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbYFDRrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbYFDRrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761061AbYFDRrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:47:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55326 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870AbYFDRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:47:37 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5309"; a="3677300"
Message-ID: <4846D54E.8080501@qualcomm.com>
Date: Wed, 04 Jun 2008 10:47:58 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com> <200806041818.29709.ioe-lkml@rameria.de>
In-Reply-To: <200806041818.29709.ioe-lkml@rameria.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser wrote:
> Hi Max,
> 
> On Wednesday 04 June 2008, Max Krasnyanskiy wrote:
>> btw Ingo, I just realized that maxcpu= option is exactly what you need.
>> Here is how you can use it.
>> Boot your system with maxcpus=1. That way the kernel will only bring up 
>> processor 0. I'm assuming cpu0 is "good" otherwise your system is totally 
>> busted :). Other cpus will stay off-line and will not be initialized.
>> Then once the system boots you can selectively bring "good" processors online 
>> by doing
>> 	echo 1 > /sys/devices/system/cpu/cpuN/online
>>
> 
> I just tested it on the Ubuntu Hardy standard kernel on an AMD DualCore.
> The /sys/devices/system/cpu/cpu1 entry doesn't show up.
> 
> I can send you the dmesg/config in private, if you want.
> 
> Did you test your suggestion? 
No, I just give random suggestions without verifying them first ;-).
Of course I tried it. Sounds like your Ubuntu kernel does not have "CPU
hotplug / suspend on SMP" enabled. I thought that all distributions enable it
by default these days.

Max
