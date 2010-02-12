Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0BLIqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:46:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:37178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752290Ab0BLIqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:46:10 -0500
X-Authenticated: #2387525
X-Provags-ID: V01U2FsdGVkX1+CTIkTb/mCZJouNk2X2cEi/Uzf+yxWPUpYjZ63ie
	2yt/pv6llxUltt
Message-ID: <4B75154B.8030507@gmx.de>
Date: Fri, 12 Feb 2010 09:46:03 +0100
From: Axel Uhl <axel.uhl@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
References: <4B72941A.7060704@gmx.de> <4B74BDCF.1010805@kernel.org> <4B74F263.1060709@gmx.de> <4B7505CA.60409@kernel.org>
In-Reply-To: <4B7505CA.60409@kernel.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010402050301040003090808"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010402050301040003090808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tejun, (Cc list restored),

I don't have a /var/log/boot.msg, only a /var/log/boot. Its contents:

(Nothing has been logged yet.)

Output of cat /proc/interrupts:

            CPU0
   0:   41922385    XT-PIC-XT        timer
   1:         10    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   3:          4    XT-PIC-XT
   4:          1    XT-PIC-XT
   6:          3    XT-PIC-XT        floppy
   7:          1    XT-PIC-XT
   8:          4    XT-PIC-XT        rtc
   9:          0    XT-PIC-XT        acpi
  10:    1501691    XT-PIC-XT        sata_promise, sata_via, 
ehci_hcd:usb1, HDA Intel, eth6
  11:    6089136    XT-PIC-XT        saa7133[0], saa7133[0], eth5
  12:        131    XT-PIC-XT        i8042
  14:       1570    XT-PIC-XT        ide0
  15:       1503    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
TRM:          0   Thermal event interrupts
MCE:          0   Machine check exceptions
MCP:        559   Machine check polls
ERR:          1

Best,
-- Axel

Tejun Heo wrote:
> Hello,
> 
> Can you please restore cc list when you reply?
> 
> On 02/12/2010 03:17 PM, Axel Uhl wrote:
>> sorry, I'm not an expert on this, but are you saying the IRQ line is
>> *too* crowded and I'm having a hardware problem, or is this to say that
>> the kernel modules may not correctly handle the high frequency and total
>> number of IRQs from different devices? Is there anything I can do on the
>> hardware / BIOS side? Can I change the IRQ that some of those adapters
>> use somehow to work around the problem?
> 
> The hardware, kernel and drivers should be able to handle it fine but
> it's just very unusual to have that many controllers sharing a single
> IRQ line.  I have no idea whether it would have anything to do with
> the cause of the issue but it sure makes diagnosing the problem
> harder.
> 
> Can you please post /var/log/boot.msg and the output of cat
> /proc/interrupts?
> 
> Thanks.
> 

-- 
Find Security Certificate at http://www.axel-uhl.de/cgi-bin/cacert.cgi

--------------ms010402050301040003090808
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
HrP4mv47oeSzai16AAAAAAAA
--------------ms010402050301040003090808--
