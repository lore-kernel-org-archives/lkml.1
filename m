Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYBARd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYBARd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYBARdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:33:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58352 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYBARdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:33:19 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for JANUARY
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       SE Linux <selinux@tycho.nsa.gov>
Content-Type: multipart/mixed; boundary="=-8borw9Q8V5SGL6EDJgXC"
Organization: IBM
Date: Fri, 01 Feb 2008 23:02:38 +0530
Message-Id: <1201887161.4751.11.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8borw9Q8V5SGL6EDJgXC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
JANUARY 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.


Release Highlights:

* Changes to SE-Linux Reference Policy Test cases,
* GCOV Kernel Patches for Kernels 2.6.23 & 2.6.24,
* Addition of FALLOCATE Test Cases,
* Fix to NUMA Test Cases,
* Fix to POSIX_FADVISE Test Cases,
* REALTIME Test Cases maturing from more community contribution,
* Huge Changes to KDUMP Test Cases,
* Addition of FILECAPS Test Cases,
* Fixes to HTML Output Generation,
* Enhancing LTP capability to run continuous sequential runs,


Note(s) from the Maintainer:

We have had a good 2007 for LTP and the beginning of 2008 also was
fantastic. As we move forward through 2008, we expect traffic to
increase tremendously and community contributions touching new heights.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (JANUARY 2008):

Happy testing, 
Regards-- 
Subrata,

--=-8borw9Q8V5SGL6EDJgXC
Content-Disposition: attachment; filename=Jan-2008_Changelog.txt
Content-Type: text/plain; name=Jan-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

1)  Log Message: Some more updates to Reference Policy Checks by "Serge E. Hallyn" <serue@us.ibm.com> 
File(s) Affected:
ltp/testscripts/test_selinux.sh
File(s) Added:
ltp/testcases/kernel/security/selinux-testsuite/misc/check_sbin_deprecated.pl
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch
ltp/testcases/kernel/security/selinux-testsuite/misc/update_refpolicy.sh

2) Log Message: This solves the configuration issue reported by Santwan <santwana.samantray@in.ibm.com>, and, fixed by Amit Arora <amitarora@in.ibm.com>
File(s) Affected:
ltp/testcases/kernel/syscalls/mlockall/mlockall02.c

3) Log Message: Fix various printf strings to correct formatting and remove spaces, by, Randy Dunlap <rdunlap@xenotime.net>
File(s) Affected:
ltp/tools/apicmds/ltpapicmd.c

4) Log Message: gcov-kernel patch for linux 2.6.23, by Peter Oberparleiter <oberpapr@users.sourceforge.net>
File(s) Added:
/cvsroot/ltp/utils/analysis/gcov-kernel/linux-2.6.23-gcov-arm-eabi.patch
/cvsroot/ltp/utils/analysis/gcov-kernel/linux-2.6.23-gcov-arm-hack.patch
/cvsroot/ltp/utils/analysis/gcov-kernel/linux-2.6.23-gcov.patch

5) Log Message: Filter non-word characters in function name as they would break our file format which uses comma and '=' as field separator, by Peter Oberparleiter <oberpapr@users.sourceforge.net>
File(s) Affected:
/cvsroot/ltp/utils/analysis/lcov/bin/geninfo

6) Log Message: Add dependency information for linux_syscall_numbers.h, by Mike Frysinger <vapier@gentoo.org>
File(s) Affected:
ltp/testcases/kernel/include/Makefile

7) Log Message: Testcases contributed by Sharyathi Nagesh <sharyath@in.ibm.com>
File(s) Affected:
ltp/runtest/syscalls
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/powerpc64.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/s390x.in
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in
ltp/testcases/kernel/include/x86_64.in

File(s) Added:
ltp/testcases/kernel/syscalls/fallocate/Makefile
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c
ltp/testcases/kernel/syscalls/fallocate/run.sh

8) Log Message: Fix for situations when it fails even on NUMA node, enabling proper identification of nodes, by psuriset <psuriset@linux.ibm.com>
File(s) Affected:
ltp/testcases/kernel/numa/numa01.sh
ltp/testcases/kernel/numa/numa_node_size.c
ltp/testcases/kernel/numa/test.sh

9) Log Message: Terminates the tests if __NR_fadvise64 is 0, by Masatake YAMATO <yamato@redhat.com>
File(s) Affected:
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise02.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c

10) Log Message: Randomly generating a no. to avoid the test case to fail, by Sridhar Vinay <vinaysridhar@in.ibm.com>
File(s) Affected:
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

11) Log Message: Jeff Burke <jburke@redhat.com> wanted this unnecessary file to be removed
FIle(s) Affected:
ltp/testcases/pounder21/test_scripts/statslogging.orig

12) Log Message: Some fixes for log directory and execute permission to the script, by Sudhanshu Singh <sudh@linux.vnet.ibm.com> and Jeff Burke <jburke@redhat.com>
File(s) Affected:
ltp/testcases/realtime/README
File(s) Removed:
ltp/testscripts/realtime.sh
File(s) Added:
ltp/testscripts/test_realtime.sh

13) Log Message: Still more fix for Randomly generating a no. to avoid the test case to fail, by Sridhar Vinay <vinaysridhar@in.ibm.com>
File(s) Affected:
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

14) Log Message: "hp_func" should be protected through pthread_mutex or similar, by, Yi Xu <yxu@suse.de>
File(s) Affected:
ltp/testcases/open_posix_testsuite/conformance/interfaces/pthread_create/1-6.c

15) Log Message:
Huge Changes from Cai Qian <qcai@redhat.com>. Please see the Description
below:

The updated version
has the following improvments,

- simplify maintenance

- fix several bugs

- better automation

- extend support on Debian and Fedora

- merge Poornima Nayak <Poornima.Nayak@in.ibm.com> 's latest patch

- other changes

The new version simplifies code layout, and all tools under lib/
directory are standalone and reusable, all configurable variables are
under the file runkdump.conf. There are also included sample
configuration files for different distros and test components. In
addition, it avoided code duplication by merging RHEL and SLES specified
code in lkdtm module together, and add a checking before hand. The
working flow in main script has also been tidied up. verify and
verify_dump have been unified. unused file "summary" has been deleted.

In previous version,
* The part of comparing kernel version in setup will not work proper
  if the kernel grows to something like 2.7.1 or 2.8.1.
* verify_dump will not able to find previous vmcore if vmcore creation
  and vmcore verfication happen at different hours.
* Other random bugs because of code complexity.

In the new version, once you define everything in a config file, it will
run in an automatically fashion on some of systems, if there is proper
tools installed.

The code has been rewritten in POSIX shell syntax, and made more
portable, and attempted to remove hard-coded stuff as much as
possible. It has been tested fairly on RHEL5.1, SLES10sp1, Debian
unstable, and Fedora 8. If needed I can send you result logs. Sachin
has done a quick test on PPC64 machine running RHEL5.1 and the script
run fine. Poornima has done some code review.
Poornima's patch has been merged,
1. Crashkerenl reservation check is modified to support any craskernel
value.  
2. A message before system reboots
3. Added one more line to 'status' if dump verification passed.
4. Modified 'README' file
5. If kdump start fails for invalid arguments in kdump.conf is fixed
6. Replaced MAKE_OPTS with MAKE_OPTIONS.
7. Removed some unwanted statements.

Other changes included that all tests descriptions have been documented
in doc/ALL_TEST.txt. KNLD (dump over scp with link delay) test case has
been merged into KNSCP (dump over scp). Once LINK_DELAY has been defined
somewhere in configuration file, all test cases (KNSCP and KNNFS)
dumping to a network destination will take advantage of it. If
LINK_DELAY is not defined or equals to 0, KNSCP and KNNFS will just the
same as in previous version.

 Cai Qian

Modified Files:
   ltp/testcases/kdump/Makefile ltp/testcases/kdump/README
Added Files:
   ltp/testcases/kdump/runkdump.conf
   ltp/testcases/kdump/runkdump.sh
   ltp/testcases/kdump/doc/ALL_TEST.txt
   ltp/testcases/kdump/doc/OO_Descriptions.txt
   ltp/testcases/kdump/doc/README
   ltp/testcases/kdump/doc/TEST_PLAN.txt
   ltp/testcases/kdump/lib/Makefile
   ltp/testcases/kdump/lib/setup.sh
   ltp/testcases/kdump/lib/ssh.tcl
   ltp/testcases/kdump/lib/sysinfo.sh
   ltp/testcases/kdump/lib/test.sh
   ltp/testcases/kdump/lib/verify.sh
   ltp/testcases/kdump/lib/crasher/Makefile
   ltp/testcases/kdump/lib/crasher/crasher.c
   ltp/testcases/kdump/lib/kprobes/Makefile
   ltp/testcases/kdump/lib/kprobes/kprobes.c
   ltp/testcases/kdump/lib/lkdtm/Makefile
   ltp/testcases/kdump/lib/lkdtm/lkdtm.c
   ltp/testcases/kdump/lib/lkdtm/lkdtm.c.orig
   ltp/testcases/kdump/sample/runkdump.BASIC_LKDTM.RHEL
   ltp/testcases/kdump/sample/runkdump.BASIC_LKDTM.SLES
   ltp/testcases/kdump/sample/runkdump.CRASHER.RHEL
   ltp/testcases/kdump/sample/runkdump.CRASHER.SLES
   ltp/testcases/kdump/sample/runkdump.EXTRA_LKDTM.RHEL
   ltp/testcases/kdump/sample/runkdump.EXTRA_LKDTM.SLES
Removed Files:
   ltp/testcases/kdump/TEST_PLAN.txt
   ltp/testcases/kdump/crash_cmds ltp/testcases/kdump/distro
   ltp/testcases/kdump/kdump_propagate ltp/testcases/kdump/master
   ltp/testcases/kdump/setup ltp/testcases/kdump/summary
   ltp/testcases/kdump/sysinfo ltp/testcases/kdump/test
   ltp/testcases/kdump/tests ltp/testcases/kdump/verify
   ltp/testcases/kdump/verify_dump
   ltp/testcases/kdump/rhtools/Makefile
   ltp/testcases/kdump/rhtools/OO_Descriptions.txt
   ltp/testcases/kdump/rhtools/crasher_mod/Makefile
   ltp/testcases/kdump/rhtools/crasher_mod/crasher.c
   ltp/testcases/kdump/rhtools/lkdtm_mod/Makefile
   ltp/testcases/kdump/rhtools/lkdtm_mod/lkdtm.c
   ltp/testcases/kdump/susetools/Makefile
   ltp/testcases/kdump/susetools/OO_Descriptions.txt
   ltp/testcases/kdump/susetools/crasher_mod/Makefile
   ltp/testcases/kdump/susetools/crasher_mod/crasher.c
   ltp/testcases/kdump/susetools/lkdtm_mod/Makefile
   ltp/testcases/kdump/susetools/lkdtm_mod/lkdtm.c
   ltp/testcases/kdump/testlists/crasher
   ltp/testcases/kdump/testlists/lkdtm.base
   ltp/testcases/kdump/testlists/lkdtm.exha

16) Log Message: A huge Update to the RT Linux Tree by Sebastien Dugu <sebastien.dugue@bull.net>
Modified Files:
 ltp/testcases/realtime/func/async_handler/async_handler.c
 ltp/testcases/realtime/func/async_handler/async_handler_tsc.c
 ltp/testcases/realtime/func/gtod_latency/gtod_latency.c
 ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c
 ltp/testcases/realtime/func/matrix_mult/matrix_mult.c
 ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
 ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
 ltp/testcases/realtime/func/pi_perf/pi_perf.c
 ltp/testcases/realtime/func/pthread_kill_latency/pthread_kill_latency.c
 ltp/testcases/realtime/func/sched_football/sched_football.c
 ltp/testcases/realtime/func/sched_latency/sched_latency.c

17) Log Message: Fix for remap_file_pages(01/02) failing on 31(s390) bit linux guest running RHEL4.6, by, joseferr@linux.vnet.ibm.com
Modifiled File(s):
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages02.c

18) Log Message: Fixing missing argument for open() function when O_CREAT is in the flag, by, Yi Xu <yxu@suse.de>
Modified File(s):
testcases/kernel/syscalls/clone/clone02.c
testcases/kernel/syscalls/fcntl/fcntl18.c
testcases/kernel/syscalls/fdatasync/fdatasync01.c
testcases/kernel/syscalls/getdents/getdents04.c
testcases/kernel/syscalls/mprotect/mprotect02.c
testcases/kernel/syscalls/mprotect/mprotect03.c
testcases/kernel/syscalls/open/open04.c
testcases/kernel/syscalls/pselect/pselect01.c
testcases/kernel/syscalls/read/read02.c
testcases/kernel/syscalls/select/select01.c
testcases/kernel/syscalls/sendfile/sendfile03.c
testcases/kernel/syscalls/splice/splice01.c
testcases/kernel/syscalls/symlink/symlink01.c
testcases/kernel/syscalls/tee/tee01.c
testcases/network/ipv6/sendfile6/testsf_c6.c
testcases/network/tcp_cmds/sendfile/testsf_c.c
testcases/kernel/fs/doio/iogen.c

19) Log Message: Fix for generation of HTML output for absolute paths, by, Subrata Modak <subrata@linux.vnet.ibm.com>
Modified File(s):
ltp/runltp
ltp/tools/genhtml.pl

20) Log Message: Initial set of Filecaps testcases from Serge, "Serge E. Hallyn" <serue@us.ibm.com>
Modified Files:
ltp/runltp
ltp/testcases/kernel/security/Makefile
Added Files:
ltp/runtest/filecaps
ltp/testcases/kernel/security/filecaps/Makefile
ltp/testcases/kernel/security/filecaps/README
ltp/testcases/kernel/security/filecaps/check_simple_capset.c
ltp/testcases/kernel/security/filecaps/checkforfilecaps.sh
ltp/testcases/kernel/security/filecaps/checkforlibcap.sh
ltp/testcases/kernel/security/filecaps/filecapstest.sh
ltp/testcases/kernel/security/filecaps/gotlibcap.c
ltp/testcases/kernel/security/filecaps/inh_capped.c
ltp/testcases/kernel/security/filecaps/nolibcap.c
ltp/testcases/kernel/security/filecaps/print_caps.c
ltp/testcases/kernel/security/filecaps/verify_caps_exec.c
ltp/testscripts/test_filecaps.sh

21) Log Message: testcase ballista gcc 4.3 conformance, by, Patrick Kirsch <pkirsch@suse.de>
Modified File(s):
ltp/testcases/ballista/ballista/compile/bparser.cpp

22) Log Message: Enhancing runltp to run testcases in desired sequence, by, Subrata Modak <subrata@linux.vnet.ibm.com>
Modified File(s):
ltp/runltp

23) Log Message: Adding volatile to avoid the compiler optimization to produce an infinite, by, Carmelo AMOROSO <carmelo.amoroso@st.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>
Modified File(s):
ltp/testcases/kernel/syscalls/times/times03.c

24) Log Message: Extend the unconfined_runs_test interface in the selinux testsuite policy to allow the test programs to properly report back to the caller, by, Stephen Smalley <sds@tycho.nsa.gov>
Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/README
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch

25) Log Message: added gcov-kernel patches for linux-2.6.24, by, Peter Oberparleiter <oberpapr@users.sourceforge.net>
Added File(s):
ltp/utils/analysis/gcov-kernel/linux-2.6.24-gcov-arm-eabi.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.24-gcov-arm-hack.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.24-gcov.patch

26) Log Message: Fix for Build Error issues on NUMA Machine in absence of important RPMs, by, psuriset <psuriset@linux.vnet.ibm.com>
Modified File(s):
ltp/testcases/kernel/numa/Makefile
ltp/testcases/kernel/numa/README
ltp/testcases/kernel/numa/numa01.sh
ltp/testcases/kernel/numa/numa_node_size.c
ltp/testcases/kernel/numa/test.sh

--=-8borw9Q8V5SGL6EDJgXC--

