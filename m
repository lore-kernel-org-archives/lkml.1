Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbZJLOwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbZJLOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZJLOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:52:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:27324 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932379AbZJLOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,546,1249282800"; 
   d="scan'208";a="502316144"
Date: Mon, 12 Oct 2009 16:53:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roger Quadros <ext-roger.quadros@nokia.com>
Subject: [GIT] MFD pull request
Message-ID: <20091012145343.GC16662@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I just have one fix for twl4030 that prevents some OMAP based boards from
booting. Thanks in advance for pulling.

The following changes since commit d93a8f829fe1d2f3002f2c6ddb553d12db420412:
  Linus Torvalds (1):
        Revert "USB: Work around BIOS bugs by quiescing USB controllers earlier"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6 for-linus

Roger Quadros (1):
      mfd: Fix twl4030 boot with twl4030 usb transceiver enabled

 drivers/mfd/twl4030-core.c |   89 ++++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 43 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
