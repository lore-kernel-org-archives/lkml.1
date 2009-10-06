Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZJFClp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZJFClp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZJFClo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:41:44 -0400
Received: from galiil.marvell.com ([199.203.130.254]:4046 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbZJFCln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:41:43 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 22:41:43 EDT
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Samuel Ortiz <sameo@openedhand.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 5 Oct 2009 19:35:05 -0700
Subject: RE: linux-next: mfd tree build failure
Thread-Topic: linux-next: mfd tree build failure
Thread-Index: AcpGKQbTj7vCcYSETyavT4jwDOGOgQABFznQ
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04B6A3794F@SC-VEXCH1.marvell.com>
References: <20091006130202.5e18a332.sfr@canb.auug.org.au>
In-Reply-To: <20091006130202.5e18a332.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n962k016006959

Hi Stephen,

Could you send your .config file to me? The 88pm8607 patch is just for mfd-2.6 git tree. I didn't try it in linux-next git tree before. I can try it now. If I could have your .config file, it would be better.

Thanks
Haojian

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: 2009Äê10ÔÂ6ÈÕ 10:02 AM
To: Samuel Ortiz
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Haojian Zhuang; Mark Brown
Subject: linux-next: mfd tree build failure

Hi Samuel,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/built-in.o: In function `pm8607_write_device':
88pm8607.c:(.text+0xd02e9): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `pm8607_read_device':
88pm8607.c:(.text+0xd033b): undefined reference to `i2c_master_send'
88pm8607.c:(.text+0xd035c): undefined reference to `i2c_master_recv'
drivers/built-in.o: In function `pm8607_init':
88pm8607.c:(.init.text+0xa9bd): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `pm8607_probe':
88pm8607.c:(.devinit.text+0x4db6): undefined reference to `mfd_add_devices'
drivers/built-in.o: In function `pm8607_exit':
88pm8607.c:(.exit.text+0x598): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `pm8607_remove':
88pm8607.c:(.devexit.text+0x198): undefined reference to `mfd_remove_devices'

Obviously caused by commit 9ec6cd8f2235ddeee5b39068956f14238a12a617
("mfd: Add 88PM8607 driver").

This build has CONFIG_I2C=m and CONFIG_MFD_CORE=m.

I have used the version of the mfd tree form next-20091005 for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
