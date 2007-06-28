Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXF1RIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXF1RIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXF1RIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:08:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:35960 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763526AbXF1RIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H5UCjXQBLuInyrO9DvuhBGsSyixbQxEP39xgdR0tTZ7kYFuYYaDw5eqsN6BPjG/Ii12xO9pjyPrZiD4jAET8zaqIAgCyBTR8YQhjMECs8H+l/hGdSJQhiep64EoK4npcmyDWZ7qpKdtfPNKUAxKfub88KAWZKZ24/TaDmXbsLKc=
Message-ID: <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
Date: Thu, 28 Jun 2007 22:38:22 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Mounting MMC card
Cc: drzeus-mmc@drzeus.cx
In-Reply-To: <4dde4acb0706281000p180d0066s11a21afe17336fb4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <4dde4acb0706281000p180d0066s11a21afe17336fb4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for resending. I dont know if my previous mail has reached the
list with "Fwd" in the subject line. I am pretty sure there must a
filter in Majordomo to discard forwards. Actually I am resending the
mail I had sent to Linux-Arm-Kernel.

Thanks.

---------- Forwarded message ----------
From: Midhun Agnihotram <agnimidhun@gmail.com>
Date: Jun 28, 2007 10:30 PM
Subject: Fwd: Mounting MMC card
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx


Hi All,

   I am new to linux kernel stuff. I am using Cogent CSB535FS board. I
have configured the kernel to include support for MMC card and also
i.MX MMC driver. When I insert the card, it says :

# imx-mmc imx-mmc.0: card inserted

   So, the kernel has identified that MMC has been inserted. I have
the following dev entries for mmc on the target:

brwxrwxrwx    1 0        0        254,   0 Jun 26  2007 mmcblk0
brwxrwxrwx    1 0        0        254,   1 Jun 26  2007 mmcblk0p0
brwxrwxrwx    1 0        0        254,   2 Jun 26  2007 mmcblk0p1
brwxrwxrwx    1 0        0        254,   3 Jun 26  2007 mmcblk0p2
brwxrwxrwx    1 0        0        254,   4 Jun 26  2007 mmcblk0p3

    How do I access the MMC card data now? If I try to mount it,
busybox doesnot mount it.

# mount /dev/mmcblk0p0 /mnt/mmc
mount: mounting /dev/mmcblk0p0 on /mnt/mmc failed

  I have tried with /dev/mmcblk0p0, mmcblk0p1,etc. But of no use. How
do I access the contents of MMC card? Is there any thing missing in my
settings? Busybox does not say anything other than the above error
message.

Any clue will be appreciated,
Thanks,
Midhun.
