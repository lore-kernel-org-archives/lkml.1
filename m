Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYARO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYARO7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYARO7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:59:12 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3014 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbYARO7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:59:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 18 Jan 2008 14:59:08.0250 (UTC) FILETIME=[AD262BA0:01C859E2]
Content-class: urn:content-classes:message
Subject: Re: Communication between user process and kernel modules
Date: Fri, 18 Jan 2008 09:59:07 -0500
Message-ID: <Pine.LNX.4.61.0801180954040.7389@chaos.analogic.com>
in-reply-to: <14947386.post@talk.nabble.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Communication between user process and kernel modules
thread-index: AchZ4q1MXfsOdSuaSWqH0CWxCo6jbw==
References: <14947386.post@talk.nabble.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "mokhtar" <mbmessaoud@yahoo.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, mokhtar wrote:

>
> Hi
>
> What are the different solution to make a user process communicate with a
> kernel modules?
>
> Whatis the the advantages and disadvanteges of each solutions ?
>

ioctl() is the universal Unix mechanism for control of drivers
(modules). open(), close(), read(), write(), mmap() are the other
common methods. Some drivers may use sockets for communications.
I such a case, you use setsockopt() to change things.

Drivers can signal user-space processes as well. Such programs
use select() and poll().

>
> --

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
