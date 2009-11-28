Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbZK1Vrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbZK1Vrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 16:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZK1Vrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 16:47:55 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:51360 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZK1Vry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 16:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OlqG6iaqTCviS00rE8ZMrrlh4Q4h+5eHu8BR963E3ouMdIewY265jguPDLyNblOk+i
         FQ14/541mNjNL6s+IdMtEkAA1RKfsYtobTF9LCIS3iPwO8a/vzsaBvlo3UIjjIgQfsXx
         Q1NSVOKIvx2huY15Y5eCoy2QznmTSrj40RApw=
Message-ID: <4B119D95.6090806@gmail.com>
Date: Sat, 28 Nov 2009 20:00:53 -0200
From: Bruno Barberi Gnecco <brunobg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: brunobg@gmail.com
Subject: PROBLEM: BUG: Constant freezes and kernel panics on a quad core (with
 dumps)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: a PC I'm testing is unstable and freezing often. Freezes occur in various 
situations, including under no load (not even the X running). Dumps are provided below.

Sometimes it's a plain freeze, sometimes a kernel panic with the blinking leds and a dump. 
It seems the problem is related to memory, most of the messages are related to null memory 
references (see more below). System ran once for several hours before freezing.

* System specification: Intel Core 2 Quad Q9550 @ 2.83GHz, 4GB DDR3, Motherboard Asus 
P5QC. No overclocking.

* Tested under the following kernels/distros, all had the bug. Since I used their vanilla 
kernels, I'm not posting a copy of the .configs:

- 2.6.27.7-smp (slackware 12.2 hugesmp kernel; distro heavily updated), 32 bits
- 2.6.29.6-smp (slackware 13.0 hugesmp kernel; fresh install), both 32 and 64 bits
- 2.6.29.6-nosmp (slackware 13.0 huge kernel; fresh install), both 32 and 64 bits
- 2.6.31-14-generic SMP (ubuntu 9.10 netbook remix live cd), 32 bits

* Here are some screen dumps (sorry, no serial cable for a text dump).

http://ultraxs.com/share-208E_4B118ED2.html
http://ultraxs.com/share-2FDD_4B118ED2.html
http://ultraxs.com/share-D0D9_4B118ED2.html
http://ultraxs.com/share-498F_4B118ED2.html
http://ultraxs.com/share-0AD8_4B118ED2.html

* Turning off ACPI and APIC, either through the BIOS or through kernel parameters did not 
help, even when only one processor is recognized.

* I ran memtest and no errors were detected. I completed the tests three times.

* Nothing is ever output to the logs.

* A sure way to get a freeze is to recompile the kernel, but the freeze does not happen at 
the same point of the compilation and I can't even say if the compilation triggers the bug 
or if it's just a coincidence and the compilation just takes long enough for it to happen.

* Any other information, testing or debugging you need, just ask. I just can't use the PC, 
it usually freezes within minutes. Please CC any replies to me [brunobg at gmail]. Thank 
you very much for any help.
