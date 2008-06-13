Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYFMU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYFMU3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYFMU3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 16:29:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55794 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYFMU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 16:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RR75xYqO4k7Ci1Iz+9pbqGq6gdkSrs9PQnUlea/26HEMl+4H1IwWbwtM5L8PKthL6l
         aWLP/XvQX5gHvFE/feXecZUWj3p89e61gj3UYV+ZPBoUGmxoy6egreVtRC63Y+e6sfTC
         +wTu9RfoBHXIEdqhA9sI3WGSjkx5D/Q+vY1Zo=
Message-ID: <c3d0340b0806131329n604b11bcv5dce0985580516fc@mail.gmail.com>
Date: Fri, 13 Jun 2008 13:29:05 -0700
From: "Shawn Jin" <shawnxjin@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Force a usb drive to be /dev/sda?
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48521539.9020102@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4850DFB4.5020205@wpkg.org> <4851046E.907@s5r6.in-berlin.de>
	 <c3d0340b0806122232s72d37509wd976217d336b83e7@mail.gmail.com>
	 <48521539.9020102@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

>>>  1. Mount filesystems by UUID or by label.
>>>   Doesn't work with some filesystems.
>>
>> The bootloader I'm using is LILO. So I have to specify the boot device
>> and the root device in lilo.conf. For example, boot=/dev/sda,
>> root=/dev/sda1. I'm not sure how mounting filesystem by UUID or by
>> label can help. A little bit elaboration will be more helpful.
>
> Ah I forgot that...  Looks like this requires an initrd too, though without
> special scripts of your own.

Forgive my slowness to understand your suggestion. The kernel I built
has all the sata drivers, usb drivers, and scsi layer built in. So
during the kernel bootup before the root is mounted, all drives (sata
and usb) are scanned and detected. How does an initrd plus mounting
the root filesystem by UUID or label help here? Or how can I set the
"root" in the lilo.conf?

If an initrd is used, I would rather go with option 3. That is, build
SATA drivers as loadable modules and load them in the initrd. Then
before initrd loads sata drivers, there is only one usb drive as
/dev/sda.

Also I'm lost by this comment: "though without special scripts of your
own". Could you explain it in another way? Were you saying that I need
my own special scripts to mount the root filesystem by UUID or label?
I think this is quite obvious since I need to build an initrd, which
is always customized. :-P

Thanks,
-Shawn.
