Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYHSQYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYHSQYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYHSQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:23:43 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:49756 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYHSQXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pe8ql3zEncZLhGZiYTD/9ilS8cBfX3IP0raEhShsPfiBQ87eMzjr8UMh4pY1Or0bNO
         LVjO6RYUBfUr8VRECVIbX3qVa197YbBSS+IkXsoDzTBpFjFkma5v3nmkO9X0x6S8cY4I
         l14iujLmZ/ZA7RYLi+OM0/GIesZtJKQtWsjYY=
Date: Tue, 19 Aug 2008 12:23:37 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc3 (part 2)
Message-ID: <20080819162337.GB21069@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

Geert Uytterhoeven (1):
      Input: evdev - fix printf() format for sizeof

Huang Weiyi (1):
      Input: remove version.h from drivers that don't need it

Martin Michlmayr (1):
      Input: cobalt_btns - add missing MODULE_LICENSE


Diffstat:
--------

 drivers/input/evdev.c                   |    4 ++--
 drivers/input/keyboard/gpio_keys.c      |    1 -
 drivers/input/misc/cobalt_btns.c        |    3 +++
 drivers/input/mouse/gpio_mouse.c        |    1 -
 drivers/input/tablet/gtco.c             |    1 -
 drivers/input/touchscreen/wm9705.c      |    1 -
 drivers/input/touchscreen/wm9712.c      |    1 -
 drivers/input/touchscreen/wm9713.c      |    1 -
 drivers/input/touchscreen/wm97xx-core.c |    1 -
 9 files changed, 5 insertions(+), 9 deletions(-)

-- 
Dmitry
