Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbXLWHZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbXLWHZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbXLWHZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:25:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39198 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXLWHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:25:29 -0500
Date: Sat, 22 Dec 2007 23:24:24 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fix for 2.6.24-rc6
Message-ID: <20071223072424.GB8764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one bugfix for a memory leak for every module that is unloaded
from the system due to the change in the kobject name code against your
2.6.24-rc6 tree.

And an entry for MAINTAINERS for the UIO subsystem so the proper people
get the blame :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 MAINTAINERS     |    8 ++++++++
 kernel/params.c |   10 ++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Modules: fix memory leak of module names

Hans-Jürgen Koch (1):
      UIO: Add a MAINTAINERS entry for Userspace I/O

