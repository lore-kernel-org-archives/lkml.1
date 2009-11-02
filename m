Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZKBXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZKBXcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZKBXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:32:22 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:44521 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757257AbZKBXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:32:21 -0500
Date: Mon, 2 Nov 2009 23:32:16 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, liunx-i2c@vger.kernel.org
Subject: PULL: pull request for i2c-fixes
Message-ID: <20091102233216.GA27097@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1836d95928a0f41ada0cbb2a6c4e46b027db9491:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git i2c-fixes

Joakim Tjernlund (1):
      i2c-mpc: Do not generate STOP after read.

Richard Zhao (3):
      i2c: imx: check busy bit when START/STOP
      i2c: imx: only imx1 needs disable delay
      i2c: imx: disable clock when it's possible to save power.

 drivers/i2c/busses/i2c-imx.c |   86 ++++++++++++++++++++++++++++--------------
 drivers/i2c/busses/i2c-mpc.c |   10 +----
 2 files changed, 59 insertions(+), 37 deletions(-)
