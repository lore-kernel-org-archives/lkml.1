Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYJ1XTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYJ1XTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYJ1XTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:19:41 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12278 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYJ1XTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:19:40 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=WTOa2hn3inJh-SO4IyYA:9 a=9BgfCkS8-6OSSSbJ1rMxJ8tWvH0A:4 a=D5YFuimtoV8A:10 a=k-0ameDuTccA:10
Message-ID: <49079E09.20703@shaw.ca>
Date: Tue, 28 Oct 2008 17:19:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Oskar Liljeblad <oskar@osk.mine.nu>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>
In-Reply-To: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oskar Liljeblad wrote:
> Can anyone make any sense of these SATA errors? They're killing my md RAID5
> (at least the second error did).
> 
> Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
> Motherboard: Asus M3A78-EH with AMD 780G/SB700 chipset
> SATA driver: ahci
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
> 
> Smart reports no errors on the drives, short & long tests have been run as
> well. The system is brand new.
> 
> I've read some reports about SATA 3.0 Gbps vs 1.5 Gbps problems and I'm
> considering limiting the drives to 1.5 Gbps using jumpers. Would that be a
> good idea?
> 
> 19:24:26 ata2: exception Emask 0x50 SAct 0x0 SErr 0x90a02 action 0xe frozen
> 19:24:26 ata2: irq_stat 0x00400000, PHY RDY changed
> 19:24:26 ata2: SError: { RecovComm Persist HostInt PHYRdyChg 10B8B }

RecovComm: Communications between device and host temporarily lost, but 
regained
Persist: Persistent communication or data integrity error
HostInt: Host bus adapter internal error
PHYRdyChg: PhyRdy signal changed state
10B8B: 10b to 8b decoding error occurred

Sounds like the drive and the controller are unhappy with each other, or 
there's some kind of communications or hardware problem. Not likely a 
kernel issue.

It's unclear if limiting to 1.5 Gbps would help, you could try it and see..
