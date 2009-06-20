Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZFTCBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZFTCBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 22:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZFTCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 22:00:54 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:38816 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZFTCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 22:00:53 -0400
X-Greylist: delayed 18351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 22:00:53 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SC3qmAkD45AydvtXqKXg7Fb3M7ZnjwVkjYEbzTuQb8+nqGFaVf9TmyoQxLpoLMcSt3
         ZF4TzrSdd5K0+iMbVuJspSJH+jsao7bXQOca2KRmsxMxVCSsuBf675Se/chf6Q55J4+q
         cOxPUTQIoX8AykJh6BZuzbJa8D/TZm+VgO2v8=
MIME-Version: 1.0
Date: Sat, 20 Jun 2009 02:00:55 +0000
Message-ID: <dd18b0c30906191900r6cd8dcfbl2307ec3aa9e8c84@mail.gmail.com>
Subject: Platform driver 'applesmc' needs updating - please use dev_pm_ops
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with kernel
2.6.30 (tar.ball)
applesmc looks like this:

[    3.083478] applesmc: Apple MacBook Pro detected:
[    3.092377] applesmc:  - Model with accelerometer
[    3.101740] applesmc:  - Model with light sensors and backlight
[    3.111123] applesmc:  - Model with 12 temperature sensors
[    3.172619] applesmc: device successfully initialized (0xe0, 0x00).
[    3.172621] applesmc: device successfully initialized.
[    3.182376] applesmc: 2 fans found.
[    3.192830] input: applesmc as /devices/platform/applesmc.768/input/input1
[    3.202148] Registered led device: smc::kbd_backlight
[    3.211396] applesmc: driver successfully loaded.


with the latest git
2.6.30-06553-g65795ef
applesmc looks like this:

[    2.918010] applesmc: Apple MacBook Pro detected:
[    2.926610] applesmc:  - Model with accelerometer
[    2.935664] applesmc:  - Model with light sensors and backlight
[    2.935666] applesmc:  - Model with 12 temperature sensors
[    2.935670] Platform driver 'applesmc' needs updating - please use dev_pm_ops
[    3.015615] applesmc: device successfully initialized (0xe0, 0x00).
[    3.015618] applesmc: device successfully initialized.
[    3.025389] applesmc: 2 fans found.
[    3.035818] input: applesmc as /devices/platform/applesmc.768/input/input1
[    3.045192] Registered led device: smc::kbd_backlight
[    3.054586] applesmc: driver successfully loaded.

As for any anomolies, or the system
crashing and burning(no seems O.K.)
just needs applesmc to be using
dev_pm_ops wherever that may be.

-- 
Justin P. Mattock
