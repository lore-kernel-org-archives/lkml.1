Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYI1MPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYI1MPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 08:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYI1MPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 08:15:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1096 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYI1MPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 08:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=geeCCiNasiKz35PQixkfTLEe09O3FkXJ4tJDLUuVuAlG6QyMRMOM9mQhXNxUk1Gg1f
         IuCp1iru2R5v4arK5SH8AdfpsnDCiVj7DT/ejMGKPL7aqPDg30YS3JuVM+0noDIJSHcM
         VZC4ouQjA1rOgt/kcQoQzIwJ776dk46l4HME4=
Message-ID: <e68bb3470809280515v2079e787yf190af69ea1be3ab@mail.gmail.com>
Date: Sun, 28 Sep 2008 20:15:10 +0800
From: vincen <mcuos.com@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PATCH linux-2.6.27-rc7-git5]ARM:Add the Nuvoton w90P910 Platform support to LINUX-ARM tree
Cc: torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vincen.zswan mcuos.com@gmail.com

Dear sir,
I have add the Nuvoton ARM series IC W90P910 Platform support to LINUX
ARM tree and make a patch named patch-2.6.27-rc7-git5-w90p910.patch.

As the file size 177kb,so you can get the patch file from link:

http://www.mcuos.com/attachment.php?aid=583

If the patch file is not accepted by Linux, please give some advice ,
I need to modify it better.thanks!

Only add the mach-w90x900 directory to /linux/arch/arm and modify
Makefile and Kconfig.
Now,The Platform code support only uart driver and add the
w90p910_serial.c to /driver/serial and  modify Makefile and Kconfig.

The Platform default config in arch/arm/configs/w90p910_defconfig

Changes:
patching file arch/arm/Kconfig
patching file arch/arm/Makefile
patching file arch/arm/configs/w90p910_defconfig

patching file arch/arm/mach-w90x900

patching file arch/arm/mm/Kconfig
patching file drivers/serial/Kconfig
patching file drivers/serial/Makefile
patching file drivers/serial/w90x900_serial.c
patching file include/linux/serial_core.h

-- 
Vincen
Signed-off-by: vincen.zswan <mcuos.com@gmail.com>
