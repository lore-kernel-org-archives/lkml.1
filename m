Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbXBMLld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbXBMLld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXBMLld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:41:33 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:49085 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbXBMLld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:41:33 -0500
Message-ID: <45D1A3EA.6040406@gmail.com>
Date: Tue, 13 Feb 2007 12:41:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: albcamus <albcamus@gmail.com>
Cc: Reg Clemens <reg@dwf.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why can't I build a running Kernel?
References: <200702081817.l18IHlbE027996@deneb.dwf.com>	 <45CB79CF.9010702@gmail.com>	 <df9815e70702120036k3e2a2a50re0dc2605c31766f3@mail.gmail.com>	 <45D04F30.2090600@gmail.com> <df9815e70702121816p265446b7oaaccc1a736bb55c1@mail.gmail.com>
In-Reply-To: <df9815e70702121816p265446b7oaaccc1a736bb55c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

albcamus napsal(a):
> 2007/2/12, Jiri Slaby <jirislaby@gmail.com>:
>> and lines from your boot loader.
>>
> 
> title Fedora Core (2.6.20)
>     root (hd0,1)
>     kernel /vmlinuz-2.6.20 ro root=LABEL=/ vga=0x31B
>     initrd /initrd-2.6.20.img
> 
> And I have the SATA device /dev/sda3 labeled as '/'.

I would try to disable piix from old ATA tree (which was superseded by libata 
ata_piix). This is what've changed since 2.6.19 times -- you probably may turn 
the whole 'ATA/ATAPI/MFM/RLL support' off. Another problem may lie in your 
initrd, what distro do you use/what type of initrd do you have -- it would be 
reasonable to look into it, what (which modules) does it contain and load.

reagrds,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
