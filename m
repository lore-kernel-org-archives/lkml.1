Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYAJOl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYAJOl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYAJOlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:41:17 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:46812 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbYAJOlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:41:11 -0500
Date: Thu, 10 Jan 2008 15:41:03 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080110144103.GA25187@citd.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108230600.GA9071@citd.de> <478601D7.90004@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478601D7.90004@aitel.hist.no>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.01.2008 12:30, Helge Hafting wrote:
> Matthias Schniedermeyer wrote:
>>>> Don't use udev then. Good old static dev works fine if you have a fixed
>>>> set of devices.
>>>>       
>>> It doesn't, with the unpredictable SCSI mapping insanity.
>>>     
>>
>> That what LABEL und UUID-Support in mount is for.
>>
>> You label the filesystems (e2label for ext2 and ext3) and use that label to mount them
>>
>> - fstab -
>> LABEL=root  /        xfs     defaults,noatime	0 1
>> LABEL=boot  /boot    ext2    defaults,noatime	0 2
>>   
> Would've been nice if they worked, but they don't.
>
> Disks should be so easy to identify uniquely, because they have
> storage space that can be used for that label.
>
> So I tried (debian linux, last year).
>
> Mount by label was fine, of course.
> Until the 33rd reboot, when it was decided that a
> fsck was necessary "just to be safe".  The problem was that fsck
> fail to find the correct device when /etc/fstab specifies a label
> instead of a device. The boot failed, reboot with init=/bin/sh
> and replace the dysfunctional labels with oldfashioned device names.
>
> I can live with this kind of problem on my desktop, but this machine
> was going to be a internet router for a customer, so occational
> boot failure requiring intervention was not an option.

As written by Theodore somewhere else in this thread support for labels 
in fsck came later, so maybe the fsck-version on your problematic-server 
was too old.

Personally i never had a problem with labels and i use them for about 
4-5 years now.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

