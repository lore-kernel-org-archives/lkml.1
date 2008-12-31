Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYLaMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYLaMvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYLaMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:51:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1060 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYLaMvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:51:23 -0500
Date: Wed, 31 Dec 2008 12:51:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20081231125114.GC6596@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/5] regulator: kerneldoc cleanups
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the kerneldoc for the regulator API and adds
a brief DocBook manual for it, based heavily on the existing plain text
documentation but much less complete.  I'm not sure that the manual
itself is actually worthwhile, the main benefit from it is the generated 
documentation rather than the text in the manual itself - I did the work
to help with generating the earlier fixes.

It may be worth considering the first four patches for 2.6.29 as fixes,
though it's questionable.

The following changes since commit b6fe1c783638104350147877f5823d8faa68f6a2:
  David Brownell (1):
        regulator: init/link earlier

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator-2.6.git topic/doc

Mark Brown (5):
      regulator: Remove extraneous kerneldoc annotations
      regulator: Clean up kerneldoc warnings
      regulator: Add missing kerneldoc
      regulator: Fix some kerneldoc rendering issues
      regulator: Add basic DocBook manual

 Documentation/DocBook/Makefile       |    2 +-
 Documentation/DocBook/regulator.tmpl |  304 ++++++++++++++++++++++++++++++++++
 drivers/regulator/core.c             |   57 ++++---
 include/linux/regulator/consumer.h   |    8 +-
 include/linux/regulator/driver.h     |   40 +++++-
 include/linux/regulator/machine.h    |   41 +++++
 6 files changed, 420 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/DocBook/regulator.tmpl
