Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837Ab0A0Rx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0A0Rx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812Ab0A0Rx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:53:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:59829 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755549Ab0A0Rx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:53:26 -0500
X-Authenticated: #18024098
X-Provags-ID: V01U2FsdGVkX1/QIh0RcULQGrW5VI52cEzpnGHXTCscF+uSGvLWZQ
	ODw3kEK7owyxhI
Message-Id: <7.0.1.0.2.20100127184859.01d47850@chello.at>
X-Mailer: QUALCOMM Windows Eudora Version 7.0.1.0
Date: Wed, 27 Jan 2010 18:51:52 +0100
To: linux-kernel@vger.kernel.org
From: Alexander Oberhuber <lzw77rnc@gmx.at>
Subject: multiple bugs in 2.6.32.4-ZEN5 : EIP@SpinLock+10 / SATA
  Exception Frozen / no MTRR 
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I played for a while with Slax-Remix, and it spurts out quite 
many errors at me, all centered around bugs that appear to be kernel 
bugs. But first:

a) My Hardware: Motherboard: MSI-Neo3-FR "7514" ; Intel CPU Quadcore 
Q6600, 4 GB RAM. Graphiccard: ATI Radeon 4850.
Various SATA HD drives connected to the mainboard. Slax-Remix 3 
booted from a (slow!) "Maxell 8GB" USB-stick.

Used Kernel : 2.6.32.4-ZEN5 as in the Distribution "Slax-Remix v0.3" 
( http://www.slax.org/forum.php?action=view&parentID=55706 )

Now, to the
b) Bugs:

1.) When I boot into graphics mode, it sometimes happens that the KDE 
splash screen appears, "Starting up KDE", then the icons on the 
splash screen start blinking, and the third icon, the "heart" icon 
KEEPS blinking and nothing continues.
Curious, I booted into text mode, ran "xconfig", then I used 
"startx". Same bug again. So I forcedly switched into text mode using 
CTRL-F1 and checked the text screen for errors. There was a syslogd 
error appearing in the textscreen. I'm too lazy to write it down, but 
I made a screenshot:

http://666kb.com/i/bg6wrh1c9lusg2bhd.jpg : "Message from Syslog.... 
-> EIP @ SpinLock + 0x10 ...

2.) A few minutes, while I was trying to fetch my cam and make a foto 
of the bug, another bug spurted at me, the kernel didn't like 
whatever was supposed to be on SATA9 :

http://666kb.com/i/bg6wu3xlexssqg4v5.jpg : "ATA9 : ...Exception 
EMASK...Frozen..." and several other errors.

A "Failed to identify" message appeared a couple of times, just 
below: http://666kb.com/i/bg6wvzfds8sk8sckh.jpg

3.) When I tried to reboot my poor machine (which was left alone for 
a couple of hours in the meantime, while I was away) I noticed that 
SLAX-remix didn't want to remove the loop-devices that were linked to 
the modules:
http://666kb.com/i/bg6wxky1e3d030gip.jpg : "Transport endpoint [of 
the loop] is not connected". How comes? I didn't deactivate 
anything...I only went shopping! :-)

4.) I also got a "no MTRR" message in the reboot screen :
http://666kb.com/i/bg6wzeks8vxhsyd29.jpg

Yours
A.O.

