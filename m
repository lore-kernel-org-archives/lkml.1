Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbXHRKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbXHRKdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXHRKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:33:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:34864 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXHRKdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:33:39 -0400
Message-ID: <46C6CAFC.1020709@m3y3r.de>
Date: Sat, 18 Aug 2007 12:33:32 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: contact@i-nz.net
Subject: Master volume control broken (regression against 2.6.22)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This commit broke my master volume control:

5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 is first bad commit
commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
Author: Ivan N. Zlatev <contact@i-nz.net>
Date:   Tue May 29 16:03:00 2007 +0200

    [ALSA] hda-codec - Fix pin configs for Intel Macs

    * adds the pinconfigs for all 5 Apple boards and 14 Subsystem IDs
      (support for possibly all iMac, Mac, MacMini etc etc)
    * adds 'intel-mac-v1' to v5 models which replace the current
    * reflects changes in Alsa-Configuration.txt

    Signed-off-by: Ivan N. Zlatev <contact@i-nz.net>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Jaroslav Kysela <perex@suse.cz>

:040000 040000 16c8f8d66545ab0cb6dfc44f3c92ff9ad0b53658
e3e9a07b1a3a0d68c6870f7a111ca817a89ce24b M      Documentation
:040000 040000 b49d5f64d27e248f08d6fad8b1ff4f03c182f46a
b4a361b5cacc96d139572b592bbcba3504c1f9c5 M      sound

I no longer can use my fancy multimedia control keys :-(

mfg
thomas


