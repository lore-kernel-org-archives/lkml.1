Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbXCQR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbXCQR7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXCQR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:59:30 -0400
Received: from tag.witbe.net ([81.88.96.48]:47978 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXCQR72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:59:28 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sat, 17 Mar 2007 18:59:12 +0100
Organization: AS2917.net
Message-ID: <00a701c768bd$f8abe130$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45F509A7.8030705@gmail.com>
Thread-Index: AcdkfTg0gI7MjfBwT5qElaqy4yykVQEQHw9Q
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm preparing to attach a disk. 
In the meantime, I've rebuild a 2.6.21-rc4, and got that while booting :
...
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
...
Adding 2096436k swap on /dev/sde5.  Priority:-1 extents:1 across:2096436k
Adding 4192956k swap on /dev/sda3.  Priority:-2 extents:1 across:4192956k
ata1.00: exception Emask 0x2 SAct 0x7fffffc3 SErr 0x0 action 0x2 frozen
ata1.00: (spurious completions during NCQ issue=0x0 SAct=0x7fffffc3
FIS=004040a1:00000020)
ata1.00: cmd 60/01:00:52:eb:ff/00:00:09:00:00/40 tag 0 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/40:08:53:eb:ff/00:00:09:00:00/40 tag 1 cdb 0x0 data 32768 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:30:39:eb:ff/00:00:09:00:00/40 tag 6 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:38:3a:eb:ff/00:00:09:00:00/40 tag 7 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:40:3b:eb:ff/00:00:09:00:00/40 tag 8 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:48:3c:eb:ff/00:00:09:00:00/40 tag 9 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:50:3d:eb:ff/00:00:09:00:00/40 tag 10 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:58:3e:eb:ff/00:00:09:00:00/40 tag 11 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:60:3f:eb:ff/00:00:09:00:00/40 tag 12 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:68:40:eb:ff/00:00:09:00:00/40 tag 13 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:70:41:eb:ff/00:00:09:00:00/40 tag 14 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:78:42:eb:ff/00:00:09:00:00/40 tag 15 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:80:43:eb:ff/00:00:09:00:00/40 tag 16 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:88:44:eb:ff/00:00:09:00:00/40 tag 17 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:90:45:eb:ff/00:00:09:00:00/40 tag 18 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:98:46:eb:ff/00:00:09:00:00/40 tag 19 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:a0:47:eb:ff/00:00:09:00:00/40 tag 20 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:a8:48:eb:ff/00:00:09:00:00/40 tag 21 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:b0:49:eb:ff/00:00:09:00:00/40 tag 22 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:b8:4a:eb:ff/00:00:09:00:00/40 tag 23 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:c0:4b:eb:ff/00:00:09:00:00/40 tag 24 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:c8:4c:eb:ff/00:00:09:00:00/40 tag 25 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:d0:4d:eb:ff/00:00:09:00:00/40 tag 26 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:d8:4e:eb:ff/00:00:09:00:00/40 tag 27 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:e0:4f:eb:ff/00:00:09:00:00/40 tag 28 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:e8:50:eb:ff/00:00:09:00:00/40 tag 29 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/01:f0:51:eb:ff/00:00:09:00:00/40 tag 30 cdb 0x0 data 512 in
         res 40/00:08:53:eb:ff/00:00:09:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port

Kernel is a stock 2.6.21-rc4 I've just downloaded... I seem to remember
this could be NCQ-related, and my disk should have been blacklisted, 
but is this already in 2.6.21-rc4 ?

Regards,
Paul

Paul Rolland, rol(at)as2917.net
ex-AS2917 Network administrator and Peering Coordinator

--

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
  

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Tejun Heo
> Sent: Monday, March 12, 2007 9:05 AM
> To: rol@as2917.net
> Cc: 'Linus Torvalds'; 'Jeff Garzik'; 'Alan Cox'; 'Andrew 
> Morton'; linux-ide@vger.kernel.org; 'LKML'; 'Eric D. Mudama'
> Subject: Re: [git patches] libata fixes
> 
> Paul Rolland wrote:
> >> I keep forgetting about this.  I'll ask SIMG how to deal with 
> >> this.  For
> >> the time being, connecting a device to the PMP port should 
> remove the
> >> timeouts.
> > 
> > That sounds a quite expensive solution ;)
> 
> You should be able to just move the drive attached at ata1 to ata2.
> Please report whether that works.
> 
> -- 
> tejun
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

