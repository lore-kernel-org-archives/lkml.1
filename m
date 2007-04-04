Return-Path: <linux-kernel-owner+w=401wt.eu-S934048AbXDDPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbXDDPxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbXDDPxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:53:09 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4844 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048AbXDDPxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:53:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Apr 2007 15:53:03.0908 (UTC) FILETIME=[545EA640:01C776D1]
Content-class: urn:content-classes:message
Subject: Re: set up new kernel with grub
Date: Wed, 4 Apr 2007 11:53:03 -0400
Message-ID: <Pine.LNX.4.61.0704041246010.5035@chaos.analogic.com>
In-Reply-To: <BAY113-DAV124C8565330DC6C51B2B09B9660@phx.gbl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: set up new kernel with grub
thread-index: Acd20VSCo0HFyTxeQra12cFSHbw5dQ==
References: <BAY113-DAV124C8565330DC6C51B2B09B9660@phx.gbl>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Michael" <gonwg@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Apr 2007, Michael wrote:

> Hi,
>
> I compiled a new kernel: 2.6.20.3, and hope to test it without removing
> my old kernel.

You don't need to remove your old kernel. Log in as root.

# cd /usr/src/linux-2.6.20.3
If your current kernel is 2.6.20.3, edit the Makefile to
add some character after "EXTRAVERSION" as EXTRAVERSION= 3x
# cp .config ..
# make distclean
# cp ../.config .
# make oldconfig
# make
# make modules_install
# make install

The result will put the new kernel in the GRUB menu so you can
always go back to the old one if the new one doesn't work.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.65 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
