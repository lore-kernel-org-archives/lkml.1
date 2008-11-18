Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYKRJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYKRJhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYKRJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:37:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:62924 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYKRJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xIUAtQAyyl25F/hJM9/l+CZTYL38Z8wsioNlOU3Ei/a6NFNyh3a910/c1m2GoSpa6n
         nuzqoL8e61o1o4Pla5oX1Ecz5DxZvGxxTv97JdmW83gTJU7TIJWmydTGAuEGXKfMqtpf
         jNzH6mdchgrywCYM+PpvQuFpRQ4MhdaYVmCEY=
Subject: [   11.333737]    is this a ghost?
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 01:37:18 -0800
Message-Id: <1227001038.3184.6.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in dmesg I see:
[   11.333737]  
but nothing else.
          ---------------(cut)-----------------
[   11.247147] Monitor-Mwait will be used to enter C-1 state
[   11.247151] Monitor-Mwait will be used to enter C-2 state
[   11.247154] Monitor-Mwait will be used to enter C-3 state
[   11.247671] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   11.247996] processor ACPI_CPU:00: registered as cooling_device0
[   11.248008] ACPI: Processor [CPU0] (supports 8 throttling states)
[   11.306465] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)<7>power_supply ADP1: No power supply yet
[   11.306831] power_supply ADP1: power_supply_changed
[   11.306839] ACPI: AC Adapter [ADP1] (on-line)
[   11.333737]                         <------------what's with this!!!
[   11.342937] power_supply ADP1: power_supply_changed_work
[   11.351901] power_supply ADP1: power_supply_update_gen_leds 1
[   11.351916] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[   11.357477] Marking TSC unstable due to TSC halts in idle
[   11.382273] power_supply ADP1: uevent
[   11.392955] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   11.403674] power_supply ADP1: Static prop TYPE=Mains
[   11.413736] power_supply ADP1: 1 dynamic props
[   11.424526] power_supply ADP1: prop ONLINE=1
[   11.437151] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])

if you need to see the full dmesg I can attach..
I've seen this happen on a random.

regards;


-- 
Justin P. Mattock <justinmattock@gmail.com>

