Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYFIKBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYFIKBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbYFIKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:00:54 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:24286 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758909AbYFIKAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:00:53 -0400
Date: Mon, 9 Jun 2008 18:58:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc6
Message-ID: <20080609095851.GA12763@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.26.git

Which contains:

Nobuhiro Iwamatsu (1):
      sh: Fix compile error SH7763 setup code

Paul Mundt (1):
      sh: Add -mno-fdpic to default flags.

Yoshihiro Shimoda (2):
      usb: r8a66597-hcd: Add support for SH7723 USB host
      sh: add resource of USB host for SH7723

Yusuke.Goda (1):
      sh: Add SH7723 SCIF support

 arch/sh/Makefile                       |    2 +
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |   41 ++++++++++++++++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c |    9 ++++---
 drivers/usb/host/Kconfig               |    8 +++---
 4 files changed, 52 insertions(+), 8 deletions(-)
