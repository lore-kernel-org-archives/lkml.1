Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZAIDyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZAIDyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 22:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZAIDxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 22:53:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:5998 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZAIDxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 22:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JXkQYUQnQ/vnAbC3VQin0wX8a24+hKDg4Afh6C/++ncmNlF786Rwir0z5x3RLQlHTl
         o7POwEiu53P8ZZloZZQ0wkdEWVBs5gqwHAjdJrFFACtLuRvzMeiv5WiHpO9V60oRL7Ri
         QGIePsAbeiveW+gOKapEBghh6biZ7pf6xkguw=
Message-ID: <a0e7fce50901081953h7ae152a7y557794c07fbb843b@mail.gmail.com>
Date: Fri, 9 Jan 2009 11:53:52 +0800
From: "yi li" <liyi.dev@gmail.com>
To: drzeus-mmc@drzeus.cx
Subject: [BUG] MMC/SD: SDHC card capacity not correct
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I am using a Transcend SDHC 8GB SD card, with mmc-spi driver in
Linux-2.6.28. When inserting the card, the messages shows the card
capacity is "3.51 GiB":
"mmc0: new SDHC card on SPI
mmcblk0: mmc0:0000 SDC   3.51 GiB
 mmcblk0: p1  "

While fdisk shows correct capacity:
" fdisk -l /dev/mmcblk0
Disk /dev/mmcblk0: 8068 MB, 8068268032 bytes
249 heads, 62 sectors/track, 1020 cylinders
Units = cylinders of 15438 * 512 = 7904256 bytes

        Device Boot      Start         End      Blocks  Id System
/dev/mmcblk0p1               1        1020     7873349  83 Linux
"
So I think there are something wrong with mmc-block code.

Could you please have a look? (I am not on the LKML btw).

Best Regards,
- Li Yi
