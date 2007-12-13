Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbXLMOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbXLMOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXLMOkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:40:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbXLMOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:40:15 -0500
Date: Thu, 13 Dec 2007 14:40:04 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: [git pull 00/06] device-mapper fixes for 2.6.24-rc*
Message-ID: <20071213144004.GS24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper fixes for 2.6.24:
 
Alasdair G Kergon (1):
      dm: trigger change uevent on rename

Jun'ichi Nomura (1):
      dm: table detect io beyond device

Milan Broz (2):
      dm crypt: fix write endio
      dm crypt: use bio_add_page

Neil Brown (1):
      dm: merge max_hw_sector

Paul Mundt (1):
      dm mpath: hp requires scsi

 drivers/md/Kconfig            |    2 +-
 drivers/md/dm-crypt.c         |   31 +++++++++++++++----------------
 drivers/md/dm-ioctl.c         |   12 +++++-------
 drivers/md/dm-table.c         |   16 +++++++++++++++-
 drivers/md/dm.c               |   31 ++++++++++++++++++++++++-------
 drivers/md/dm.h               |    7 +++++++
 include/linux/device-mapper.h |    1 +
 7 files changed, 68 insertions(+), 32 deletions(-)

Alasdair
-- 
agk@redhat.com
