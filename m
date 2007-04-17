Return-Path: <linux-kernel-owner+w=401wt.eu-S1031086AbXDQEgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031086AbXDQEgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031088AbXDQEgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:36:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:18519 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031086AbXDQEgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=N5TUoi57Xyz20gm6REMCdEfspXVUP1XtsDRGercLiUNuJa0+a8wVkzBlTwYaZOlhhf2V4NY6FhJZVPG0gyg+HDE7eM8Wt5UWBvEW0q3OL6o41W5zWoGQFEgtnYlY9HdL/7KduYl5glWVS+2bEOnm6Q5p6hMRS9iQiR594Bt4I4g=
Organization: Organization? Not detectable
To: lkml <linux-kernel@vger.kernel.org>, Alain.Knaff@poboxes.com
Subject: floppy.ko
Date: Tue, 17 Apr 2007 00:35:52 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170036.00605.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings everybody;

At some point in the last, say 6 months or so, some patches have been done to 
the floppy.c area of the tree, and ever since, I have not been able to build 
the driver in without wasting around a minute during the bootup with lags and 
squawks about fd1 showing up in the boot trace on screen, but if I go look, 
its fd0 that's being pounded on by the driver, mainly bitching about not 
being able to read the first sector, something it repeats several times, like 
4 or 5.

I have the usual fd0, a 3.5" 1.44 drive, and fd1, a 5.25" 720k drive in this 
machine, both are enabled in the bios with the correct types being set there.

If I insert a disk, and attempt to mount it, the correct lights come on 
according to what I typed, but I have had a hell of a time trying to get it 
to write good images of a legacy machines disk format using dd, from files 
that I can read with khexedit, and I know are correct from that inspection.

The only use its getting these days is in the coco/os9 formats, read and 
written only by dd and some specialty tools from an os9 kit called toolshed, 
AFAIK.

Built as a module, then modprobed for use, I don't recall seeing this problem.

Is this fixable, or is it that I just don't know how to handle this newer 
code?

The currently running kernel, 2.6.21-rc7-CFS-v2 has it built in and it gave me 
static while booting with no disk in either drive.  Naming fd1, while banging 
on fd0 according to the access leds on the drives.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Nobody wants constructive criticism.  It's all we can do to put up with
constructive praise.
