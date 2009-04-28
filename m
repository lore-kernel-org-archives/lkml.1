Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZD1SNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZD1SNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZD1SNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:13:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:54438 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbZD1SNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:13:06 -0400
Subject: [GIT PULL] regulator fixes for 2.6.30-rc4
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 19:13:02 +0100
Message-Id: <1240942382.14165.159.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator bug fixes for 2.6.30-rc4.

Thanks

Liam

---

The following changes since commit 27b1833279995e7c290a40cac4ef36ccea7e9283:
  Tim Abbott (1):
        Remove unused support code for refok sections.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Dan Carpenter (1):
      unreachable code in drms_uA_update()

Diego Liziero (1):
      drivers/regulator: fix when type is different from REGULATOR_VOLTAGE or REGULATOR_CURRENT

Mark Brown (1):
      regulator: Fix default constraints for fixed voltage regulators

Mike Rapoport (1):
      regulator/virtual: fix strings compare predicates

Paul Walmsley (1):
      regulator core: fix double-free in regulator_register() error path

Philipp Zabel (1):
      regulator/bq24022: fix bug in is_enabled function

Randy Dunlap (1):
      regulator: fix header file missing kernel-doc

 drivers/regulator/bq24022.c      |    3 +--
 drivers/regulator/core.c         |   19 +++++++++++++------
 drivers/regulator/virtual.c      |    8 ++++----
 include/linux/regulator/driver.h |    1 +
 4 files changed, 19 insertions(+), 12 deletions(-)


