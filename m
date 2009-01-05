Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZAEO7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZAEO7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZAEO7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:59:21 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:56764 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbZAEO7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:59:20 -0500
Subject: [git pull] voltage regulator updates
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 14:59:15 +0000
Message-Id: <1231167555.11643.155.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted core updates for improved error checks, ref counting, code
size, documentation and registration. Minor fixes for the DA903x PMIC.  

The following changes since commit fe0bdec68b77020281dc814805edfe594ae89e0f:
  Linus Torvalds (1):
        Merge branch 'audit.b61' of git://git.kernel.org/.../viro/audit-current

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

 Documentation/ABI/testing/sysfs-class-regulator |  136 +++----
 Documentation/DocBook/Makefile                  |    2 +-
 Documentation/DocBook/regulator.tmpl            |  304 +++++++++++++++
 drivers/Makefile                                |    4 +-
 drivers/regulator/core.c                        |  474 ++++++++++++++---------
 drivers/regulator/da903x.c                      |   12 +-
 include/linux/regulator/consumer.h              |    8 +-
 include/linux/regulator/driver.h                |   40 ++-
 include/linux/regulator/machine.h               |   41 ++
 9 files changed, 749 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/DocBook/regulator.tmpl


