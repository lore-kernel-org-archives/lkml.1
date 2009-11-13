Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZKMHgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZKMHgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZKMHgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:36:47 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:50431 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZKMHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qZjmMfNjkf+P5WsNxCz8VZ5eVw5wuSLw61r96q3JiA3JN6vDqF/YafKTdd2zQ8wDt7
         MynsCY/BvJRaa7ZbOyzIJReWK3lqdP7wkuWm6iReSyLl6kE5inPTqPKProUMnHK6QNnD
         2Hyh2muDqEKt7+KrngnsE2hcVMJDXnKrlItTA=
Date: Thu, 12 Nov 2009 23:36:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc7
Message-ID: <20091113073647.GA7783@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Torokhov (3):
      Input: fix locking in memoryless force-feedback devices
      Input: force LED reset on resume
      Input: atkbd - restore LED state at reconnect

Takashi Iwai (1):
      Input: psmouse - remove unneeded '\n' from psmouse.proto parameter

Diffstat:
--------

 drivers/input/ff-core.c            |   20 +++++++++++---------
 drivers/input/ff-memless.c         |   26 +++++++++++---------------
 drivers/input/input.c              |   29 ++++++++++++++++++-----------
 drivers/input/keyboard/atkbd.c     |   13 +++++++++++++
 drivers/input/mouse/psmouse-base.c |    2 +-
 include/linux/input.h              |    4 ++++
 6 files changed, 58 insertions(+), 36 deletions(-)

-- 
Dmitry

