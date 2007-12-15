Return-Path: <linux-kernel-owner+w=401wt.eu-S1764462AbXLOENS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764462AbXLOENS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXLOENJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:13:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43670 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbXLOENI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=X8rWYOinYVuLRhqjHkDyAwdFIB0GSkyupjdHVXcqC2cJXFnu+/0inDfhAtYQvZLwlEOHxQL48yAjmNdx6tKZmFLTfzK0SDGe5F16GrtdmQoyTforQJkQkxGuVat8CkvTQgayR6PNdjzhcTEMn2c7IE+ev5mhWki5xX/CI8iuywA=
Message-ID: <f17812d70712142013t35476cb0h4e4ff1f0b41dd05e@mail.gmail.com>
Date: Sat, 15 Dec 2007 12:13:07 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: [PATCH 2.6.24-rc5-mm 0/3] gpiolib: add support for NXP/TI PCA9539
Cc: "David Brownell" <david-b@pacbell.net>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Ben Gardner" <bgardner@wabtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[updated] support for PCA9539 as a GPIO chip is separated into three patches:

0001 - gpiolib: basic support for 16-bit PCA9539 GPIO expander
0002 - gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
0003 - gpiolib: obsolete drivers/i2c/chips/pca9539.c

The 2nd one uses workqueue for IRQ handling due to the interrupt mode
nature of the i2c-core, thus making it a separate patch.

-- 
Cheers
- eric
