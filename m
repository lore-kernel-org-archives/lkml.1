Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXDEE3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXDEE3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXDEE3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:29:18 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:34355 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXDEE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:29:16 -0400
Message-ID: <46147B12.60109@suse.de>
Date: Thu, 05 Apr 2007 13:29:06 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Bill Davidsen <davidsen@tmr.com>, linux@horizon.com,
       dan.j.williams@intel.com, linux-ide@vger.kernel.org, neilb@suse.de,
       cebbert@redhat.com, jens.axboe@oracle.com, linux-kernel@dale.us,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
References: <20070323174630.31051.qmail@science.horizon.com>	 <4611EADC.3000306@suse.de> <46143338.3020808@tmr.com> <75b66ecd0704042113mebd1275w2fa40bf159416811@mail.gmail.com>
In-Reply-To: <75b66ecd0704042113mebd1275w2fa40bf159416811@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 4/4/07, Bill Davidsen <davidsen@tmr.com> wrote:
>> I won't say that's voodoo, but if I ever did it I'd wipe down my
>> keyboard with holy water afterward. ;-)
>>
>> Well, I did save the message in my tricks file, but it sounds like a
>> last ditch effort after something get very wrong.

Which actually is true.  ATA ports failing to reset indicate something
is very wrong.  Either the attached device or the controller is broken
and libata shuts down the port to protect the rest of the system from
it.  The manual scan requests tell libata to give it one more shot and
polling hotplug can do that automatically.  Anyways, this shouldn't
happen unless you have a broken piece of hardware.

> Would it reallty be an impediment to development if the kernel
> maintainers simply refuse to merge patches that add new sysfs entries
> without corresponding documentation?

SCSI host scan nodes have been there for a long time.  I think it's
documented somewhere.

-- 
tejun
