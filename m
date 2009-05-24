Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZEXVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZEXVCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZEXVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:02:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZEXVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:02:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM regression fix for 2.6.30
Date: Sun, 24 May 2009 23:02:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905242302.16688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management fix for 2.6.30 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

This fixes the regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=13245

 drivers/base/power/main.c |    4 ++++
 kernel/kexec.c            |    2 --
 kernel/power/disk.c       |   21 +++------------------
 kernel/power/main.c       |    7 +------
 4 files changed, 8 insertions(+), 26 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM: Do not hold dpm_list_mtx while disabling/enabling nonboot CPUs

Thanks,
Rafael
