Return-Path: <linux-kernel-owner+w=401wt.eu-S1030552AbXBOSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030552AbXBOSzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030555AbXBOSzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:55:16 -0500
Received: from spirit.analogic.com ([204.178.40.4]:3818 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030552AbXBOSzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:55:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Feb 2007 18:55:11.0775 (UTC) FILETIME=[D20ED2F0:01C75132]
Content-class: urn:content-classes:message
Subject: Re: APIC priorities, can they be changed?
Date: Thu, 15 Feb 2007 13:55:11 -0500
Message-ID: <Pine.LNX.4.61.0702151353250.2468@chaos.analogic.com>
In-Reply-To: <45D4A692.7090108@wegener.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: APIC priorities, can they be changed?
Thread-index: AcdRMtImtIVTHla9QVyuZ3jagKJk7w==
References: <45D4A692.7090108@wegener.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Mike Panetta" <m.panetta@wegener.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Feb 2007, Mike Panetta wrote:

> I am not on the list (corperate email sucks) so please CC any replies to
> me.  Thanks.
>
> I am working on a project that has run in to what seems to be an
> interrupt priority problem.  We switched mainboards in our product and
> went from a system where the EHCI controller IRQ was of a fairly high
> priority to one where its the lowest in the system.  Now we cannot get
> the data off our USB device in time and we drop alot of data.  I was
> hoping someone here may have a simple(ish) solution to the problem.
>
> I have seen the preempt patches, but they touch a lot of files, and we
> have gone through testing with the 2.6.16.19 kernel and do not wish to
> change, and we cannot find a version of the patch for this kernel. Is
> there something smaller/simpler I can do?  My understanding is the
> priority in the APIC is set in software via the interrupt vector number
> (higher numbers have lower priority) is this true?  If so, how hard
> would it be for me to just change the vector numbers around?
>
> Ideally I would love to switch to the 2.6.20 kernel and use the preempt
> patch, but I doubt we have the time for that.
>
> Thanks,
> Mike

Can't you muck with the BIOS settings? That's where the primary
hardware gets 'connected'.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
