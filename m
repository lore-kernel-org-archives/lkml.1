Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYG1UA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYG1UA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG1UAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:00:43 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:38346 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYG1UAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:00:42 -0400
Date: Mon, 28 Jul 2008 21:52:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tests/ directory added
Message-ID: <20080728195251.GA14236@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

A few months ago it was discussed to move all tests to a common place
thus finding a nice spot where we can extend the runtime testing.
The following patchset has been kept up-to-date by Ananth for a while
and I my resistance to take it via kbuild-next.git (as Andrew then suggested)
I have created a sepearate tree for it.

Please pull.

Thanks,
	Sam

The following changes since commit f934fb19ef34730263e6afc01e8ec27a8a71470f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/test.git master

Ananth N Mavinakayanahalli (7):
      Add tests/ directory
      Move locking selftests to tests/
      Move rcutorture to tests/
      Move rtmutex tester to tests/
      Move lkdtm to tests/
      Move kprobes smoke tests to tests/
      Move backtrace selftests to tests/

 Makefile                                        |    1 +
 drivers/misc/Makefile                           |    1 -
 kernel/Makefile                                 |    4 -
 lib/Kconfig.debug                               |   93 +--------------------
 lib/Makefile                                    |    1 -
 tests/Kconfig                                   |  101 +++++++++++++++++++++++
 tests/Makefile                                  |   10 ++
 {kernel => tests}/backtracetest.c               |    0
 {drivers/misc => tests}/lkdtm.c                 |    0
 {lib => tests}/locking-selftest-hardirq.h       |    0
 {lib => tests}/locking-selftest-mutex.h         |    0
 {lib => tests}/locking-selftest-rlock-hardirq.h |    0
 {lib => tests}/locking-selftest-rlock-softirq.h |    0
 {lib => tests}/locking-selftest-rlock.h         |    0
 {lib => tests}/locking-selftest-rsem.h          |    0
 {lib => tests}/locking-selftest-softirq.h       |    0
 {lib => tests}/locking-selftest-spin-hardirq.h  |    0
 {lib => tests}/locking-selftest-spin-softirq.h  |    0
 {lib => tests}/locking-selftest-spin.h          |    0
 {lib => tests}/locking-selftest-wlock-hardirq.h |    0
 {lib => tests}/locking-selftest-wlock-softirq.h |    0
 {lib => tests}/locking-selftest-wlock.h         |    0
 {lib => tests}/locking-selftest-wsem.h          |    0
 {lib => tests}/locking-selftest.c               |    0
 {kernel => tests}/rcutorture.c                  |    0
 {kernel => tests}/rtmutex-tester.c              |    2 +-
 {kernel => tests}/test_kprobes.c                |    0
 27 files changed, 115 insertions(+), 98 deletions(-)
 create mode 100644 tests/Kconfig
 create mode 100644 tests/Makefile
 rename {kernel => tests}/backtracetest.c (100%)
 rename {drivers/misc => tests}/lkdtm.c (100%)
 rename {lib => tests}/locking-selftest-hardirq.h (100%)
 rename {lib => tests}/locking-selftest-mutex.h (100%)
 rename {lib => tests}/locking-selftest-rlock-hardirq.h (100%)
 rename {lib => tests}/locking-selftest-rlock-softirq.h (100%)
 rename {lib => tests}/locking-selftest-rlock.h (100%)
 rename {lib => tests}/locking-selftest-rsem.h (100%)
 rename {lib => tests}/locking-selftest-softirq.h (100%)
 rename {lib => tests}/locking-selftest-spin-hardirq.h (100%)
 rename {lib => tests}/locking-selftest-spin-softirq.h (100%)
 rename {lib => tests}/locking-selftest-spin.h (100%)
 rename {lib => tests}/locking-selftest-wlock-hardirq.h (100%)
 rename {lib => tests}/locking-selftest-wlock-softirq.h (100%)
 rename {lib => tests}/locking-selftest-wlock.h (100%)
 rename {lib => tests}/locking-selftest-wsem.h (100%)
 rename {lib => tests}/locking-selftest.c (100%)
 rename {kernel => tests}/rcutorture.c (100%)
 rename {kernel => tests}/rtmutex-tester.c (99%)
 rename {kernel => tests}/test_kprobes.c (100%)
