Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZHTFeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZHTFeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZHTFeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:34:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:17972 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZHTFeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=Nil+NqsqU/qBJmVHLV0FUpFyQh3IvcoUupVtJqZEv6r7pk+Om1U3zQtqguUzKf8mQ6
         tA7aZrVo6MVU93XUI4mieZA7WVM4+IRadzJmpHu7t0zYccaGzKuB9eGrXgXWsVXfwsQb
         yDvpF5Y/NhdctRtzlXWMi+0Dk4oYpWqPDujN0=
Date: Wed, 19 Aug 2009 22:34:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090820060542.8B7A5526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The joydev change fixes userspace
ABI breakage caused by recent KEY_MAX change.

Changelog:
---------

Jiri Kosina (1):
      Input: iforce - support new revision of ACT LABS Force RS

Stephen Kitt (1):
      Input: joydev - decouple axis and button map ioctls from input constants


Diffstat:
--------

 drivers/input/joydev.c                      |   68 ++++++++++++++++-----------
 drivers/input/joystick/iforce/iforce-main.c |    1 +
 drivers/input/joystick/iforce/iforce-usb.c  |    1 +
 3 files changed, 43 insertions(+), 27 deletions(-)

-- 
Dmitry

