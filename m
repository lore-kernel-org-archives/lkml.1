Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZEQDJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZEQDJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 23:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZEQDIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 23:08:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35672 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZEQDIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 23:08:53 -0400
Message-ID: <4A0F7FC2.5090109@garzik.org>
Date: Sat, 16 May 2009 23:08:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H
 (bisected)
References: <20090516225153.GA7883@arbonne.lan>
In-Reply-To: <20090516225153.GA7883@arbonne.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Atterer wrote:
> Hello,
> 
> I have had problems using s2disk starting sometime before 2.6.29 (and 
> continuing up until now, 2.6.30-rc6), but only got around to bisecting the 
> issue now.
> 
> The symptom is as follows: When I start s2disk (by running the hibernate 
> command), the system switches to the console and prints "s2disk: 
> Snapshotting system". The cursor freezes for a moment, I hear the noise 
> that my DVD writer makes when it is reset, the lights of my USB hub go off 
> and on again. Then the cursor continues to blink and nothing more happens, 
> the system just hangs.
> 
> I have a Gigabyte EG45M-DS2H motherboard with two disks attached: One SATA 
> disk containing Linux, and one older PATA disk with data. AHCI is enabled 
> in the BIOS.
> 
> The patch that causes the hang is 295f00042aaf6b553b5f37348f89bab463d4a469:
> ide: don't execute the next queued command from the hard-IRQ context (v2)
> 
> Any help with this problem would be very much appreciated!

Does it work if you disable CONFIG_IDE, and use only CONFIG_ATA for PATA?

	Jeff




