Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIYGKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIYGKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYIYGJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:09:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:44506 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYIYGJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=x4OkUzzw/xKv9tydab4J2YsLREA6wp1Hew5VXsfwzRmclFCVOZ7hiG7uF3DrfVmAjP
         FIkJWAc040yD3lITFr6RwVgGQN6Hkz3KZ/dZDZ2Lrkayw4AzeNJXiCKG5GKHORGWUh0C
         alu0wE2dmlHxh0ArLszsPb+wpBCJ3ISBdk48c=
Message-ID: <3ae72650809242309n1762b951pce151223320cc1b@mail.gmail.com>
Date: Wed, 24 Sep 2008 23:09:03 -0700
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Differend udev names with different kernels
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
In-Reply-To: <48DB28BB.3090200@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924200127.GA2452@dose.home.local>
	 <3ae72650809242012r7d144a64l35777f2a7bacbaa0@mail.gmail.com>
	 <48DB1CC4.2040004@s5r6.in-berlin.de>
	 <48DB28BB.3090200@s5r6.in-berlin.de>
X-Google-Sender-Auth: 0b7a20a4efee28a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 22:59, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> I wrote:
>>>
>>> On Wed, Sep 24, 2008 at 13:01, Tino Keitel <tino.keitel@gmx.de> wrote:
>>>>
>>>> My firewire hard disk seems to have different names with different
>>>> kernels.
>>>>
>>>> With 2.6.26.3, it's name is
>>>> /dev/disk/by-id/ieee1394-0030e001e0006585:00043c:0000.
>>>>
>>>> With someting after 2.6.27-rc7, merged with Arjan's fastboot branch,
>>>> the disk has the same name.
>>
>> Then this is a regression of the fastboot patch or whatever.
>>
>> I will watch what will happen in 2.6.28-rc.
>>
>>>> With 2.6.27-rc7, it is called
>>>> /dev/disk/by-id/scsi-1WDC_WD10EACS-00D6B0_WD-WCAU41668315.
>
> Uh, sorry, I misunderstood.  It is a regression of mainline then.

Yeah, I have more reports from people, that with recent kernels, the
ieee1394-* links showed up and replaced the scsi-* links, which they
say never happended before.
We ship these rules for a long time now, so I just guessed, they never
really worked before, but as all depends on timing, it's probably not
predictable what happens. Regardless of the needed fix for scsi sysfs,
we should provide both links, I guess.

Thanks,
Kay
