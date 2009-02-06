Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZBFHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZBFHFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZBFHFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:05:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZBFHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:05:20 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Feb 2009 18:05:13 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18827.57641.200482.849596@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Andre Noll <maan@systemlinux.org>
Subject: Re: [PULL REQUEST] 2 (or 3) bug fixes for drives/md in 2.6.29
In-Reply-To: message from Neil Brown on Friday February 6
References: <18827.47741.271010.507719@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 6, neilb@suse.de wrote:
> 
> Two small patches for md.
> The first is marked for -stable.

Make that three patches - I just found another bug (or maybe a missing
but very important feature).  It is for -stable too.

Thanks,
NeilBrown

The following changes since commit eda58a85ec3fc05855a26654d97a2b53f0e715b9:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../cooloney/blackfin-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (1):
      md: Fix a bug in linear.c causing which_dev() to return the wrong device.

NeilBrown (2):
      md: Allow read error in a single drive raid1 to be passed up.
      md: Ensure an md array never has too many devices.

 drivers/md/linear.c |    6 +++---
 drivers/md/md.c     |   24 ++++++++++++++----------
 drivers/md/raid1.c  |    3 ++-
 3 files changed, 19 insertions(+), 14 deletions(-)
