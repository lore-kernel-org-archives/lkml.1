Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXCMMdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXCMMdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933227AbXCMMdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:33:39 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2053 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbXCMMdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:33:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 13 Mar 2007 12:33:35.0954 (UTC) FILETIME=[D1D34B20:01C7656B]
Content-class: urn:content-classes:message
Subject: Re: Question: kthread zombie process
Date: Tue, 13 Mar 2007 08:33:35 -0400
Message-ID: <Pine.LNX.4.61.0703130724380.25773@chaos.analogic.com>
In-Reply-To: <45F693B4.000001.09756@colgate.yandex.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Question: kthread zombie process
Thread-Index: Acdla9HysCLdn+/DSBeciP5xK2Lw+w==
References: <45F693B4.000001.09756@colgate.yandex.ru>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Mockern" <Mockern@yandex.ru>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 Mar 2007, Mockern wrote:

> Hi,
>
> I use kthread in my driver. The problem is that I can't kill process
> with kill_proc function. After rmmod my_driver, ps command shows again SW 
> my_driver.
>
> How can I remove this process?
>
> Thank you
>

You need to follow the procedures used by other kernel drivers that
use kernel threads. The kernel thread must be properly run-down during
the module removal process. An easy to read sample is in
../drivers/wireless/airo.c.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.64 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
