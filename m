Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXJVXAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXJVXAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJVXAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:00:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:6353 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXJVXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=O21AkE5UQ6BDyJaeg3++2AxV7liQyIGJ0N2pUHSEDSZpewCCY7GII+OJ8Md7yMUBs3ncEGEqI58ZaAQtiRcVvAg9HHTxzwlxTIgBh1e/A0/y0hrlsQzK09TP4HdUSo2BvBc16Q59KHOyGnlqU+DhcJqtP0ePS18zTl/x4ejPxTI=
Message-ID: <471D2B7F.40604@googlemail.com>
Date: Tue, 23 Oct 2007 01:00:15 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
Subject: Re: Resume problems
References: <471CCC98.10101@googlemail.com> <200710230035.32924.rjw@sisk.pl>
In-Reply-To: <200710230035.32924.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 22 October 2007 18:15, Gabriel C wrote:
>> Hi all ,
>>
>> I'm running current git + aic7xxx suspend patch from  http://bugzilla.kernel.org/show_bug.cgi?id=3062
>> on a Dell Precision WorkStation 530 MT SMP box ( HT enabled ).
>>
>> Suspend works fine but on resume I have some problems. 
>> All CPU's but boot CPU won't come back , everything else seems fine.
> 
> Can you please try to disable HT and suspend?

So only 'Hibernation' is enabled in kernel and HT disabled in BIOS ?

If you mean that , sure I can try doing so. 

I also could disable Suspend to RAM completly from BIOS as well if you want.

> 
>> ...
>>
>> Oct 22 15:02:28 lara [   49.618795] Enabling non-boot CPUs ...
>> Oct 22 15:02:28 lara [   49.622211] PM: Adding info for No Bus:msr1
>> Oct 22 15:02:28 lara [   49.622259] PM: Adding info for No Bus:cpu1
>> Oct 22 15:02:28 lara [   49.622302] SMP alternatives: switching to SMP code
>> Oct 22 15:02:28 lara [   49.623536] Booting processor 1/1 eip 3000
>> Oct 22 15:02:28 lara [   54.638093] Not responding.
>> Oct 22 15:02:28 lara [   54.638096] Inquiring remote APIC #1...
>> Oct 22 15:02:28 lara [   54.638099] ... APIC #1 ID: failed
>> Oct 22 15:02:28 lara [   54.638204] ... APIC #1 VERSION: failed
>> Oct 22 15:02:28 lara [   54.638307] ... APIC #1 SPIV: failed
>> Oct 22 15:02:28 lara [   54.638427] skipping cpu1, didn't come online
>> Oct 22 15:02:28 lara [   54.638602] PM: Removing info for No Bus:msr1
>> Oct 22 15:02:28 lara [   54.638643] PM: Removing info for No Bus:cpu1
>> Oct 22 15:02:28 lara [   54.638678] Error taking CPU1 up: -5
>> Oct 22 15:02:28 lara [   54.640908] PM: Adding info for No Bus:msr2
>> Oct 22 15:02:28 lara [   54.640939] PM: Adding info for No Bus:cpu2
>> Oct 22 15:02:28 lara [   54.640976] SMP alternatives: switching to SMP code
>> Oct 22 15:02:28 lara [   54.641961] Booting processor 2/2 eip 3000
>> Oct 22 15:02:28 lara [   59.656795] Not responding.
>> Oct 22 15:02:28 lara [   59.656799] Inquiring remote APIC #2...
>> Oct 22 15:02:28 lara [   59.656803] ... APIC #2 ID: failed
>> Oct 22 15:02:28 lara [   59.656907] ... APIC #2 VERSION: failed
>> Oct 22 15:02:28 lara [   59.657011] ... APIC #2 SPIV: failed
>> Oct 22 15:02:28 lara [   59.657131] skipping cpu2, didn't come online
>> Oct 22 15:02:28 lara [   59.657300] PM: Removing info for No Bus:msr2
>> Oct 22 15:02:28 lara [   59.657343] PM: Removing info for No Bus:cpu2
>> Oct 22 15:02:28 lara [   59.657379] Error taking CPU2 up: -5
>> Oct 22 15:02:28 lara [   59.659605] PM: Adding info for No Bus:msr3
>> Oct 22 15:02:28 lara [   59.659637] PM: Adding info for No Bus:cpu3
>> Oct 22 15:02:28 lara [   59.659673] SMP alternatives: switching to SMP code
>> Oct 22 15:02:28 lara [   59.660725] Booting processor 3/3 eip 3000
>> Oct 22 15:02:28 lara [   64.675517] Not responding.
>> Oct 22 15:02:28 lara [   64.675520] Inquiring remote APIC #3...
>> Oct 22 15:02:28 lara [   64.675524] ... APIC #3 ID: failed
>> Oct 22 15:02:28 lara [   64.675628] ... APIC #3 VERSION: failed
>> Oct 22 15:02:28 lara [   64.675731] ... APIC #3 SPIV: failed
>> Oct 22 15:02:28 lara [   64.675859] skipping cpu3, didn't come online
>> Oct 22 15:02:28 lara [   64.676017] PM: Removing info for No Bus:msr3
>> Oct 22 15:02:28 lara [   64.676059] PM: Removing info for No Bus:cpu3
>> Oct 22 15:02:28 lara [   64.676092] Error taking CPU3 up: -5
>> Oct 22 15:02:28 lara [   64.676326] evxfevnt-0079 [00] enable                : System is already in ACPI mode
>>
>> ...
>>
>> After I've played with a lot boot options I found out booting with ' acpi=ht ' will make the CPU's work again but now
>> I have a problem on Suspend. Everything seems to just go down disks etc but the box itself is for some reason still on.
>> So I've tested reboot=<> options with no luck.
>> ( after waiting 5 minutes to be sure everything is really off I can just hit power button). On resume now everything is fine.
>>
>> I'm not really sure what is wrong here acpi/hibernation/cpu-hotplug or a mix of all so I'm CC'ing linux-acpi as well.
>> The only thing I noticed is the 'Breaking affinity for irq XX' on suspend without acpi=ht messages.
>>
>> I can't even tell whatever other kernel versions are working because aic7xxx driver didn't got suspend support till now 
>> ( or at least never worked here ). I know suspend worked fine on windows with that box.
>>
>> There is my config and dmesg ( good and bad one ) :
>>
>>
>> http://194.231.229.228/suspend/acpi=ht_working_dmesg.txt
>> http://194.231.229.228/suspend/dmesg_broken_cpus_on_resume.txt
>> http://194.231.229.228/suspend/config
> 
> Well, I think we have a problem with the CPU hotplug.
> 
> Can you try to offline-online CPUs (without suspending) and see if that works?

