Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbXH2AQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbXH2AQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 20:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXH2AQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 20:16:14 -0400
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:6829 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbXH2AQN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 20:16:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Lguest] [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Date: Tue, 28 Aug 2007 16:59:53 -0700
Message-ID: <64F9B87B6B770947A9F8391472E032160D6557C3@ehost011-8.exch011.intermedia.net>
In-Reply-To: <f158dc670708281341m4c0c6213u69c42e1ea19914e9@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Lguest] [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
thread-index: AcfpyXkXfZF8KcqfTeCKrzOWddGCYgABe/pQ
References: <11883271601857-git-send-email-ericvh@gmail.com><11883271601227-git-send-email-ericvh@gmail.com><11883271602233-git-send-email-ericvh@gmail.com><200708282208.52902.arnd@arndb.de> <f158dc670708281341m4c0c6213u69c42e1ea19914e9@mail.gmail.com>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>, "Arnd Bergmann" <arnd@arndb.de>
Cc: <kvm-devel@lists.sourceforge.net>, <v9fs-developer@lists.sourceforge.net>,
       <lguest@ozlabs.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Aug 2007 00:00:00.0260 (UTC) FILETIME=[8AFBAC40:01C7E9CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Nice driver. I'm hoping we can do a virtio driver using a similar
>> concept.
>>
>> > +#define PCI_VENDOR_ID_9P     0x5002
>> > +#define PCI_DEVICE_ID_9P     0x000D
>>
>> Where do these numbers come from? Can we be sure they don't conflict
>with
>> actual hardware?
>
>I stole the VENDOR_ID from kvm's hypercall driver. There are no any
>guarantees that it doesn't conflict with actual hardware. As it was
>discussed before, there is still no ID assigned for the virtual
>devices.


Currently 5002 does not registered to Qumranet nor KVM.
We will do something about it pretty soon.
