Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYJ2UzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYJ2UzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYJ2UzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:55:08 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58298 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYJ2UzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:55:07 -0400
Subject: [GIT PULL] Regulator fixes for 2.6.28-rc2
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 20:55:06 +0000
Message-Id: <1225313706.6883.29.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull regulator fixes for 2.6.28-rc2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

This contains a fix for the da903x regulator to get it's correct
platform data and a fix for building regulator support on non ARM
architectures.

Thanks

Liam

===

The following changes since commit e946217e4fdaa67681bbabfa8e6b18641921f750:
  Linus Torvalds (1):
        Merge branch 'tracing-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Jonathan Cameron (1):
      da903x regulator bug fix

Mark Brown (1):
      regulator: Build on non-ARM platforms

 drivers/Kconfig            |    2 ++
 drivers/regulator/da903x.c |   29 +++++++++++++++++------------
 2 files changed, 19 insertions(+), 12 deletions(-)


