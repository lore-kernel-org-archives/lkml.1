Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXGIJ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXGIJ1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXGIJ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:27:46 -0400
Received: from wapgw.hccnet.nl ([62.251.0.19]:41804 "EHLO wapgw.hccnet.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXGIJ1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:27:46 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 05:27:45 EDT
Message-ID: <4691F8D6.30600@hccnet.nl>
Date: Mon, 09 Jul 2007 10:59:02 +0200
From: Gert Vervoort <gert.vervoort@hccnet.nl>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22: dvb header files break compilation on x86-64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some of the linux/dvb header files include libc header files and break compilation on x86-64 in compat_ioctl.c:


   CC      fs/timerfd.o
   CC      fs/eventfd.o
   CC      fs/compat.o
   CC      fs/compat_ioctl.o
In file included from fs/compat_ioctl.c:111:
include/linux/dvb/audio.h:27:20: error: stdint.h: No such file or directory
In file included from fs/compat_ioctl.c:112:
include/linux/dvb/dmx.h:28:18: error: time.h: No such file or directory
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2
[root@apollo linux-2.6.x]#


    Gert


