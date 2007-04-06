Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXDFXRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXDFXRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXDFXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:17:36 -0400
Received: from outmx006.isp.belgacom.be ([195.238.4.99]:53872 "EHLO
	outmx006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXDFXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:17:35 -0400
Subject: Re: 2.6.9 won't compile
From: Pedro Mullor =?ISO-8859-1?Q?Jim=E9nez?= <pmullor@skynet.be>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1175855823.16114.12.camel@localhost>
References: <1175855823.16114.12.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Sat, 07 Apr 2007 01:17:19 +0200
Message-Id: <1175901439.5312.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [Benoit Boissinot]
> I don't think 2.6.9 was gcc-4.x compatible, what version
> of gcc are you using ?

> [Robert Hancock]
> Your compiler is probably too new to be able to compile 2.6.9. You'd 
> likely be better off trying the latest kernels and making a detailed 
> report of the problems you're having with it..

> [Adrian Bunk]
> Can you give a pointer or description of this problem?
> 
> The preferred solution for you would not be to run an ancient kernel 
> with tons of known security holes but to get this problem fixed.

Dear Benoît, Robert and Adrian, dear all,

first of all, thanks for your time and answers.

I'm on Ubuntu 6.06 LTS. The gcc version used is 4.0.3.
As you pointed out, this may well be the reason why the compilation
fails. I'm sorry, but it's been a couple of years since I compiled my
last kernel so I might be not as used to as in the time :o)

As in regards to the problem I'm having, I recall having read an article
on which someone gave his oppinion about why the latest crop of kernels
with the new stable/unstable/patch organization were so ABC while the
previous system was so XYZ.
One of the issues argumented was one about old systems with Via chipsets
(among them the VT82CXXX) that worked fine on 2.6.9 but that were fine
no more since 2.6.10 (performance degradation issue after heavy/
sustained IO loads).
I am truly sorry of not being able to find the exact article again on
google, but then I might have read it on slashdot or on another site.


*The/My Issue* is that, after a sustained load of hard-drive IO
operations, the machine I have gets "clogged".
The symptoms are :

- when doing FTP (my machine being the server) I begin at 1.4 MB/s. This
speed gradually decrements, and after 10 mins I'm doing 500 or 400 KB/s
(I'm aware that the actual speed of a FTP transfer should be the mean
speed during the transmission of a 10 MB file, but this falls a bit
farther IMHO).

- when I leave Azureus (Bittorrent client) running for 10+ mins, *and I
have not been using my pc in the meantime* (no mouse, no keyboard
usage), the (usb) mouse is "lagged", "dizzy", dragging, the pointer
reacts slowly to the movement of the mouse.

- the same happens after I've been doing an FTP transfer for 10 mins+

- also when on Azureus, the sound system plays several, usually one-off
(like Gaim "online" sounds), sounds endlessly (or repeats the playback
for a min of 3-5 times)

When this happens, I have tried to go on console mode, stop all possible
jobs & services, but I end with only the really minimal services + the
kernel processes and the system still behaves the same (I tried
reproducing a mp3 file on the console and the sound system is still not
behaving correctly (I try to stop the program with Ctrl-C but it won't
respond and then I have to kill it).

I am sorry I'm not used to issues like this one so I'm not sure where
else to look. I wanted to try 2.6.9 to see if the system behaved
better/correctly, because I only have had this issue with the two last
Linux flavours I installed (SUSE 10 and Ubuntu 6.06), when on Debian
(the version before 3.0) it was fine.
Then again, this is not really the scientific method of isolating the
variables in the equation and the machine is now 5 years old, so I
wonder if there is not something else that I could have overlooked, but
so far this is the only issue I've got and, while being a veteran of
several Debian Potato + X11 installations, I'm frankly out of
options/ideas here ;o)
At the same time, it still gets the job done beautifully so I don't
really have a reason to change it.

If you've read this until here, I really thank you for your time. Any
ideas will be greately appreciated. If I can help with anything, please
let me know. If it's to no use, then I think I'll still survive :o)

Have a nice weekend!
Pedro Mullor

P.S. Please find the specs of my machine :
2x Intel PIII 933, 512 RAM
Asus Cuv4x-d (Via VT82CXXX, AGP : VIA Apollo Pro 133)
Creative Labs SB Audigy (rev 03)
USB logitech Optical Mouse
Logitech PS2 Keyboard
hda: ST340824A, ATA DISK drive
hdb: QUANTUM FIREBALLlct10 10, ATA DISK drive
hdc: LITE-ON DVDRW SHW-1635S, ATAPI CD/DVD-ROM drive
hdd: LG DVD-ROM DRD-8160B, ATAPI CD/DVD-ROM drive
eth0: RealTek RTL8139
GeForce2 MX/MX 400] (rev b2)


