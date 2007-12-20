Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbXLTW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbXLTW4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXLTW4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:56:37 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:4921 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbXLTW4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:56:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 20 Dec 2007 22:56:19.0856 (UTC) FILETIME=[88EFC900:01C8435B]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Thu, 20 Dec 2007 17:56:19 -0500
Message-ID: <Pine.LNX.4.61.0712201755330.9907@chaos.analogic.com>
in-reply-to: <ada1w9hyrhn.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchDW4j7EBYVIZuqQl2cP84ApmAFQQ==
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com><20071219202323.GH2310@csclub.uwaterloo.ca><Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com><20071220150255.GE2308@csclub.uwaterloo.ca><Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com><20071220162700.GF2308@csclub.uwaterloo.ca><Pine.LNX.4.61.0712201615580.9531@chaos.analogic.com> <ada1w9hyrhn.fsf@cisco.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Dec 2007, Roland Dreier wrote:

> > It doesn't seem to be something in .config. Do you know how to
> > reconfigure to get parameter passing put back like it was? Our
> > production applications have lots of assembly-language files
> > and I'm sure we are not going to be able to change all those!
>
> 32-bit x86 uses regparm=3 by default now since commit a1a70c25 ("i386:
> always enable regparm"), which went in about a year ago.  To go back
> to the old way, you'll just have to edit arch/x86/Makefile_32 (and
> rebuild your whole kernel from a clean tree, obviously).

Okay. Thanks! I need to do that.

>
> - R.
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
