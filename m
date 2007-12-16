Return-Path: <linux-kernel-owner+w=401wt.eu-S1764346AbXLPAVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764346AbXLPAVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763451AbXLPAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:21:31 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:20061 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbXLPAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Lfn/SzO5SI0ms7Qnu10lpqqZVgQ/trvUKO5bD007hOVKaBoZUqtt6DxAsqCTJOe7TRYr0UdoWapvgKffNUOaYUrCHcFkRMCvJJA8vS/r+UbO9VkfiaIDaut/B8Fpjgv+WcJcK0IYBkyAmw7Y2MPqEM68EXdUrXp01LqXftNjCOI=
Message-ID: <8b67d60712151621m6dbd3e14sbcaf4b5c0de61097@mail.gmail.com>
Date: Sun, 16 Dec 2007 00:21:28 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>,
       axboe@kernel.dk, linux-ide@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 3/3] Add GD-Rom support to the SEGA Dreamcast
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -ruN ./linux-2.6-orig/drivers/sh/Makefile ./linux-2.6/drivers/sh/Makefile
--- ./linux-2.6-orig/drivers/sh/Makefile	2007-12-15 22:23:59.000000000 +0000
+++ ./linux-2.6/drivers/sh/Makefile	2007-12-15 22:18:45.000000000 +0000
@@ -4,3 +4,4 @@

 obj-$(CONFIG_SUPERHYWAY)	+= superhyway/
 obj-$(CONFIG_MAPLE)		+= maple/
+obj-$(CONFIG_GDROM)		+= gdrom/
