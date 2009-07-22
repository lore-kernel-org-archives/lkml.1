Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZGVFw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZGVFw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZGVFw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:52:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:47686 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZGVFwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:52:25 -0400
Date: Wed, 22 Jul 2009 14:52:20 +0900 (JST)
Message-Id: <20090722.145220.42331079.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 Kconfig fix
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 22 Jul 2009 14:52:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull

Ryusuke Konishi (1):
      fs/Kconfig: move nilfs2 out

 fs/Kconfig        |   27 +--------------------------
 fs/nilfs2/Kconfig |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)
 create mode 100644 fs/nilfs2/Kconfig

from

 git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

The change since commit 6847e154e3cd74fca6084124c097980a7634285a
 Linus Torvalds (1):
      Linux 2.6.31-rc3


This corrects wrong insertion of the config entry of nilfs2.

The fs/Kconfig file was split into individual fs/*/Kconfig files
before nilfs was merged.  But, I inserted the nilfs entry in
fs/Kconfig unawarely.

This simply moves it out to fs/nilfs2/Kconfig and resolves the
discordance in fs/Kconfig.

Thanks,
Ryusuke Konishi
