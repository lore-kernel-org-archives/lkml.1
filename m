Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYAIWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYAIWDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYAIWDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:03:06 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1170 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYAIWDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:03:05 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 09 Jan 2008 22:02:03.0662 (UTC) FILETIME=[445B02E0:01C8530B]
Content-class: urn:content-classes:message
Subject: Re: uml and -regparm=3
Date: Wed, 9 Jan 2008 17:01:52 -0500
Message-ID: <Pine.LNX.4.61.0801091659060.29624@chaos.analogic.com>
in-reply-to: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: uml and -regparm=3
thread-index: AchTC0RkfidEhyu7RPOxa0k3Li/hWg==
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: <jdike@addtoit.com>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       <user-mode-linux-devel@lists.sourceforge.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Jan 2008, Miklos Szeredi wrote:

> FASTCALL is defined empty in -mm, but UML is not compiled with
> -mregparm=3 and so this breaks things (I noticed problems with
> rwsem_down_write_failed).
>
> Tried recompiling UML with -mregparm=3, but that resulted in a strange
> failure immediately after startup:
>
> |%Gÿÿÿÿÿÿ%@: Invalid argument
>
> What's up?
>
> Miklos
> --

UML gets linked with the 'C' runtime library. It doesn't
pass parameters in registers unless you get the source and
recompile the whole thing --and then you would have to
recompile all your applications, too. Yikes!


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
