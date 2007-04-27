Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbXD0L1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbXD0L1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXD0L1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:27:54 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3105 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbXD0L1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:27:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 27 Apr 2007 11:27:41.0146 (UTC) FILETIME=[112A3BA0:01C788BF]
Content-class: urn:content-classes:message
Subject: Re: assembly code in the loadable kernel module
Date: Fri, 27 Apr 2007 07:27:40 -0400
Message-ID: <Pine.LNX.4.61.0704270726080.3369@chaos.analogic.com>
In-Reply-To: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: assembly code in the loadable kernel module
Thread-Index: AceIvxFOhGKf+M7iTl6sMkB1vyjVZQ==
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Parav K Pandit" <Parav_Pandit@mindtree.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Apr 2007, Parav K Pandit wrote:

> Hi,
>
> I have written one function in assembly for my kernel module.
> Function is in module3.s file.
> I have added the module3.o file in the object list in the Makefile.
> But it shows compile time warning and following output.
>
> What do I need to do to compile assembly code in my kernel module.
>
> CC [M]  /home/parav/cache_improve/test_module/module1.o
> CC [M]  /home/parav/cache_improve/test_module/module2.o
> as -a32 -o /home/parav/cache_improve/test_module/module3.o
> /home/parav/cache_improve/test_module/module3.s
> LD [M]  /home/parav/cache_improve/test_module/sdk3_module.o
> Building modules, stage 2.
> MODPOST
> Warning: could not find /home/parav/cache_improve/test_module/.module3.o.cmd
> for /home/parav/cache_improve/test_module/module3.o
> *** Warning: "test_func"
> [/home/parav/cache_improve/test_module/sdk3_module.ko] undefined!
> *** Warning: "" [/home/parav/cache_improve/test_module/sdk3_module.ko]
> undefined!
>
> I expect CC[M] kind of command for the module3.o file also so that
> .module3.o.cmd file gets generated.
>
> Regards,
> Parav Pandit

Just name the source module3.S
                              ^______ not .s
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.62 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
