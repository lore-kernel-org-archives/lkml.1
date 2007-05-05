Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbXEESEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbXEESEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbXEESEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:04:48 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:35320 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934211AbXEESEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:04:46 -0400
Message-ID: <463CC735.9080709@interia.pl>
Date: Sat, 05 May 2007 20:04:37 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Johnson <dj@david-web.co.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Wander Winkelhorst <w.winkelhorst@gmail.com>
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> <200705042320.41278.dj@david-web.co.uk> <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr> <463C18C4.7030304@interia.pl> <Pine.LNX.4.61.0705051114130.18504@yvahk01.tjqt.qr> <463C9070.7020007@interia.pl> <Pine.LNX.4.61.0705051932210.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705051932210.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: af036acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I just wonder why x86info says I have a C5XL while `modprobe longhaul`
> says it is a C5P.
I have changed names to names which VIA is using. 
> 
> cn:/dev/shm # ./x86info -v -v
You need to be root and use -a option. I'm interested in:
FCR: MSR: 0x00001107=0x9e3f1ad6 : 10011110 00111111 00011010 11010110
Power management: Powersaver
MSR: 0x0000110a=0x07ff000d000280f0 : 00000111 11111111 00000000 00001101
           00000000 00000010 10000000 11110000

 RevisionID: 0 : Initial revision (Software clock multiplier only, no SoftVID)
 Software clock multiplier is disabled
Please send me below part of Your dmesg too:
CPU: After generic identify, caps: 0381b83f 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 64K (32 bytes/line)
CPU: After all inits, caps: 0381b93f 00000000 00000000 00000000 00000000 000000dd 00000000
> 
> And the BIOS announces it as a "Via Eden ESP 6000" (as does the manufacturer).
Great. I think that I saw datasheet somewhere.
> Jan
Rafa³



----------------------------------------------------------------------
Wicie, rozumicie....
Zobacz >>> http://link.interia.pl/f1a74

