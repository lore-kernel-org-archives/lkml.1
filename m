Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYAYSsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYAYSsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYAYSsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:48:24 -0500
Received: from spirit.analogic.com ([204.178.40.4]:3762 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYAYSsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:48:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 25 Jan 2008 18:48:20.0636 (UTC) FILETIME=[DB19FDC0:01C85F82]
Content-class: urn:content-classes:message
Subject: Re: Q: linux failed to execute /init?
Date: Fri, 25 Jan 2008 13:48:20 -0500
Message-ID: <Pine.LNX.4.61.0801251344300.18469@chaos.analogic.com>
in-reply-to: <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Q: linux failed to execute /init?
thread-index: AchfgttCrCGgyYM0Saeq7VTwKdaVjw==
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com> <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-14 is EFAULT. This means that there was some access
to memory that was not mapped.

In the future, check /usr/include/asm/errno.h for exit
codes. Of course in user-space they are positive with
-1 being return from the function-call and errno being
set to this code. In the kernel, they are combined with
'error' being the negative of the return code.

On Fri, 25 Jan 2008, Jack Harvard wrote:

> Hi,
>
> I'm trying to boot Linux, but the /init process failed. Here is the
> info:
>
> =FF<6>/init exit code: -14
> /init exit code: -14
> <4>Failed to execute /init
> Failed to execute /init
> <6>/sbin/init exit code: -14
>
> Just wondering what do those different exit codes mean?
>
> Thanks, -J
> --

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
