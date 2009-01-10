Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZAJNOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZAJNOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZAJNOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:14:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38084 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZAJNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:14:18 -0500
Message-ID: <49689F19.7030203@garzik.org>
Date: Sat, 10 Jan 2009 08:14:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com> <49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk> <200901101404.39139.borntraeger@de.ibm.com>
In-Reply-To: <200901101404.39139.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Samstag 10 Januar 2009 schrieb Alan Cox:
>>>    That's the typical REQUEST SENSE command with 18-byte data length.
>> Which means something has become horribly broken in the core libata stack.
>> An 18 byte inquiry would have 18 bytes as the *last* sg element. That
>> would therefore not trigger the WARN_ON. Someone has passed an sg list
>> that isn't properly terminated perhaps ?
>>
>> I wonder if the pad code broke this.
> 
> I just checked 2.6.28 + PIO32 patch. Its also broken. Whatever caused this 
> problem did it a while ago.

Just to be clear, you mean:

2.6.28 is OK
2.6.28 + PIO32 is broken

Correct?

	Jeff




