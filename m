Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbXJVQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbXJVQPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXJVQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:15:43 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:33586 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXJVQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Tg9P7DJUVIUB9mY+Y2JfBSqVoUfsaZ6k1FCkuFu/Z74QbUuLBmfII109jTx4+lgAP1ANBFPHaKxnYHI+T7aTKrxEyuzvq9ZXwjvk4omL3heXz1lWGBWzUvm1nzinalahuctKVi6+J63JuKI3Kvp/iTH6iOwpFcxABYo5z31ub7s=
Message-ID: <471CCC98.10101@googlemail.com>
Date: Mon, 22 Oct 2007 18:15:20 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Resume problems
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all ,

I'm running current git + aic7xxx suspend patch from  http://bugzilla.kernel.org/show_bug.cgi?id=3062
on a Dell Precision WorkStation 530 MT SMP box ( HT enabled ).

Suspend works fine but on resume I have some problems. 
All CPU's but boot CPU won't come back , everything else seems fine.

...

Oct 22 15:02:28 lara [   49.618795] Enabling non-boot CPUs ...
Oct 22 15:02:28 lara [   49.622211] PM: Adding info for No Bus:msr1
Oct 22 15:02:28 lara [   49.622259] PM: Adding info for No Bus:cpu1
Oct 22 15:02:28 lara [   49.622302] SMP alternatives: switching to SMP code
Oct 22 15:02:28 lara [   49.623536] Booting processor 1/1 eip 3000
Oct 22 15:02:28 lara [   54.638093] Not responding.
Oct 22 15:02:28 lara [   54.638096] Inquiring remote APIC #1...
Oct 22 15:02:28 lara [   54.638099] ... APIC #1 ID: failed
Oct 22 15:02:28 lara [   54.638204] ... APIC #1 VERSION: failed
Oct 22 15:02:28 lara [   54.638307] ... APIC #1 SPIV: failed
Oct 22 15:02:28 lara [   54.638427] skipping cpu1, didn't come online
Oct 22 15:02:28 lara [   54.638602] PM: Removing info for No Bus:msr1
Oct 22 15:02:28 lara [   54.638643] PM: Removing info for No Bus:cpu1
Oct 22 15:02:28 lara [   54.638678] Error taking CPU1 up: -5
Oct 22 15:02:28 lara [   54.640908] PM: Adding info for No Bus:msr2
Oct 22 15:02:28 lara [   54.640939] PM: Adding info for No Bus:cpu2
Oct 22 15:02:28 lara [   54.640976] SMP alternatives: switching to SMP code
Oct 22 15:02:28 lara [   54.641961] Booting processor 2/2 eip 3000
Oct 22 15:02:28 lara [   59.656795] Not responding.
Oct 22 15:02:28 lara [   59.656799] Inquiring remote APIC #2...
Oct 22 15:02:28 lara [   59.656803] ... APIC #2 ID: failed
Oct 22 15:02:28 lara [   59.656907] ... APIC #2 VERSION: failed
Oct 22 15:02:28 lara [   59.657011] ... APIC #2 SPIV: failed
Oct 22 15:02:28 lara [   59.657131] skipping cpu2, didn't come online
Oct 22 15:02:28 lara [   59.657300] PM: Removing info for No Bus:msr2
Oct 22 15:02:28 lara [   59.657343] PM: Removing info for No Bus:cpu2
Oct 22 15:02:28 lara [   59.657379] Error taking CPU2 up: -5
Oct 22 15:02:28 lara [   59.659605] PM: Adding info for No Bus:msr3
Oct 22 15:02:28 lara [   59.659637] PM: Adding info for No Bus:cpu3
Oct 22 15:02:28 lara [   59.659673] SMP alternatives: switching to SMP code
Oct 22 15:02:28 lara [   59.660725] Booting processor 3/3 eip 3000
Oct 22 15:02:28 lara [   64.675517] Not responding.
Oct 22 15:02:28 lara [   64.675520] Inquiring remote APIC #3...
Oct 22 15:02:28 lara [   64.675524] ... APIC #3 ID: failed
Oct 22 15:02:28 lara [   64.675628] ... APIC #3 VERSION: failed
Oct 22 15:02:28 lara [   64.675731] ... APIC #3 SPIV: failed
Oct 22 15:02:28 lara [   64.675859] skipping cpu3, didn't come online
Oct 22 15:02:28 lara [   64.676017] PM: Removing info for No Bus:msr3
Oct 22 15:02:28 lara [   64.676059] PM: Removing info for No Bus:cpu3
Oct 22 15:02:28 lara [   64.676092] Error taking CPU3 up: -5
Oct 22 15:02:28 lara [   64.676326] evxfevnt-0079 [00] enable                : System is already in ACPI mode

...

After I've played with a lot boot options I found out booting with ' acpi=ht ' will make the CPU's work again but now
I have a problem on Suspend. Everything seems to just go down disks etc but the box itself is for some reason still on.
So I've tested reboot=<> options with no luck.
( after waiting 5 minutes to be sure everything is really off I can just hit power button). On resume now everything is fine.

I'm not really sure what is wrong here acpi/hibernation/cpu-hotplug or a mix of all so I'm CC'ing linux-acpi as well.
The only thing I noticed is the 'Breaking affinity for irq XX' on suspend without acpi=ht messages.

I can't even tell whatever other kernel versions are working because aic7xxx driver didn't got suspend support till now 
( or at least never worked here ). I know suspend worked fine on windows with that box.

There is my config and dmesg ( good and bad one ) :


http://194.231.229.228/suspend/acpi=ht_working_dmesg.txt
http://194.231.229.228/suspend/dmesg_broken_cpus_on_resume.txt
http://194.231.229.228/suspend/config


Regards,

Gabriel

 



