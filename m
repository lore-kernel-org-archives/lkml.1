Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYIHUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYIHUZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYIHUZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:25:11 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2527 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYIHUZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:25:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 08 Sep 2008 20:24:17.0787 (UTC) FILETIME=[DE66C4B0:01C911F0]
Content-class: urn:content-classes:message
Subject: Re: Linux 2.6.25.17
Date: Mon, 8 Sep 2008 16:24:08 -0400
Message-ID: <Pine.LNX.4.61.0809081619410.12154@chaos.analogic.com>
In-Reply-To: <20080908210352.2b0cd70e@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux 2.6.25.17
Thread-Index: AckR8N5wAVDR1TLtTci/G5izc6Qo+A==
References: <20080908143516.GA7311@suse.de><Pine.LNX.4.61.0809081535280.5096@chaos.analogic.com> <20080908210352.2b0cd70e@lxorguk.ukuu.org.uk>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Greg KH" <gregkh@suse.de>, "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <stable@kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Sep 2008, Alan Cox wrote:

>> If I remove one of the CPUs, there is no file-system corruption
>> so I fear that there is some lock missing somewhere in the
>> serial ATA driver code (ata_piix or sata_sil).
>
> All the logic and locking is in the core code so would show up on all
> sorts of boxes. You say you are using sata_sil - is this on an Nvidia
> board ?
>
>> If anybody has anything to test with my setup, I can readily
>> test both with and without the two CPUs.
>
> Can you duplicate this with the drives just on the ata_piix ?
>
> Alan
>

The drives are on the ata_piix. I have no clue why the 'install'
added the sata_sil driver because I have never used on on this
machine! I note thet /etc/modprobe.conf has an alias for it so
at one time a Fedora install thought it found one!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.48 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
