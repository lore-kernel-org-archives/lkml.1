Return-Path: <linux-kernel-owner+w=401wt.eu-S966080AbXBOQuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966080AbXBOQuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966112AbXBOQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:50:22 -0500
Received: from spirit.analogic.com ([204.178.40.4]:1625 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966080AbXBOQuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:50:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Feb 2007 16:50:18.0118 (UTC) FILETIME=[5F7D8260:01C75121]
Content-class: urn:content-classes:message
Subject: Re: cat, cp operations for tty driver (like for char one)
Date: Thu, 15 Feb 2007 11:50:17 -0500
Message-ID: <Pine.LNX.4.61.0702151146400.2062@chaos.analogic.com>
In-Reply-To: <45D47779.000006.08064@webmail16.yandex.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: cat, cp operations for tty driver (like for char one)
Thread-index: AcdRIV+mWzYmA7zgQcmlk7qKfM0RDw==
References: <45D47779.000006.08064@webmail16.yandex.ru>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Mockern" <Mockern@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Feb 2007, Mockern wrote:

> I have a question about linux tty driver
>
> how to support cp, cat operations in tty driver (like tiny_tty)?
> (e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)
>
> There a lot of examples with char drivers, but I could not find it for tty Linux driver.
>

It works out of the box. Just keep hardware flow-control turned off
if there are no receivers connected to the output port. Also, you need
to set up the port's baud-rate and (usually) to make it transparent to
control characters (man tc-get/set-attr).

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
