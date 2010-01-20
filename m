Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967Ab0ATKXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0ATKXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775Ab0ATKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:22:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14694 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0ATKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:22:58 -0500
Date: Wed, 20 Jan 2010 11:21:51 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: RE: [PATCH/RFC v1 0/2] Human readable performance event description in
 sysfs
In-reply-to: <20100120095757.GA20302@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: jpihet@mvista.com, peterz@infradead.org,
       Pawel Osciak <p.osciak@samsung.com>, jamie.iles@picochip.com,
       will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <023f01ca99ba$61ce7e90$256b7bb0$%fujak@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcqZtymhHwTqZqaVTvy9vwfHQk7rNAAAZTCA
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
 <20100120095757.GA20302@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Russell King - ARM
> Linux
> Sent: Wednesday, January 20, 2010 10:58 AM
> To: Tomasz Fujak
> Cc: jpihet@mvista.com; peterz@infradead.org; p.osciak@samsung.com;
> jamie.iles@picochip.com; will.deacon@arm.com; linux-
> kernel@vger.kernel.org; kyungmin.park@samsung.com; mingo@elte.hu;
> linux-arm-kernel@lists.infradead.org; m.szyprowski@samsung.com
> Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
> description in sysfs
> 
> On Wed, Jan 20, 2010 at 10:11:44AM +0100, Tomasz Fujak wrote:
> > The following patches provide a sysfs entry with hardware event human
> > readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" %
> > (event_value, minval, maxval, name, description)
> 
> I think your patch is in violation of this from
> Documentation/filesystems/sysfs.txt:
> 
> Attributes
> ~~~~~~~~~
> ...
> Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type.
> 
> Mixing types, expressing multiple lines of data, and doing fancy
> formatting of data is heavily frowned upon. Doing these things may get
> you publically humiliated and your code rewritten without notice.

1. There are numerous exceptions:
$ find /sys -exec grep -HC ^ {} \; 2>/dev/null | grep ":[3-9]$" | grep -c
yielded 43 on my machine.
Some of them list multiple lines with fancy formatting each (i.e.:
/sys/class/Bluetooth/l2cap or devices/pci*/resource)

2. There are sysfs entries regarding the performance counters already:
'overcommit' and 'reserve_percpu'
They are simple, I admit, but I find it useful to have all relevant thing in
one place.

If the above does not convince you, I could move the file to the debugfs.

> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

