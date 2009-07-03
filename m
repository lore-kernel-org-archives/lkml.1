Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZGCLSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZGCLSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZGCLSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:18:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:27164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZGCLSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="427372641"
Date: Fri, 3 Jul 2009 13:20:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ribeiro <drwyrm@gmail.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: [GIT] mfd: bug fixes
Message-ID: <20090703112043.GF4176@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a couple of mfd bug fixes, both of them being unbalanced locking.
If you feel this is not rc material, I'll queue them for the next merge
window.
Here is the pull request, thanks in advance:

The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
  Yinghai Lu (1):
        x86: add boundary check for 32bit res before expand e820 resource to alignment

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Daniel Ribeiro (1):
      mfd: fix pcap adc locking

Jiri Slaby (1):
      mfd: sm501, fix lock imbalance

 drivers/mfd/ezx-pcap.c |    4 +++-
 drivers/mfd/sm501.c    |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
