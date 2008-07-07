Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYGGMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYGGMN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGGMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:13:52 -0400
Received: from nn7.de ([85.214.94.156]:49032 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbYGGMNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:13:51 -0400
Subject: 2.6.26-rc9: isight firmware loading not working...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jul 2008 14:13:40 +0200
Message-Id: <1215432820.5587.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I boot up I see in dmesg

firmware: requesting isight.fw
usbcore: registered new interface driver isight_firmware

But then also on lsusb -v | grep -i isight

Bus 001 Device 003: ID 05ac:8300 Apple, Inc. Built-in iSight (no firmware loaded)
  idProduct          0x8300 Built-in iSight (no firmware loaded)

So how is this supposed to work?

Is the firmware corrupt - I freshly extracted it as was written in the source?

ll /lib/firmware/isight.fw 
-rw-r--r-- 1 root root 11K 2008-06-21 12:30 /lib/firmware/isight.fw

$ md5sum /lib/firmware/isight.fw
6d4b6764538e85ab9e7e15ed21b7a60c  /lib/firmware/isight.fw


Thanks,
Soeren
