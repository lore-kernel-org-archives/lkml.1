Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0ADSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0ADSQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051Ab0ADSQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:16:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37053 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752983Ab0ADSQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:16:36 -0500
Date: Mon, 4 Jan 2010 18:16:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Regulator updates for 2.6.34
Message-ID: <20100104181634.GA18258@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Center meeting at 4pm in 2C-543.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 204f78ec75e6888bbf1a7b5a3ed0cbfff9bade27:
  Tobias Klauser (1):
        regulator/lp3971: Storage class should be before const qualifier

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator-2.6.git for-lrg

A couple of new APIs, plus a use of one of them.

Mark Brown (3):
      regulator: Add notifier event on regulator disable
      regulator: Allow regulators to specify the time taken to ramp on enable
      regulator: Implement enable_time() for WM835x ISINKs

 drivers/regulator/core.c             |   48 ++++++++++++++++++++++++++++-----
 drivers/regulator/wm8350-regulator.c |   46 ++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h   |    4 ++-
 include/linux/regulator/driver.h     |    6 ++++
 4 files changed, 95 insertions(+), 9 deletions(-)
