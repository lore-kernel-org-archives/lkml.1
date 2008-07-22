Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYGVHoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYGVHoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYGVHoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:44:01 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:57741 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYGVHoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:44:00 -0400
Date: Tue, 22 Jul 2008 09:43:57 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, linux-usb@vger.kernel.org
Subject: 2.6.22: USB getting stuck on SuperMicro PDSME+ boards
Message-ID: <20080722074357.GC21035@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 876041 records(22-07-2008)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm having problem with USB getting stuck on bunch of machines with PDSME+ boards (I haven't observed
the problem on any other type of board. Controller identifies as
8086:27c8 (rev 01) - Intel Corporation 82801G (ICH7 Family) USB UHCI Controller

Symptoms:
- any process trying to access /proc/bus/usb/devices gets stuck in 'D' state
- khubd seems to be stuck in 'D' state
- USB devices don't work

I'm observing the problem even on machines without any USB devs attached.
Unfortunately I wasn't able to reproduce the problem on my testing machines I have
on my disposal here (yet, but I'm still trying), and it's not affecting all PDSME+ boards we have deployed.
The problem appeared after upgrading machines to 2.6.24 kernels, we haven't observed it on 2.6.21 we used before.
On affected machines, kernel doesn't emit any OOPS, or anything else which could help to track. It just stops working after some time.

Bad thing is that since I'm not able to reproduce the problem here and I cannot reboot/upgrade production machines too
often, I can't provide much more information or try bisection :(
So this is rather desperate attempt to ask if anyone had similar problem or has any tip on where should I look to track it.
Kernels we're using are vanillas with few small unrelated patches applied.
Any help would be greatly appreciated
with best regards
nik


-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
