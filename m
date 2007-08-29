Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXH2AHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXH2AHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 20:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXH2AHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 20:07:03 -0400
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:29632 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbXH2AHA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 20:07:00 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 20:07:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Date: Tue, 28 Aug 2007 17:01:58 -0700
Message-ID: <64F9B87B6B770947A9F8391472E032160D6557C9@ehost011-8.exch011.intermedia.net>
In-Reply-To: <a4e6962a0708281356p2c808841ud486376974c94eff@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
thread-index: Acfptf7/9ZSKlqIeQa2sgznQ0UkF3AAGbABw
References: <11883271601857-git-send-email-ericvh@gmail.com><11883271601227-git-send-email-ericvh@gmail.com><11883271602233-git-send-email-ericvh@gmail.com><200708282208.52902.arnd@arndb.de> <a4e6962a0708281356p2c808841ud486376974c94eff@mail.gmail.com>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Eric Van Hensbergen" <ericvh@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>
Cc: <kvm-devel@lists.sourceforge.net>, <v9fs-developer@lists.sourceforge.net>,
       <lguest@ozlabs.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Aug 2007 00:02:11.0128 (UTC) FILETIME=[D8FC8B80:01C7E9CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > This adds a shared memory transport for a synthetic 9p device for
>> > paravirtualized file system support under KVM/QEMU.
>>
>> Nice driver. I'm hoping we can do a virtio driver using a similar
>> concept.
>>
>
>Yes.  I'm looking at the patches from Dor now, it should be pretty
>straight forward.  The PCI is interesting in its own right for other
>(non-virtual) projects we've been playing with....
>
>     -eric

Great, we can add lots of pci bus shared functionality into the
kvm_pci_bus.c
--Dor
