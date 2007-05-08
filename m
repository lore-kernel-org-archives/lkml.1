Return-Path: <linux-kernel-owner+w=401wt.eu-S968101AbXEHOG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968101AbXEHOG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968096AbXEHOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:06:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48465 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968077AbXEHOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:06:53 -0400
Date: Tue, 8 May 2007 07:04:28 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070508140428.GA12641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another round of the updated UIO (Userspace I/O driver framework)
patches for 2.6.21.

All of the issues raised from the last time the patches were posted
(last week) have been fixed in this version.

Many thanks for all of the review comments from everyone who took the
time to read over the code.

These patches include full documentation, are self-contained from the
rest of the kernel, and have been in the -mm tree for the past few
months with no complaints.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/uio-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h



 Documentation/DocBook/kernel-api.tmpl |    4 
 Documentation/DocBook/uio-howto.tmpl  |  611 +++++++++++++++++++++++++++++
 drivers/Kconfig                       |    1 
 drivers/Makefile                      |    1 
 drivers/uio/Kconfig                   |   27 +
 drivers/uio/Makefile                  |    2 
 drivers/uio/uio.c                     |  701 ++++++++++++++++++++++++++++++++++
 drivers/uio/uio_cif.c                 |  156 +++++++
 include/linux/uio_driver.h            |   91 ++++
 9 files changed, 1594 insertions(+)

---------------

Hans J. Koch (2):
      UIO: Add the User IO core code
      UIO: Documentation

Hans-Jürgen Koch (1):
      UIO: Hilscher CIF card driver

