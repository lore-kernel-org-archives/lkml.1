Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbZAHUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbZAHUVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZAHUVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:21:41 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39193 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbZAHUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:21:40 -0500
Subject: [GIT PULL] Voltage regulator updates
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 20:21:38 +0000
Message-Id: <1231446098.6488.15.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following voltage regulator updates.

Assorted core updates for improved error checks, ref counting, code
size, documentation and registration. Minor fixes for the DA903x PMIC.  

The following changes since commit 9e42d0cf5020aaf217433cad1a224745241d212a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

David Brownell (6):
      regulator: enable/disable refcounting
      regulator: improved mode error checks
      regulator: code shrink (v2)
      regulator: sysfs attribute reduction (v2)
      regulator: init/link earlier
      regulator: catch some registration errors

Kay Sievers (1):
      regulator: struct device - replace bus_id with dev_name(), dev_set_name()

Mark Brown (5):
      regulator: Remove extraneous kerneldoc annotations
      regulator: Clean up kerneldoc warnings
      regulator: Add missing kerneldoc
      regulator: Fix some kerneldoc rendering issues
      regulator: Add basic DocBook manual

Mike Rapoport (3):
      regulator: da903x: add '\n' to error messages
      regulator: da903x: make da903x_is_enabled return 0 or 1
      regulator: move set_machine_constraints after regulator device initialization

Randy Dunlap (1):
      regulator: fix kernel-doc warnings

 Documentation/ABI/testing/sysfs-class-regulator |  136 +++----
 Documentation/DocBook/Makefile                  |    2 +-
 Documentation/DocBook/regulator.tmpl            |  304 +++++++++++++++
 drivers/Makefile                                |    4 +-
 drivers/regulator/core.c                        |  474 ++++++++++++++---------
 drivers/regulator/da903x.c                      |   12 +-
 include/linux/regulator/consumer.h              |    8 +-
 include/linux/regulator/driver.h                |   37 ++-
 include/linux/regulator/machine.h               |   41 ++
 9 files changed, 746 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/DocBook/regulator.tmpl


