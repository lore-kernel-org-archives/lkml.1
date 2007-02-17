Return-Path: <linux-kernel-owner+w=401wt.eu-S1946742AbXBQN4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946742AbXBQN4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946744AbXBQN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:56:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60442 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946742AbXBQN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:56:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Feb 2007 14:55:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 updates post 2.6.20, another round
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.792fbaf365daed11@s5r6.in-berlin.de>
Message-ID: <tkrat.b2b116c1f23637be@s5r6.in-berlin.de>
References: <tkrat.792fbaf365daed11@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
or
    git://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive IEEE 1394 subsystem updates as listed further below. It's a
small userspace API addition submitted two weeks ago and an unintrusive
one week old bugfix. (The fixed code was and will be untangled further
in linux1394-2.6.git's master branch and in -mm.)

 drivers/ieee1394/ieee1394-ioctl.h |    2 +
 drivers/ieee1394/ieee1394_core.c  |   43 +++++++++++++++++++++++++++++++++++++
 drivers/ieee1394/ieee1394_core.h  |    3 ++
 drivers/ieee1394/nodemgr.c        |    3 +-
 drivers/ieee1394/raw1394.c        |   20 +++++++++++++++++
 drivers/ieee1394/raw1394.h        |   10 ++++++++
 6 files changed, 80 insertions(+), 1 deletions(-)

Pieter Palmers (1):
      ieee1394: cycle timer read extension for raw1394

Stefan Richter (1):
      ieee1394: fix another deadlock in nodemgr
-- 
Stefan Richter
-=====-=-=== --=- =---=
http://arcgraph.de/sr/

