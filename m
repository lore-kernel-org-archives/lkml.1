Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYDTJlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYDTJlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 05:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYDTJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 05:41:46 -0400
Received: from rocks.dynaweb.hu ([195.70.37.87]:49313 "EHLO rocks.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYDTJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 05:41:45 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 05:41:45 EDT
Date: Sun, 20 Apr 2008 11:33:09 +0200
From: Rumi Szabolcs <rumi_ml@rtfm.hu>
To: linux-kernel@vger.kernel.org
Subject: dying hdd causing MCE and panic (libata)
Message-Id: <20080420113309.2343eb63.rumi_ml@rtfm.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all!

A SATA drive in one of my servers has made some final steps towards
the grave and it has put out some obvious signs of this onto the
console (ATA transactions failing) but then it has also thrown an
MCE (CPU context corrupt) and then the kernel has panicked.
This server is rock stable otherwise and used to make uptimes
measured in months between planned restarts.

The machine has been removed from power completely and restarted
multiple times but during the boot process it always crashed with
an MCE or a panic or both.

Sorry but I cannot provide exact debug information right now because
I wasn't physically there at the time and I'm still 250kms away from
that server. In fact I've remotely guided two people without a clue
through the phone and they have read things from the console for me,
restarted the machine, etc.

So in the end I told them to open up the server and pull the SATA
cable from that particular drive. Suddenly all the MCEs and panics
had gone away and the machine is running fine since then.

Hardware:

- Nforce4 based motherboard (chipset integrated SATA ports)
- Athlon64 single core CPU
- Diamondmax 9 SATA hard drive

Kernel:

2.6.23-gentoo-r3 (no preempt, no smp)

My questions:

- Is it normal that a simple hard disk failure (that is not even
the system disk) causes MCEs and kernel panics?

- Is this a problem that is induced completely on the hardware
level (eg. the southbridge going crazy and making the whole
hardware platform unstable) or a problem that could be fixed
or handled properly on the software (kernel) level?

Thanks!

Best regards,
Sab
