Return-Path: <linux-kernel-owner+w=401wt.eu-S969182AbXG3WJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969182AbXG3WJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968939AbXG3WJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:09:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968884AbXG3WJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:09:22 -0400
Date: Mon, 30 Jul 2007 15:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.23-rc1
Message-ID: <20070730220829.GB5263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core fixes and documentation updates against your
2.6.23-rc1 git tree.

They fix the CONFIG_HOTPLUG=n build error and help provide a better hint
at what is going wrong when loading modules cause sysfs errors.  And
there are a bunch of documentation updates in here too, as well as a
driver model fix that causes some people problems with the input
subsystem.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/ja_JP/HOWTO                   |   66 +++++-----
 Documentation/ja_JP/stable_api_nonsense.txt |   20 ++--
 Documentation/kobject.txt                   |  178 +++++++++------------------
 Documentation/stable_api_nonsense.txt       |    2 +-
 Documentation/sysfs-rules.txt               |   72 +++++------
 drivers/base/core.c                         |    5 +-
 drivers/base/firmware_class.c               |    1 +
 drivers/pci/pci.c                           |    2 +-
 include/linux/kobject.h                     |   26 ++--
 kernel/params.c                             |    7 +-
 lib/kobject_uevent.c                        |   16 ++--
 11 files changed, 171 insertions(+), 224 deletions(-)

---------------

Cornelia Huck (3):
      kobject: fix link error when CONFIG_HOTPLUG is disabled
      driver core: revert "device" link creation check
      kobject: update documentation

Greg Kroah-Hartman (2):
      kobject: put kobject_actions in kobject.h
      modules: better error messages when modules fail to load due to a sysfs problem.

IKEDA, Munehiro (1):
      HOWTO: adjust translation header of Japanese stable_api_nonsense.txt

Juan Lang (1):
      stable_api_nonsense.txt: Disambiguate the use of "this" by using "that" to refer to the syscall interface

Randy Dunlap (3):
      kernel-doc fixes for PCI and drivers/base/
      Fix Doc/sysfs-rules typos
      kset: kernel-doc cleanups

Tsugikazu Shibata (1):
      HOWTO: sync Japanese HOWTO

