Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbXI0UxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbXI0UxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXI0UxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:53:14 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4911 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXI0UxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:53:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 27 Sep 2007 20:53:10.0379 (UTC) FILETIME=[69C413B0:01C80148]
Content-class: urn:content-classes:message
Subject: Re: Floating Point Issue
Date: Thu, 27 Sep 2007 16:53:04 -0400
Message-ID: <Pine.LNX.4.61.0709271645590.5183@chaos.analogic.com>
In-Reply-To: <109515.18343.qm@web7805.mail.in.yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Floating Point Issue
Thread-Index: AcgBSGnN7zRmtBFSQUeX/j1jvDc91Q==
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "mahamuni ashish" <ash_lkp@yahoo.co.in>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



If Windows lets you get away with this, then Windows is broken.
memset(ch,'\0',strlen(ch) );

'ch' is uninitialized local data. Nobody knows what evil lurks...


Thay said, the kernel will make sure that any data that gets
put into your address-space doesn't contain anybody else's
information --that's all. The junk on your stack was created
by your task.


On Thu, 27 Sep 2007, mahamuni ashish wrote:

> I have small code....
>
> #include <stdio.h>
> #include <string.h>
>
> int main()
> {
> float f= 1256.35;
> char ch[4];
>
> printf("\n1. f : %f",f);
> memset(ch,'\0',strlen(ch) );
> printf("\n2. f : %f",f);
> return 0;
> }
>
> Expected output is
> 1. f : 1256.35
> 2. f : 1256.35
>
> But I am getting the output
> (on windows)
> 1. f : 1256.35
> 2. f : 0.000000
>
> (on Linux)
> 1. f : 1256.35
> segmentation fault
>
> why?
>
>
>      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
