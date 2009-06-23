Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZFWPC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZFWPC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbZFWPB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:01:57 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbZFWPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:01:56 -0400
Subject: [GIT PULL] Kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 23 Jun 2009 16:01:46 +0100
Message-Id: <1245769307.16488.42.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 15:01:48.0041 (UTC) FILETIME=[8805D790:01C9F413]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the kmemleak branch again? One of the changes
fixes a Kconfig select conflict with kmemcheck. The other is a cosmetic
update to the kmemleak messages. Thanks.


The following changes since commit d888a4c76c51092993643f8992bf55b3c28da483:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../vapier/blackfin

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (1):
      kmemleak: Do not force the slab debugging Kconfig options

Joe Perches (1):
      kmemleak: use pr_fmt

 lib/Kconfig.debug |    5 +++--
 mm/kmemleak.c     |   52 ++++++++++++++++++++++++----------------------------
 2 files changed, 27 insertions(+), 30 deletions(-)


-- 
Catalin

