Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZDXMza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZDXMza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZDXMzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:55:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZDXMzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:55:17 -0400
Message-ID: <49F1B68D.3010304@garzik.org>
Date: Fri, 24 Apr 2009 08:54:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com,
       snitzer@redhat.com, neilb@suse.de,
       James.Bottomley@hansenpartnership.com, dgilbert@interlog.com,
       jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and
 	partitions
References: <patchbomb.1240551141@sermon.lab.mkp.net> <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net> <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
In-Reply-To: <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>> +What:          /sys/block/<disk>/alignment
>> +What:          /sys/block/<disk>/<partition>/alignment
>> +What:          /sys/block/<disk>/queue/minimum_io_size
>> +What:          /sys/block/<disk>/queue/optimal_io_size
> 
> Wouldn't it be good to include "sector", like the queue files do? The
> alignment of a partition could mean many things.
>   /sys/block/<disk>/sector_alignment
>   /sys/block/<disk>/<partition>/sector_alignment
> 
> And prefixing the io values might be easier to read when they show up
> in a group?
>   /sys/block/<disk>/queue/io_minimum_size
>   /sys/block/<disk>/queue/io_optimal_size
>   /sys/block/<disk>/queue/io_...

Why do we need all this syscall overhead just to read individual data items?

Isn't it dumb to require 30 userland syscalls simply to input a 
10-member data structure?

netlink looks more and more attractive for anything non-trivial.

	Jeff



