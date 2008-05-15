Return-Path: <linux-kernel-owner+w=401wt.eu-S1764575AbYEOR7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764575AbYEOR7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764308AbYEOR6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:58:52 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3362 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294AbYEOR6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:58:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 May 2008 17:57:54.0896 (UTC) FILETIME=[3378F500:01C8B6B5]
Content-class: urn:content-classes:message
Subject: Re: Hardware designt to prevent Damages... [WAS: [patch 23/37] i2c-piix4: Blacklist two mainboards]
Date: Thu, 15 May 2008 13:57:35 -0400
Message-ID: <Pine.LNX.4.61.0805151346530.14844@chaos.analogic.com>
In-Reply-To: <20080514195253.GB5673@freenet.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Hardware designt to prevent Damages... [WAS: [patch 23/37] i2c-piix4: Blacklist two mainboards]
thread-index: Aci2tTOCfhsKXDqzRoGsh4Wl4MJvkQ==
References: <20080513200453.064446337@mini.kroah.org> <20080513201225.GX31167@suse.de> <20080514195253.GB5673@freenet.de>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Michelle Konzack" <linux4michelle@tamay-dogan.net>
Cc: "Greg KH" <gregkh@suse.de>, "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       "Jean Delvare" <khali@linux-fr.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15912.000
X-TM-AS-Result: No--12.011900-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 May 2008, Michelle Konzack wrote:

> Hello *,
>
> I in creation of a new Enterprise building small ARM based portable
> Computers and I make heavy use of I2C and 1-Wire...
>
> Now I have gooten the following from the LKM:
>
> Am 2008-05-13 13:12:25, schrieb Greg KH:
>> We had a report that running sensors-detect on a Sapphire AM2RD790
>> motherbord killed the CPU. While the exact cause is still unknown,
>> I'd rather play it safe and prevent any access to the SMBus on that
>> machine by not letting the i2c-piix4 driver attach to the SMBus host
>> device on that machine. Also blacklist a similar board made by DFI.
> ------------------------ END OF REPLIED MESSAGE ------------------------
>

Many (perhaps all) modern computers perform the final building
process upon power up. This usually involves writing bits to
some gate-arrays and performing hardware initializations with
registers that disappear once the machine starts acting like
a real PC. I wrote a BIOS for the AMD SC520 and most of the
code involved "building" the machine. However, there was an
unwritten rule that nothing could be done to hurt anything.

There is only one CPU that I know of, the 56000 DSP, that
can be configured with insane instructions that will hurt
it.

Nowadays, more power adjustment stuff is being put where
it shouldn't be. A bad bit somewhere may cause a power
supply to go out of regulation and burn out something
(like the CPU). If you find something like this, the
machine vendor should replace the machine and/or the
machine should be black-listed. We can't have computers
in which a random event such as an alpha-particle upset
can actually hurt anything.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
