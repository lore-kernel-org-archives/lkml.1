Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZIOKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZIOKo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZIOKoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:44:23 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:57176 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZIOKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:44:22 -0400
Message-ID: <4AAF6F8F.8050108@csr.com>
Date: Tue, 15 Sep 2009 11:42:23 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB bug fixes for 2.6.32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Sep 2009 10:42:24.0220 (UTC) FILETIME=[35F639C0:01CA35F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please merge these bug fixes for the UWB subsystem,

The following changes since commit 7c0a57d5c47bcfc492b3139e77400f888a935c44:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.marvell.com/orion

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David Vrabel (3):
      uwb: handle radio controller events with out-of-range IDs correctly
      uwb: stop uwbd thread if rc->start() fails
      uwb: avoid radio controller reset loops

 drivers/uwb/hwa-rc.c  |    3 +--
 drivers/uwb/lc-rc.c   |    2 +-
 drivers/uwb/reset.c   |   21 +++++++++++----------
 drivers/uwb/umc-bus.c |    2 +-
 drivers/uwb/uwbd.c    |    4 ++--
 drivers/uwb/whc-rc.c  |    3 +--
 include/linux/uwb.h   |    2 +-
 7 files changed, 18 insertions(+), 19 deletions(-)
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
