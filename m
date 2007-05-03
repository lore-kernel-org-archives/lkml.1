Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXECUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXECUIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXECUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:08:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:11832 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXECUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j1bum23TeVAS36RaPc3Is6ybAFLnNGABAJPERa2oRZ2eA0XhugKNHfGaQBTAqDrJVDArl0SHERjmEvKGD6WuOk3HvSQ7bt3vfYeGtjBDZxt67vmDu30DjEvW/WMo2oqNhB12Gtc2UCMNyWXHyf1vYz9xVegbfKIqKQGw/rBT4Nk=
Message-ID: <3634de740705031308t1dd2bc45r3d906d49a6dde6bf@mail.gmail.com>
Date: Fri, 4 May 2007 01:38:47 +0530
From: Maximus <john.maximus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: MTD - Linux Nand Driver problems
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  Im using Linux Kernel 2.6.18.
  Im using a large nand page device.

  In my device nand starts from 0x80000 offset of nand.
  My kernel is around 1MB, I have allocated 2 MB space in my mtd
partition structure.
  Similarly My Filesystem starts from 0x280000 offset of nand.

  MY erase block size is 0x20000 (128 KB)

   mkfs.jffs2 -p -l --eraseblock=128KiB -n -v -r ./rootfs -o /tmp/rootfs.jffs2

   When boot my system i get hundreds of messages like:


  Empty flash at 0x02327ffc ends at 0x02328000
Empty flash at 0x0232fffc ends at 0x02330000
Empty flash at 0x02337ffc ends at 0x02338000
Empty flash at 0x02347ffc ends at 0x02348000
Empty flash at 0x0234fffc ends at 0x02350000
Empty flash at 0x02357ffc ends at 0x02358000
Empty flash at 0x02367ffc ends at 0x02368000
Empty flash at 0x0236fffc ends at 0x02370000
Empty flash at 0x02377ffc ends at 0x02378000
Empty flash at 0x0238fffc ends at 0x02390000
Empty flash at 0x023a7ffc ends at 0x023a8000
Empty flash at 0x023cfffc ends at 0x023d0000
Empty flash at 0x023f7ffc ends at 0x023f8000
Empty flash at 0x02407ffc ends at 0x02408000
Empty flash at 0x02417ffc ends at 0x02418000
Empty flash at 0x0242fffc ends at 0x02430000
Empty flash at 0x02447ffc ends at 0x02448000
Empty flash at 0x02477ffc ends at 0x02478000
Empty flash at 0x024a7ffc ends at 0x024a8000
Empty flash at 0x02527ffc ends at 0x02528000
Empty flash at 0x0252ffac ends at 0x02530000
Empty flash at 0x02531abc ends at 0x02532000


I know the flash is empty - How does one prevent these messages at boot time.


Regards,
Jo
