Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbZJ3WJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbZJ3WJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbZJ3WJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:09:56 -0400
Received: from kroah.org ([198.145.64.141]:48367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbZJ3WJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:09:52 -0400
Date: Fri, 30 Oct 2009 15:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bugfixes for 2.6.32-git
Message-ID: <20091030220944.GC11297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bugfixes for your 2.6.32-git tree.

These fix:
	- sierra driver suspend issues.
	- new device ids.
	- oops fixes for reported problems.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/net/usb/rndis_host.c      |    6 ++--
 drivers/usb/gadget/fsl_udc_core.c |    2 +-
 drivers/usb/host/r8a66597-hcd.c   |   23 ++++++++++++---------
 drivers/usb/serial/option.c       |    4 +++
 drivers/usb/serial/sierra.c       |   38 +++++++++++++++++++++---------------
 5 files changed, 43 insertions(+), 30 deletions(-)

---------------

Anton Vorontsov (1):
      USB: fsl_udc_core: Fix kernel oops on module removal

Bryan Wu (1):
      USB: option: TLAYTECH TUE800 support

Elina Pasheva (2):
      USB: serial: sierra driver send_setup() autopm fix
      USB: serial: sierra driver autopm fixes

George Nassar (1):
      USB: rndis_host: debug info clobbered before it is logged

Yoshihiro Shimoda (1):
      USB: r8a66597-hcd: fix cannot detect a device when uses_new_polling is set

