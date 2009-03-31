Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZCaMLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZCaMLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZCaMLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:11:21 -0400
Received: from smtp.nokia.com ([192.100.122.233]:56285 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZCaMLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:11:21 -0400
Message-ID: <49D20816.10506@nokia.com>
Date: Tue, 31 Mar 2009 15:09:58 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
Subject: Re: [GIT PULL] UBIFS changes for 2.6.30
References: <20090331112439.5337.67925.sendpatchset@localhost.localdomain>
In-Reply-To: <20090331112439.5337.67925.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Mar 2009 12:09:59.0823 (UTC) FILETIME=[9D2599F0:01C9B1F9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bityutskiy Artem (Nokia-D/Helsinki) wrote:
> Hi Linus,

I'm sorry, one bugfix has been forgotten. Please,
ignore the previous UBIFS pull request and take this
one. It is the same but the "UBIFS: fix recovery bug"
patch has been added.

The following changes since commit d5b562330ec766292a3ac54ae5e0673610bd5b3d:                                                           
  Hugh Dickins (1):                                                                                                                    
        mm: fix error case in mlock downgrade reversion                                                                                

are available in the git repository at:

  git://git.infradead.org/ubifs-2.6.git linux-next

Adrian Hunter (3):
      UBIFS: fix dbg_chk_lpt_sz()
      UBIFS: fix bug where page is marked uptodate when out of space
      UBIFS: fix recovery bug

Artem Bityutskiy (9):
      UBIFS: improve find function interface
      UBIFS: amend key_hash return value
      UBIFS: fix bogus assertion
      UBIFS: fix lprops committing bug
      UBIFS: use KERN_CONT
      UBIFS: introduce a helpful variable
      UBIFS: fix commentaries
      UBIFS: fully sort GCed nodes
      UBIFS: add R/O compatibility

Eric Sesterhenn (1):
      UBIFS: list usage cleanup

Hunter Adrian (1):
      UBIFS: fix compiler warnings

 fs/ubifs/budget.c      |   37 ++---
 fs/ubifs/debug.c       |    6 +-
 fs/ubifs/file.c        |   16 ++-
 fs/ubifs/find.c        |   12 +-
 fs/ubifs/gc.c          |  428 +++++++++++++++++++++++++++++++++---------------
 fs/ubifs/journal.c     |    7 +-
 fs/ubifs/key.h         |    6 +-
 fs/ubifs/log.c         |    5 +-
 fs/ubifs/lpt_commit.c  |   34 ++--
 fs/ubifs/recovery.c    |   70 +++------
 fs/ubifs/replay.c      |    2 +-
 fs/ubifs/sb.c          |   36 ++++-
 fs/ubifs/shrinker.c    |    6 +-
 fs/ubifs/super.c       |   37 +++-
 fs/ubifs/tnc.c         |    2 +-
 fs/ubifs/ubifs-media.h |   30 +++-
 fs/ubifs/ubifs.h       |   13 +-
 17 files changed, 482 insertions(+), 265 deletions(-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