Yes does work when I do it manually :

[ 6687.595842] CPU 1 is now offline
[ 6687.711425] CPU 2 is now offline
[ 6687.819330] CPU 3 is now offline
[ 6687.819337] SMP alternatives: switching to UP code
[ 6702.109605] SMP alternatives: switching to SMP code
[ 6702.110634] Booting processor 1/1 eip 3000
[ 6702.122140] Initializing CPU#1
[ 6702.182045] Calibrating delay using timer specific routine.. 3989.26 BogoMIPS (lpj=1994633)
[ 6702.182063] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
[ 6702.182085] CPU: Trace cache: 12K uops, L1 D cache: 8K
[ 6702.182091] CPU: L2 cache: 512K
[ 6702.182096] CPU: Physical Processor ID: 0
[ 6702.182102] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
[ 6702.182118] Intel machine check architecture supported.
[ 6702.182130] Intel machine check reporting enabled on CPU#1.
[ 6702.182137] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[ 6702.182143] CPU1: Thermal monitoring enabled
[ 6702.183563] CPU1: Intel(R) Xeon(TM) CPU 2.00GHz stepping 07
[ 6702.184488] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[ 6702.205500] Switched to high resolution mode on CPU 1
[ 6702.210400] SMP alternatives: switching to SMP code
[ 6702.212196] Booting processor 2/2 eip 3000
[ 6702.222693] Initializing CPU#2
[ 6702.282950] Calibrating delay using timer specific routine.. 3988.88 BogoMIPS (lpj=1994443)
[ 6702.282962] CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 6702.282974] CPU: Trace cache: 12K uops, L1 D cache: 8K
[ 6702.282977] CPU: L2 cache: 512K
[ 6702.282980] CPU: Physical Processor ID: 3
[ 6702.282983] CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080 00000000 00000000 00000000 00000000
[ 6702.282991] Intel machine check architecture supported.
[ 6702.282998] Intel machine check reporting enabled on CPU#2.
[ 6702.283001] CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
[ 6702.283005] CPU2: Thermal monitoring enabled
[ 6702.283300] CPU2: Intel(R) XEON(TM) CPU 2.00GHz stepping 04
[ 6702.284296] checking TSC synchronization [CPU#1 -> CPU#2]: passed.
[ 6702.305317] Switched to high resolution mode on CPU 2
[ 6702.312356] SMP alternatives: switching to SMP code
[ 6702.313995] Booting processor 3/3 eip 3000
[ 6702.324511] Initializing CPU#3
[ 6702.384864] Calibrating delay using timer specific routine.. 3988.87 BogoMIPS (lpj=1994438)
[ 6702.384875] CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 6702.384888] CPU: Trace cache: 12K uops, L1 D cache: 8K
[ 6702.384891] CPU: L2 cache: 512K
[ 6702.384894] CPU: Physical Processor ID: 3
[ 6702.384897] CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080 00000000 00000000 00000000 00000000
[ 6702.384905] Intel machine check architecture supported.
[ 6702.384912] Intel machine check reporting enabled on CPU#3.
[ 6702.384915] CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
[ 6702.384919] CPU3: Thermal monitoring enabled
[ 6702.385146] CPU3: Intel(R) XEON(TM) CPU 2.00GHz stepping 04
[ 6702.386252] checking TSC synchronization [CPU#1 -> CPU#3]: passed.
[ 6702.407259] Switched to high resolution mode on CPU 3

...

done with :
for i in cpu1 cpu2 cpu3; do echo 0 >/sys/devices/system/cpu/$i/online; done

for i in cpu1 cpu2 cpu3; do echo 1 >/sys/devices/system/cpu/$i/online; done

> 
> Greetings,
> Rafael
> 


Gabriel
