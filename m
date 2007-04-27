Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXD0VG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXD0VG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbXD0VG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:06:56 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2888 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbXD0VGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:06:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 27 Apr 2007 21:06:53.0383 (UTC) FILETIME=[FB1CC570:01C7890F]
Content-class: urn:content-classes:message
Subject: Re: assembly code in the loadable kernel module
Date: Fri, 27 Apr 2007 17:06:48 -0400
Message-ID: <Pine.LNX.4.61.0704271658240.5071@chaos.analogic.com>
In-Reply-To: <200704271212.07579.dhazelton@enter.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: assembly code in the loadable kernel module
Thread-Index: AceJD/skeb+/h29YR+Wbmu/NJp8l4A==
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com> <Pine.LNX.4.61.0704270726080.3369@chaos.analogic.com> <698310e10704270457p7fce899ao16dee58b5e16869c@mail.gmail.com> <200704271212.07579.dhazelton@enter.net>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Cc: "Marat Buharov" <marat.buharov@gmail.com>,
       "Parav K Pandit" <Parav_Pandit@mindtree.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Apr 2007, Daniel Hazelton wrote:
> On Friday 27 April 2007 07:57:58 Marat Buharov wrote:
>> On 4/27/07, Parav K Pandit <Parav_Pandit@mindtree.com> wrote:
[SNIPPED all the junk]
>
> Most companies require that *ANY* e-mail sent by employees while at work
> contain disclaimers like those. Some of them even have their mail servers
> *automatically* attach those footers.
>
> DRH
>

Yes, it's getting to be widespread. However, there is a way around it for
facilities like the linux-kernel list. Everybody could put a ^D or ^Z at
the end of their .sig . Then the list-server software could filter it like:
-----------
//
// Free software
//
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(void);
int main()
{
     char buf[0x400];
     for(;;)
     {
        if(!fgets(buf, sizeof(buf), stdin) || feof(stdin))
            break;
        fprintf(stdout, buf);
        if(strchr(buf, 'Z'-64) || strchr(buf, 'D'-64))
            break;
     }
     return 0;
}
---------
Anything after ^D or ^Z doesn't get copied to the list. Something like
this needs to be done because it's gonna get a whole lot worse because
all the 'IT' people read the same rags -- so they think that "naked"
email fails the "due diligence" test. Honest, I'm not making that up!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.62 BogoMips).
New book: http://www.AbominableFirebug.com/
_



****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
