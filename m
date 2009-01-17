Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbZAQPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbZAQPDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZAQPDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:03:04 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60249 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbZAQPDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:03:03 -0500
Subject: [GIT PULL] Regulator fix for 2.6.29rc3
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Jan 2009 15:02:59 +0000
Message-Id: <1232204579.16911.27.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

Please pull the following regulator fix for 2.6.29rc3. This fixes an
oops when unbinding and binding the device via sysfs.

The following changes since commit 1de9e8e70f5acc441550ca75433563d91b269bbe:
  Linus Torvalds (1):
        Linux 2.6.29-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Uwe Kleine-König (1):
      move wm8400-regulator's probe function to .devinit.text

 drivers/regulator/wm8400-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


