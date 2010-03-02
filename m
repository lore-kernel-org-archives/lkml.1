Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0CBQog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:44:36 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:30366
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753292Ab0CBQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:44:35 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KYNYHH-01-FY5-02
X-M-MSG: 
Date: Tue, 2 Mar 2010 17:44:05 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile: updates for v2.6.34
Message-ID: <20100302164405.GJ13205@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Mailer: git-send-email 1.6.6
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Mar 2010 16:44:06.0106 (UTC) FILETIME=[92B13BA0:01CABA27]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

it's only one patch, please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

(It seems the git mirror is not yet sync'ed.)

Thanks,

-Robert

The following changes since commit cfc9c0b450176a077205ef39092f0dc1a04e020a:
  Robert Richter (1):
        oprofile/x86: fix msr access to reserved counters

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ..BRANCH.NOT.VERIFIED..

Martin Schwidefsky (1):
      oprofile: convert oprofile from timer_hook to hrtimer

 drivers/oprofile/oprof.c     |   12 ++++--
 drivers/oprofile/oprof.h     |    3 +-
 drivers/oprofile/timer_int.c |   78 +++++++++++++++++++++++++++++++++++++-----
 3 files changed, 79 insertions(+), 14 deletions(-)

