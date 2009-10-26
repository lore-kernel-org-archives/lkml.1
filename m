Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZJZX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZJZX5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZJZX5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:57:47 -0400
Received: from mga06.intel.com ([134.134.136.21]:3087 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754757AbZJZX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="461593995"
Date: Tue, 27 Oct 2009 00:59:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ilkka Koskinen <ilkka.koskinen@nokia.com>
Subject: [GIT] [2.6.32] MFD pull request
Message-ID: <20091026235940.GA32634@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a couple more bug fixes for 2.6.32, for the MFD subsystem. One is for a
NULL pointer dereference, and the other one is for a potentially uninitialized
mutex.
Thanks in advance for pulling.

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6 for-linus

Ilkka Koskinen (1):
      mfd: Do not dereference null pointer in twl4030 error path

Mark Brown (1):
      mfd: Always initialise WM831x IRQ mutex

 drivers/mfd/twl4030-core.c |    2 +-
 drivers/mfd/wm831x-irq.c   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
