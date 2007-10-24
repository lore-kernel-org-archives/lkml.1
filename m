Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXJXPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXJXPaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXJXPaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:30:22 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1235 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbXJXPaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:30:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 24 Oct 2007 15:30:18.0713 (UTC) FILETIME=[C881AC90:01C81652]
Content-class: urn:content-classes:message
Subject: Re: kernel processes - are they really needed?
Date: Wed, 24 Oct 2007 11:30:17 -0400
Message-ID: <Pine.LNX.4.61.0710241125490.18050@chaos.analogic.com>
In-reply-to: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel processes - are they really needed?
Thread-Index: AcgWUsinGzBPmwWLTHuycyM8cOnRYg==
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Ram" <vshrirama@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Oct 2007, Ram wrote:

> Hi,
>    When i do ps -l. i see the following processes which are obviously
> started by kernel.
>
>   Could any one tell me what each of these processes do and can
> anyone of them can be removed.?
>
> PID  Uid     VmSize Stat Command
>    1 root        584 S   init
>    2 root            SWN [ksoftirqd/0]
>    3 root            SW  [watchdog/0]
>    4 root            SW< [events/0]
>    5 root            SW< [khelper]
>    6 root            SW< [kthread]
>   23 root            SW< [kblockd/0]
>   38 root            SW  [pdflush]
>   39 root            SW  [pdflush]
>   40 root            SW< [kswapd0]
>   41 root            SW< [aio/0]
>   85 root            SW  [mtdblockd]
>  116 root            SWN [jffs2_gcd_mtd9]
> Regards,
> ram
> -

Init is the 'mother' of all processes. It sleeps using
no resources until some other process terminates. At
that time,...............learn about Unix somewhere else.

Other tasks are essential as well.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
