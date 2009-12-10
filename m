Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbZLJWRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbZLJWRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761926AbZLJWR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:17:29 -0500
Received: from mail.crca.org.au ([67.207.131.56]:47677 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761866AbZLJWR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:17:28 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 17:17:28 EST
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B217219.6040109@crca.org.au>
Date: Fri, 11 Dec 2009 09:11:37 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com> <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com> <20091210184931.257A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091210184931.257A.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, could you be more specific?

Is the delay Ksaki has picked out related to your report...

KOSAKI Motohiro wrote:
> (cc to netdev)
> 
> Hi net-folks
> 
>>> [  561.323866] mtrr: type mismatch for e0000000,10000000 old:
>>> write-back new: write-combining
>>> [ 2688.500033] No probe response from AP 00:02:2d:08:51:2b after
>>> 500ms, disconnecting.
>>> [ 2689.580376] wlan0: direct probe to AP 00:02:2d:08:51:2b (try 1)
> 
> What's mean "No probe response"? Why its point waste 2000sec?

[...]

>>> [  225.731462] ACPI: Preparing to enter system sleep state S3
>>> [  225.754167] Disabling non-boot CPUs ...
>>> [  225.809478] CPU 1 is now offline
>>> [  225.809481] lockdep: fixing up alternatives.
>>> [  225.809487] SMP alternatives: switching to UP code
>>> [  225.816500] Extended CMOS year: 2000
>>> [  225.816500] Back to C!
>>> [  225.816500] Extended CMOS year: 2000
>>> [  225.816720] Enabling non-boot CPUs ...
>>> [  225.818422] lockdep: fixing up alternatives.
>>> [  225.818425] SMP alternatives: switching to SMP code
>>> [  225.822188] Booting processor 1 APIC 0x1 ip 0x6000
>>> [  225.818021] Initializing CPU#1
>>> [  225.818021] CPU: Physical Processor ID: 0
>>> [  225.818021] CPU: Processor Core ID: 1
>>> [  225.913392] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
>>> [  225.937046] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
>>> [  225.937053] platform microcode: firmware: requesting intel-ucode/06-0f-0d
>>> [  225.937179] firmware microcode: parent microcode should not be sleeping
>>> [  285.940840] CPU1 is up

... or the 60 second delay before the CPU1 is up message?

Regards,

Nigel
