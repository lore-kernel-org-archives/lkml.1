Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXFDQnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXFDQnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXFDQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:43:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbXFDQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:43:15 -0400
From: Olaf Dietsche <olaf.dietsche@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl>
	<87wsykpweu.fsf@goat.bogus.local> <200706041013.49428.rjw@sisk.pl>
Date: Mon, 04 Jun 2007 18:43:55 +0200
Message-ID: <87hcpnpt4k.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18dfs1JFxjY6cbBif/vNQQv4lyvRBIOblGCi/Z
 lsfsJlNy43Jmcv+rLRk0dDfoJSZDrFg6RaMfBKUu9nMDbQOfVa
 N+PpbCMH8T1Y4x3OerfXA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Sunday, 3 June 2007 23:20, Olaf Dietsche wrote:
>
>> But either way the script never reaches "shutdown -rn now". So, it
>> seems, that my laptop does a full resume every other reboot, but it
>> never returns to userspace.
>
> I'm still suspecting that the problem is related to your graphics adapter.

Maybe it's the most common problem, but why do you think so? Even with
a black screen the kernel should return to userspace.

> What graphics adapter do you have in the box?

0000:01:00.0 VGA compatible controller: nVidia Corporation: Unknown device 0148 (rev a2) (prog-if 00 [VGA])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c4000000 (32-bit, non-prefetchable) [size=64M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=128M]
	Region 3: Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
	Expansion ROM at c2000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] #10 [0001]

Regards, Olaf.
