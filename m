Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZDTA4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZDTA4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZDTA41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:56:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZDTA4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:56:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM update for 2.6.30
Date: Mon, 20 Apr 2009 02:56:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <alpine.LFD.2.00.0904191357280.12867@localhost.localdomain> <20090419200330.GA16002@flint.arm.linux.org.uk>
In-Reply-To: <20090419200330.GA16002@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904200256.17028.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management update for 2.6.30 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

This fixes the ARM breakage caused by the recent reordering of suspend code.

 drivers/acpi/sleep.c    |    8 ++++----
 include/linux/suspend.h |   36 ++++++++++++++++++++++++++----------
 kernel/power/main.c     |   24 +++++++++++++++++-------
 3 files changed, 47 insertions(+), 21 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM/Suspend: Introduce two new platform callbacks to avoid breakage


Thanks,
Rafael

