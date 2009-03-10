Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZCJQGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZCJQGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZCJQE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:04:57 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:45960 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbZCJQE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=PdMGfWVNNiCwL9HHIosqXCxu1D0Rn7ULvx4xn4YlrEkXBp+T88el7NvCQ2lMgRw0Qk
         eG2i/fAHcJhzC6gOc7uY4aJrCwWkuyPvLPThjzRQ8U5fTpVsppVomutHVqPArrStAbzU
         3GWhr/wv0Pg9c/Rucm9jNETNm1Yt7KXcqB4J8=
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 21:34:53 +0530
Message-ID: <8d99bcec0903100904q688bd823w5e40077d0b8fa82e@mail.gmail.com>
Subject: libertas sdio wlan not working.
From: SARDAR SHARIFF <sardar.mohd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using Linux 2.6.28. Im using marvell SD8686 wlan chip.

I downloaded the firmwares from marvell site.

I do the following:


# insmod libertas.ko libertas_debug=0x5063a7
# libertas_sdio helper_name=helper_sd.bin fw_name=sd8686.bin
libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
libertas_sdio mmc0:0001:1: firmware: requesting helper_sd.bin

libertas: can't load helper firmware
libertas: failed to load helper firmware
libertas_sdio: probe of mmc0:0001:1 failed with error -2

When i do dmesg, i get the following:

libertas enter: lbs_init_module()
libertas leave: lbs_init_module()
libertas enter: if_sdio_init_module()
libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
libertas enter: if_sdio_probe()
libertas sdio: overriding helper firmware: helper_sd.bin
libertas sdio: overriding firmware: sd8686.bin
libertas sdio: class = 0x7, vendor = 0x2DF, device = 0x9103, model =
0xB, ioport = 0x10000
libertas enter: if_sdio_prog_firmware()
libertas enter: if_sdio_prog_helper()
libertas_sdio mmc0:0001:1: firmware: requesting helper_sd.bin
libertas: can't load helper firmware
libertas: failed to load helper firmware
libertas leave: if_sdio_prog_helper(), ret -2
libertas leave: if_sdio_prog_firmware(), ret -2
libertas leave: if_sdio_probe(), ret -2
libertas_sdio: probe of mmc0:0001:1 failed with error -2
libertas leave: if_sdio_init_module(), ret 0

What could be wrong?.

I also tried copying the firware files to /lib/firmware. but it didnot help.

Please advice �
