Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab0CAPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:39:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40110 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0CAPje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:39:34 -0500
Date: Mon, 1 Mar 2010 21:09:23 +0530
From: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
To: ltp-list@lists.sourceforge.net, ltp-announce@lists.sourceforge.net,
       ltp-results@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Garrett Cooper <yanegomi@gmail.com>, subrata@linux.vnet.ibm.com
Subject: [ANNOUNCEMENT]: The Linux Test Project has been released for
 FEBRUARY 2010
Message-ID: <20100301153923.GA16885@linux.vnet.ibm.com>
Mail-Followup-To: ltp-list@lists.sourceforge.net,
	ltp-announce@lists.sourceforge.net,
	ltp-results@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Garrett Cooper <yanegomi@gmail.com>, subrata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The Linux Test Project test suite has been released for the month of
FEB 2010. Please see ltp/INSTALL file carefully, as, there has
been multiple changes for building/installing the test suite after the
recent changes in Makefile infrastructure.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
FEBRUARY 2010 Highlights:
======================== 
      * Conversion of CVS repository to GIT repository. CVS will be
freeze from now onwards.
      * Created four branch for git tree as master, maint, next and pu.

==============================
FEBRUARY 2010 LTP Contributors:
============================== 
     1. Garrett Cooper, 
     2. liubo,
     3. Randy Dunlap
     4. Rishikesh K Rajak
     5. Subrata Modak
     6. Jiri Palecek
     7. Shi Weihua
------------------------------


==============================
Note(s) from the Maintainer:
==============================

http://marc.info/?l=ltp-list&m=126725787515756&w=2

After referring this above link, please try to take advantage of this
git tree.

git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev.git .



We would encourage the community to post results to 
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 
<http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382>
(for
New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 
<http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382>
(for
New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 
<http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382>
(for
New Feature Request(s))

Happy Testing !!

Here are the changes file since 6th feb 2010:

 INSTALL                                            |   26 +-
 Makefile                                           |    2 +-
 Makefile.release                                   |   46 ++
 README                                             |   10 +-
 TODO                                               |   68 +--
 configure.ac                                       |    1 +
 doc/ltp-run-files.txt                              |    4 +-
 include/ltp_signal.h                               |  131 ++----
 include/mk/automake.mk                             |    2 +-
 include/mk/lib.mk                                  |    4 +-
 lib/Makefile                                       |    2 +
 m4/ltp-time.m4                                     |   35 ++
 runtest/controllers                                |    1 +
 runtest/syscalls                                   |    2 +
 scratch/cache_leak                                 |  174 -------
 scratch/googlemmtest.txt                           |  269 ----------
 scratch/hackbench.c                                |  261 ----------
 scratch/lat-sched.c                                |  346 -------------
 scratch/runltp.orig                                |  541
--------------------
 scratch/runltp.robbie                              |  413
---------------
 testcases/commands/ade/ar/ar01                     |    2 +-
 testcases/commands/ade/ld/ld01                     |    2 +-
 testcases/commands/ade/ldd/ldd01                   |    2 +-
 testcases/commands/ade/nm/nm01                     |    2 +-
 testcases/commands/ade/objdump/objdump01           |    2 +-
 testcases/commands/ade/size/size01                 |    2 +-
 testcases/commands/at/at_allow01                   |    2 +-
 testcases/commands/at/at_deny01                    |    2 +-
 testcases/commands/cron/cron02                     |    2 +-
 testcases/commands/cron/cron03                     |    2 +-
 testcases/commands/cron/cron_allow01               |    2 +-
 testcases/commands/cron/cron_deny01                |    2 +-
 testcases/commands/cron/cron_dirs_checks01         |    2 +-
 testcases/commands/mail/00_Descriptions.txt        |    2 +-
 testcases/commands/mail/mail_tests.sh              |  526
++++++++++----------
 testcases/commands/su/su01                         |    2 +-
 testcases/commands/su/su01_s1                      |    2 +-
 testcases/kernel/containers/Makefile               |    2 +-
 testcases/kernel/containers/Makefile.inc           |    2 +-
 testcases/kernel/containers/container_test.sh      |   20 +-
 .../kernel/containers/mqns/check_mqns_enabled.c    |   55 ++
 .../kernel/containers/netns/check_netns_enabled.c  |   35 +-
 .../kernel/containers/pidns/check_pidns_enabled.c  |   70 +++
 testcases/kernel/containers/pidns/pidns17.c        |   28 +-
 testcases/kernel/controllers/Makefile              |    2 +-
 testcases/kernel/controllers/Makefile.inc          |    2 +-
 testcases/kernel/controllers/cpuset/Makefile       |    2 +-
 testcases/kernel/controllers/cpuset/Makefile.inc   |    2 +-
 testcases/kernel/controllers/memcg/README          |   10 +
 .../kernel/controllers/memcg/control/Makefile      |   33 ++
 .../kernel/controllers/memcg/control/mem_process.c |  141 +++++
 .../memcg/control/memcg_control_test.sh            |  166 ++++++
 testcases/kernel/fs/acls/acl_test01                |  199 ++++----
 testcases/kernel/fs/ftest/ftest08.c                |   17 +-
 testcases/kernel/fs/ftest/libftest.c               |   21 +-
 testcases/kernel/io/direct_io/README               |    2 +-
 testcases/kernel/io/stress_floppy/Makefile         |    2 +
 testcases/kernel/io/stress_floppy/stress_floppy    |    2 +-
 testcases/kernel/mem/Makefile                      |    2 +-
 testcases/kernel/mem/Makefile.inc                  |    2 +-
 testcases/kernel/mem/hugetlb/Makefile              |    2 +-
 testcases/kernel/mem/hugetlb/Makefile.inc          |    2 +-
 .../kernel/sched/sched_stress/sched_stress.sh      |    2 +-
 .../kernel/security/cap_bound/exec_without_inh.c   |    3 +
 .../integrity/ima/tests/ima_measurements.sh        |    4 +-
 testcases/kernel/syscalls/ipc/Makefile             |    2 +-
 testcases/kernel/syscalls/ipc/Makefile.inc         |    2 +-
 testcases/kernel/syscalls/mbind/mbind01.c          |    1 +
 testcases/kernel/syscalls/mknod/mknod02.c          |    3 +-
 testcases/kernel/syscalls/mq_notify/mq_notify01.c  |   15 +-
 .../kernel/syscalls/rt_sigaction/rt_sigaction01.c  |  143 +++---
 testcases/kernel/syscalls/rt_sigprocmask/Makefile  |    1 -
 .../syscalls/rt_sigprocmask/rt_sigprocmask01.c     |  211 ++++----
 .../syscalls/rt_sigsuspend/rt_sigsuspend01.c       |  281 +++++-----
 testcases/kernel/syscalls/stime/stime01.c          |  114 +++--
 testcases/kernel/syscalls/swapon/swapon03.c        |   97 +++--
 .../kernel/syscalls/utimensat/utimensat_tests.sh   |   30 +-
 testcases/kernel/timers/include/common_timers.h    |   51 +-
 testcases/network/generate.sh                      |    2 +-
 testcases/network/multicast/mc_opts/mc_opts        |    2 +-
 testcases/network/tcp_cmds/Makefile                |    2 +-
 testcases/network/tcp_cmds/Makefile.inc            |    9 +-
 testcases/network/tcp_cmds/arp/arp01               |    2 +-
 testcases/network/tcp_cmds/echo/echo01             |    2 +-
 testcases/network/tcp_cmds/finger/finger01         |    2 +-
 testcases/network/tcp_cmds/ftp/ftp01               |    2 +-
 testcases/network/tcp_cmds/ftp/ftp02               |    2 +-
 testcases/network/tcp_cmds/ftp/ftp02_s1            |    2 +-
 testcases/network/tcp_cmds/ftp/ftp03               |    2 +-
 testcases/network/tcp_cmds/ftp/ftp04               |    2 +-
 testcases/network/tcp_cmds/ftp/ftp05               |    2 +-
 testcases/network/tcp_cmds/host/host01             |    2 +-
 testcases/network/tcp_cmds/netstat/netstat01       |    2 +-
 testcases/network/tcp_cmds/perf_lan/perf_lan       |    2 +-
 testcases/network/tcp_cmds/ping/ping01             |    2 +-
 testcases/network/tcp_cmds/rcp/rcp01               |    2 +-
 testcases/network/tcp_cmds/rdist/rdist01           |    2 +-
 testcases/network/tcp_cmds/rlogin/rlogin01         |    2 +-
 testcases/network/tcp_cmds/rsh/rsh01               |    2 +-
 testcases/network/tcp_cmds/rwho/rwho01             |    2 +-
 testcases/network/tcp_cmds/sendfile/sendfile01     |    2 +-
 testcases/network/tcp_cmds/ssh/ssh01               |    2 +-
 testcases/network/tcp_cmds/ssh/ssh01_s1            |    2 +-
 testcases/network/tcp_cmds/ssh/ssh02               |    2 +-
 testcases/network/tcp_cmds/ssh/ssh02_s1            |    2 +-
 testcases/network/tcp_cmds/ssh/ssh03               |    2 +-
 testcases/network/tcp_cmds/ssh/ssh03_s1            |    2 +-
 testcases/network/tcp_cmds/tcpdump/tcpdump01       |    2 +-
 testcases/network/tcp_cmds/telnet/telnet01         |    2 +-
 testscripts/build/README                           |   19 +
 testscripts/build/build_test_function.sh           |   67 ++-
 testscripts/build/test_install_in_build_tree.sh    |   26 +-
 .../build/test_install_out_of_build_tree.sh        |   26 +-
 testscripts/build/test_out_of_build_tree.sh        |   26 +-
 testscripts/diskio.sh                              |    2 +-
 testscripts/ltp-aiodio.sh                          |   12 +-
 testscripts/ltp-scsi_debug.sh                      |    2 +-
 testscripts/ltpfslvm.sh                            |    4 +-
 testscripts/ltpfsnolvm.sh                          |    4 +-
 testscripts/ltpstress.sh                           |    6 +-
 testscripts/networkstress.sh                       |    4 +-
 testscripts/networktests.sh                        |    4 +-
 testscripts/runEALtests.sh                         |    2 +-
 testscripts/runpan.sh                              |    2 +-
 testscripts/tpm_tools.sh                           |    2 +-
 tools/make-file.sh                                 |    2 +-
 126 files changed, 1814 insertions(+), 3142 deletions(-)
 create mode 100644 Makefile.release
 create mode 100644 m4/ltp-time.m4
 delete mode 100644 scratch/cache_leak
 delete mode 100644 scratch/googlemmtest.txt
 delete mode 100644 scratch/hackbench.c
 delete mode 100644 scratch/lat-sched.c
 delete mode 100755 scratch/runltp.orig
 delete mode 100755 scratch/runltp.robbie
 create mode 100644
testcases/kernel/containers/mqns/check_mqns_enabled.c
 create mode 100644
testcases/kernel/containers/pidns/check_pidns_enabled.c
 create mode 100644 testcases/kernel/controllers/memcg/control/Makefile
 create mode 100644
testcases/kernel/controllers/memcg/control/mem_process.c
 create mode 100644
testcases/kernel/controllers/memcg/control/memcg_control_test.sh

-- 
Thanks & Regards
Rishi
LTP Maintainer
IBM, LTC, Bangalore
Please join IRC #ltp @ irc.freenode.net
