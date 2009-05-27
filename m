Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZE0Lpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZE0Lpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZE0Lpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:45:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZE0Lpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:45:32 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 May 2009 21:45:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18973.10227.160582.824313@notabene.brown>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md: there was a bug in the bugfix.
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 on of those bug fixes in the recent pull had a bug, found by Stephen
 and his linux-next testing (thanks Stephen).

 I was using 'min()' wrongly and have replaced it with "min_t()".

Thanks,
NeilBrown


The following changes since commit b492b852cd8c99505708152c29a5e09a787af9de:
  NeilBrown (1):
        md: don't use locked_ioctl.

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md: raid5: change incorrect usage of 'min' macro to 'min_t'

 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
