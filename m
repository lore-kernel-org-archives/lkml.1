Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYCUXSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYCUXSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763815AbYCUXHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:07:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763814AbYCUXHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:07:11 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
Date: Sat, 22 Mar 2008 00:06:48 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <200803201518.32109.hpj@urpla.net> <20080320214830.6d39876d.akpm@linux-foundation.org> <47E3FF30.3090300@gmail.com>
In-Reply-To: <47E3FF30.3090300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803220006.49609.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/MR0Ce4tgOKrBBFWvLCguL+VM94VtiRXB8SeY
 nU2M41w7Qn7IIhzTKAXzPsbdtYKUTRT5zPVaoXMUhmqwIYahfj
 5Fq2sjCveHbrJGexTv2AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. März 2008 schrieb Roger Heflin:
> Andrew Morton wrote:
> > (cc linux-ide)
> > (regression?)
> >
> > On Thu, 20 Mar 2008 15:18:31 +0100 Hans-Peter Jansen <hpj@urpla.net> 
wrote:
> >> Hi,
> >>
> >> since I upgraded to 2.6.24.3 on one of my production systems, I see
> >> regular device resets like these:
>
> Hans,
>
> What kernel were you using before you updated to that kernel?

You don't what to know that ;-) (cough 2.6.11 cough)

> >> Mar 20 14:33:03 lisa5 kernel: ata2.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen Mar 20 14:33:03 lisa5 kernel: ata2.00: cmd
> >> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 Mar 20 14:33:03 lisa5
> >> kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4
> >> (timeout) Mar 20 14:33:03 lisa5 kernel: ata2.00: status: { DRDY }
> >> Mar 20 14:33:03 lisa5 kernel: ata2: hard resetting link
> >> Mar 20 14:33:05 lisa5 kernel: ata2: SATA link up 3.0 Gbps (SStatus 123
> >> SControl 0) Mar 20 14:33:05 lisa5 kernel: ata2.00: configured for
> >> UDMA/100 Mar 20 14:33:05 lisa5 kernel: ata2: EH complete
> >> Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] 488397168 512-byte
> >> hardware sectors (250059 MB) Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0:
> >> [sdc] Write Protect is off Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0:
> >> [sdc] Mode Sense: 00 3a 00 00 Mar 20 14:33:05 lisa5 kernel: sd
> >> 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> >> support DPO or FUA Mar 20 14:36:11 lisa5 kernel: ata3.00: exception
> >> Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen Mar 20 14:36:11 lisa5
> >> kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 Mar 20
> >> 14:36:11 lisa5 kernel:          res
> >> 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Mar 20
> >> 14:36:11 lisa5 kernel: ata3.00: status: { DRDY }
> >> Mar 20 14:36:11 lisa5 kernel: ata3: hard resetting link
> >> Mar 20 14:36:13 lisa5 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123
> >> SControl 0) Mar 20 14:36:13 lisa5 kernel: ata3.00: configured for
> >> UDMA/100 Mar 20 14:36:13 lisa5 kernel: ata3: EH complete
> >> Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte
> >> hardware sectors (250059 MB) Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0:
> >> [sdd] Write Protect is off Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0:
> >> [sdd] Mode Sense: 00 3a 00 00 Mar 20 14:36:13 lisa5 kernel: sd
> >> 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
> >> support DPO or FUA
> >>
> >> Should I be worried? smartd doesn't show anything suspicious on those.
>
> Andrew,
>
> I don't think it is a recent regression, I have seen it happening for a
> while on my machine, I don't think it is causing any crashes but I am
> getting unexplained events about 1x per month that appear to deadlock a
> number of things (machine is up, but top won't run and vmstat actually
> gets a FP exception on the second sample, and a number of other things
> have issues until reboot).

Well, that doesn't sound reassuring, does it?

> I have 4 identical disks, 2 on a sata_sil and 2 on another controller,
> the ones on the sil controller have this behavior, I have seen it in
> 2.6.23.1, FC7-2.6.23.15-80 and FC7-2.6.22.9-91.   My sil is a 4-port 3114
> PCI card, and my disks are 500GB Western Digital disks.  I have a fairly
> long run with 20-30 events on the 2 disks on the sata_sil and no events
> on the identical non-sil disks that had previously been getting resets
> (when on the sil controller), and since they are under software raid5 all
> 4 disks should have very very similar IO loads.

Okay, those resets may happen without further consequences, but they're 
disturbing nevertheless. 

BTW, I'm preparing a hardware reorg, which will eliminate this controller 
during this weekend.. Well, to be correct, the other is the one, that 
really nags me for some time now (3ware 9xxx-8). Swapping both with one 
Areca 1130, which performes _much_ better.

Pete
