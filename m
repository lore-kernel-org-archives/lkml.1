Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbXGHXVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbXGHXVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXGHXUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:20:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:49487 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbXGHXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ACz/ujIbb++9e+n8bH0zDZWpHRYHsbihilzpn8/uDNWrloenMjcBneoil5of5tDqRP8VP49q16YpUFpbcB58tSsp7nhgqXiB4uOjRIHRH/iQBf6suHFYq7PusQGZytriVu7feMT7QfDjquj3cn09aX9LURQ20+YgTzq3NhsZ14w=
Message-ID: <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com>
Date: Mon, 9 Jul 2007 01:20:51 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Flavio Curti" <lists.fcu@no-way.org>
Subject: Re: panics with 16port Promise Supertrack EX Controller
Cc: linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070708225246.GD16285@no-way.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070708225246.GD16285@no-way.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Flavio,

On 09/07/07, Flavio Curti <lists.fcu@no-way.org> wrote:
> Hello
>
> I have a problem with a server running 2.6.22rc4.

Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   (2.6.22-rc7-dorade #1)

Is this a regression?

> The machine panics
> after some days of running fine, the machine inst heavy loaded.
>
> The Controller detects as stex device:
>
> scsi0 : stex
> scsi 0:0:0:0: Direct-Access Promise 1X2 Mirror      1.10 PQ: 0 ANSI: 3
> scsi 0:0:2:0: Direct-Access Promise  12+2 Disk RAID6  1.10 PQ: 0 ANSI: 3
> scsi 0:0:16:0: Processor Promise RAID Console     1.00 PQ: 0 ANSI: 3
> sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] 976642048 512-byte hardware sectors (500041 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
> sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
> sd 0:0:2:0: [sdb] Write Protect is off
> sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:2:0: [sdb] Very big device.  Trying to use READ CAPACITY(16).
> sd 0:0:2:0: [sdb] 11719704576 512-byte hardware sectors (6000489 MB)
> sd 0:0:2:0: [sdb] Write Protect is off
> sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sdb: sdb1
> sd 0:0:2:0: [sdb] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sd 0:0:2:0: Attached scsi generic sg1 type 0
> scsi 0:0:16:0: Attached scsi generic sg2 type 3
>
> Im not sure where the problem is (controller/lvm/ext3), so if anyone has
> an idea, Im happy to try it out...

kernel BUG at block/as-iosched.c:1084!

BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));

>
> Thank you
>
> Flavio Curti
>
> --
> http://no-way.org/~fcu/
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
