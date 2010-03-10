Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0CJAYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:24:07 -0500
Received: from wdscspam1.wdc.com ([129.253.170.130]:11204 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0CJAYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:24:04 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 19:24:03 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ATA 4 KiB sector issues.
Date: Tue, 9 Mar 2010 16:14:30 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD80@wdscexbe01.sc.wdc.com>
In-Reply-To: <4B96E25B.7050200@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ATA 4 KiB sector issues.
Thread-Index: Acq/5YKzJa1a3yllRDS7o+qXSjauEAAADjCw
References: <4B947393.2050002@kernel.org>	 <1268031640.4389.11.camel@mulgrave.site> <4B94ACE8.4060400@zytor.com> <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com> <4B96E25B.7050200@kernel.org>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "Tejun Heo" <tj@kernel.org>, "Greg Freemyer" <greg.freemyer@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "James Bottomley" <James.Bottomley@suse.de>,
       <linux-ide@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <kernel@teksavvy.com>,
       <tytso@mit.edu>, <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <irtiger@gmail.com>,
       "Matthew Wilcox" <matthew@wil.cx>, <aschnell@suse.de>,
       <knikanth@suse.de>, <jdelvare@suse.de>, <mkp@mkp.net>
X-OriginalArrivalTime: 10 Mar 2010 00:14:30.0986 (UTC) FILETIME=[A7AAEAA0:01CABFE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>> GPT can not be used for boot disks in non-EFI systems, right?

> IIUC, I think any BIOS should be able to do so as it only cares about the
code part of MBR
> not the partitions and even with GPT the MBR remains the same with the
partition part
> describing the rest of the while disk as a single chunk containing GPT
managed area.  The
> only problem is the older operating systems (like XP) which don't
understand GPT wouldn't be
> able to access those partitions.

> Thanks.

The MBR in a GPT installation doesn't map the first GPT partition, it maps
the entire drive
drive after the first sector, as well as marking it type 0xEE.  The start
LBA of the file system
is not correctly located in the MBR.

I will run some experiments to see if any of the systems on my desk can boot
Linux from a GPT.
