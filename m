Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0CFXPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:15:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0CFXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:15:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More PM updates for 2.6.34
Date: Sun, 7 Mar 2010 00:17:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Mark Brown <broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003070017.51319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull more power management updates for 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

There are two patches in this set.  The first one is a missing documentation
update and the second one adds generic power management callbacks for the
subsystems that only need to execute device drivers' callbacks (embedded people
requested that and I think it's going to be immediately useful to them).


 Documentation/power/runtime_pm.txt |   93 ++++++++++++++
 drivers/base/power/Makefile        |    1 +
 drivers/base/power/generic_ops.c   |  233 ++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   51 +++++++-
 include/linux/pm_runtime.h         |    6 +
 5 files changed, 378 insertions(+), 6 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM / Runtime: Document power.runtime_auto and related functions
      PM: Provide generic subsystem-level callbacks

