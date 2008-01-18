Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbYARPfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbYARPfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbYARPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:35:24 -0500
Received: from mail-gw3.adaptec.com ([162.62.93.58]:56019 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097AbYARPfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:35:22 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: "'linux-os (Dick Johnson)'" <linux-os@analogic.com>,
       "'mokhtar'" <mbmessaoud@yahoo.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jan 2008 07:35:16 -0800
Subject: RE: Communication between user process and kernel modules
Thread-Topic: Communication between user process and kernel modules
Thread-Index: AchZ4q1MXfsOdSuaSWqH0CWxCo6jbwABKeJA
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4391E89EC@ADPE2K703.adaptec.com>
References: <14947386.post@talk.nabble.com>
 <Pine.LNX.4.61.0801180954040.7389@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0801180954040.7389@chaos.analogic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other means of communications include sysfs and procfs. These have the advantage of supporting scripting and can survive ABI changes that can plague the other interfaces; but are meant for low-bandwidth or out-of-band configuration or simple status reporting.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> linux-os (Dick Johnson)
> Sent: Friday, January 18, 2008 9:59 AM
> To: mokhtar
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Communication between user process and kernel modules
>
>
> On Fri, 18 Jan 2008, mokhtar wrote:
>
> >
> > Hi
> >
> > What are the different solution to make a user process
> communicate with a
> > kernel modules?
> >
> > Whatis the the advantages and disadvanteges of each solutions ?
> >
>
> ioctl() is the universal Unix mechanism for control of drivers
> (modules). open(), close(), read(), write(), mmap() are the other
> common methods. Some drivers may use sockets for communications.
> I such a case, you use setsockopt() to change things.
>
> Drivers can signal user-space processes as well. Such programs
> use select() and poll().
>
> >
> > --
>
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29
> BogoMips).
> My book : http://www.AbominableFirebug.com/
> _
>
>
> ****************************************************************
> The information transmitted in this message is confidential
> and may be privileged.  Any review, retransmission,
> dissemination, or other use of this information by persons or
> entities other than the intended recipient is prohibited.  If
> you are not the intended recipient, please notify Analogic
> Corporation immediately - by replying to this message or by
> sending an email to DeliveryErrors@analogic.com - and destroy
> all copies of this information, including any attachments,
> without reading or disclosing them.
>
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
