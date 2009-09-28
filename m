Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZI1P0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZI1P0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZI1P0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:26:23 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56567 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZI1P0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:26:23 -0400
Message-ID: <4AC0D59F.8000502@msgid.tls.msk.ru>
Date: Mon, 28 Sep 2009 19:26:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31: booting on a PIII Celeron?
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I've a problem here with 2.6.31.  kernel is
compiled for PIII:

  CONFIG_MPENTIUMIII=y
  CONFIG_X86_GENERIC=y

This kernel works on real PIII machine - like this:

vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 10
cpu MHz		: 997.580

But it fails on a Celeron:

vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Celeron (Coppermine)
stepping	: 6
cpu MHz		: 797.481

it fails on early boot, after a bootloader printed
"Loading kernel... initrd..." -- after that, on the
Celeron machine, it reboots instantly.

It's the same kernel binary, I tried it on several
machines, and the result is pretty consistent - if
it's a PIII-Celeron it reboots, if it's a PIII -
kernel boots and works ok.

All previous kernels with the same config worked on
these machines, at least as far as this issue is
concerned.

Is it a known issue?  Is there anything else I can
try to debug it?

Thanks!

/mjt
