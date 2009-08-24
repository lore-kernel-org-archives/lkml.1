Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZHXGkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZHXGkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZHXGkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:40:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:53180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZHXGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=l/2JWuHy2uZAWSoWoExhn7g+1S6hPQ3zd++tkINW+hhTq3RPTt8cXshAd1+p+F++P5
         zboNqwEec8Yac/DayPO0SwdZua58ahvlKwIJHnPZZcIXesirzFUYX00LbjZ11AsPwjls
         cg5K83Qo66BALQenNapuO6JH5Wc9Mg/hmDtc8=
Date: Sun, 23 Aug 2009 23:40:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc7
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090824071200.31D67526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The joydev change fixes
userspace ABI breakage caused by recent KEY_MAX change; there are also
couple of fixes for the ucb1400_ts driver and a fix for wacom to not
use on-stack buffers for transfers during initialization.

Changelog:
---------

Dmitry Torokhov (1):
      Input: wacom - don't use on-stack memory for report buffers

Jiri Kosina (1):
      Input: iforce - support new revision of ACT LABS Force RS

Marek Vasut (1):
      Input: ucb1400_ts - enable ADC Filter

Pavel Revak (1):
      Input: ucb1400_ts - enable interrupt unconditionally

Stephen Kitt (1):
      Input: joydev - decouple axis and button map ioctls from input constants


Diffstat:
--------

 drivers/input/joydev.c                      |   68 ++++++++++++++++-----------
 drivers/input/joystick/iforce/iforce-main.c |    1 +
 drivers/input/joystick/iforce/iforce-usb.c  |    1 +
 drivers/input/tablet/wacom_sys.c            |   43 +++++++++++------
 drivers/input/touchscreen/ucb1400_ts.c      |   17 +++++--
 include/linux/ucb1400.h                     |    4 ++
 6 files changed, 89 insertions(+), 45 deletions(-)

-- 
Dmitry

