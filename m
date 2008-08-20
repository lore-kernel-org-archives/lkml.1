Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYHTREL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYHTREL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbYHTRDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:03:38 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2655 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760883AbYHTRDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:03:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 20 Aug 2008 17:01:00.0858 (UTC) FILETIME=[529DD9A0:01C902E6]
Content-class: urn:content-classes:message
Subject: Re: distributed shared memory / mmap
Date: Wed, 20 Aug 2008 13:00:59 -0400
Message-ID: <Pine.LNX.4.61.0808201258360.10696@chaos.analogic.com>
In-Reply-To: <48AC37DC.6060000@cfl.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: distributed shared memory / mmap
Thread-Index: AckC5lLE48e5b69HQue1C8/UZG+jdw==
References: <1219238336.8097.29.camel@localhost> <48AC37DC.6060000@cfl.rr.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Mark Hounschell" <dmarkh@cfl.rr.com>
Cc: "Martin Uecker" <muecker@gwdg.de>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Mark Hounschell wrote:

> Martin Uecker wrote:
>>
>> Hi!
>>
>> Is there any easy way to get shared memory between to
>> processes on different machines? It seems possible using mmap
>> on a file system like GFS on top of a distributed block device.
>>
>>
>
> There is hardware available, designed just for this. Reflective Memory
> pci cards.
>
> Mark
> --

Check out "Fabric." There is even an InfiniBand driver in the
kernel. Fabric attached memory is used for HPC (High Performance
Computing). It's been around for a couple of years and is fairly
mature.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (4785.87 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
