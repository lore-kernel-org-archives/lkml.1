Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXI1Un3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXI1Un3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXI1UnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:43:07 -0400
Received: from mail.tmr.com ([64.65.253.246]:33600 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbXI1UnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:43:06 -0400
Message-ID: <46FD689D.7040103@tmr.com>
Date: Fri, 28 Sep 2007 16:48:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB autosuspend and turning of usb pendrive leds
References: <46F3C704.5000203@hhs.nl>
In-Reply-To: <46F3C704.5000203@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Goede wrote:
> Hi All,
> 
> Please keep me CC-ed as I'm not subscribed.
> 
> Some time ago a mail about turning of the leds on usb pendrives once 
> unmounted by hal was send to the fedora-devel list:
> https://www.redhat.com/archives/fedora-devel-list/2007-August/msg01807.html
> 
> This mail talked about echo 2 > power/state for usb devices.
> 
> I tested the method described in the mail to turn of the drive light and 
> it worked well.
> 
> As I think that turning of the drive led (as windows does) would be good 
> visual feedback to the end user that its safe to remove the device I've 
> written a patch for hal which does the power state change automatically 
> when the last partition of a usb massstorage device gets unmounted.
> 
> However when testing the patch I found out that my now newer kernel no 
> longer has power/state for usb devices, it only has power/level. I can 
> send suspend to power/level, but then remounting the device won't work 
> and me syslog fills itself with:
> sd 2:0:0:0: [sdc] READ CAPACITY failed
> sd 2:0:0:0: [sdc] Result: hostbyte=DID_ERROR 
> driverbyte=DRIVER_OK,SUGGEST_OK
> sd 2:0:0:0: [sdc] Sense not available.
> sd 2:0:0:0: [sdc] Write Protect is off
> sd 2:0:0:0: [sdc] Mode Sense: 00 00 00 00
> sd 2:0:0:0: [sdc] Assuming drive cache: write through
> 
> Because hal keeps polling the device.

What did power/state do, and can that capability be easily recovered? 
Being able to turn off the lights is desirable, but it may be that 
standby is the only way to do that, with all the issue already discussed 
in this thread. But if there's another way, it would be useful.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
