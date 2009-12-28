Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZL1ILa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZL1ILa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZL1IL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:11:29 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63492 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZL1IL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fEx3gFZA1dbflgDidlK/YHBybpgYDtKDv87Mr/a2K/lSRT5o7+tCbFG/ywDniaPfj1
         Qf2dmFQUH8B3RiWVmEmLCI7dXTWIIxK/blBCcoGQQs/ZTKtmKOlIMx6Z5TSI+michXeN
         TdkwLBvl8W+pE487NEdf7CfDAsXe1e0ZI0/eI=
MIME-Version: 1.0
Date: Mon, 28 Dec 2009 17:11:27 +0900
Message-ID: <aec7e5c30912280011j4e8528e5r34bc1bcfb6a4dd1a@mail.gmail.com>
Subject: v2.6.33-rc2 build error - missing tmio mmc patches
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ian Molton <ian@mnementh.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

v2.6.33-rc2 does not build in the case of CONFIG_MFD_SH_MOBILE_SDHI=y.
Linux-next used to build just fine when I developed the driver, but
now it looks like some tmio-mmc patches present in linux-next never
made it into -rc.

  CC      drivers/mfd/sh_mobile_sdhi.o
drivers/mfd/sh_mobile_sdhi.c: In function 'sh_mobile_sdhi_probe':
drivers/mfd/sh_mobile_sdhi.c:100: error: 'struct tmio_mmc_data' has no
member named 'set_pwr'
make[2]: *** [drivers/mfd/sh_mobile_sdhi.o] Error 1

In more detail, the missing patch is here:
http://git.mnementh.co.uk/cgi-bin/gitweb.cgi?p=linux-2.6-im.git;a=commitdiff;h=4cd83bd05e6c817a4a72ababd82bf5ae700c021d

What needs to be done to get the patch above included in rc3? Is there
anything I can do?

Thanks,

/ magnus
