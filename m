Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZCaLoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZCaLoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZCaLnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:43:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38550 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZCaLns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:43:48 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for MARCH 2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Serge Hallyn <serue@us.ibm.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Michal Simek <monstr@monstr.eu>,
       poornima nayak <mpnayak@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Andrew Vagin <avagin@gmail.com>, fredrick he <fhe@novell.com>,
       Francesco RUNDO <francesco.rundo@st.com>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       CAI Qian <caiqian@cclom.cn>, Masatake YAMATO <yamato@redhat.com>,
       Robbie Williamson <robbie@ubuntu.com>,
       Chandru S <chandru@linux.vnet.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Gowrishankar M <gowrishankar.m@in.ibm.com>,
       Vernon Mauery <vernux@us.ibm.com>
Content-Type: multipart/mixed; boundary="=-dmKyU666W3tfxP0HdEKc"
Organization: IBM
Date: Tue, 31 Mar 2009 17:13:38 +0530
Message-Id: <1238499818.6818.25.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dmKyU666W3tfxP0HdEKc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
MARCH 2009. Please see ltp/INSTALL file carefully, as, there has been
multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
MARCH 2009 Highlights:
========================
* Addition of CONTROLLER AREA NETWORK tests,
* Addition of MESSAGE QUEUE NAMESPACE tests,
* Addition of SMACK SECURITY tests,
* Several Coding style Fixes,
* Fixes for numerous other tests,
------------------------------

==============================
MARCH 2009 LTP Contributors:
==============================
* Oliver Hartkopp,
* Nadia Derbey,
* Serge Hallyn,
* Márton Németh,
* Michal Simek,
* Poornima Nayak,
* Sudhir Kumar,
* Andrew Vagin,
* Fredrick He,
* Francesco RUNDO,
* Peter Oberparleiter,
* CAI Qian,
* Masatake YAMATO,
* Subrata Modak,
* Robert Williamson,
* Chandru S,
* Casey Schaufler,
* Gowrishankar M,
* Vernon Mauery,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
Continuing with our effort for testing new areas, we saw major
contributions in terms of new tests this month. I am hoping that this
trend will be carried forward in the coming quarters as well.

Michal Simek´s effort to cleanup LTP coding style and provide fixes for
them is a good move. I am sure that he will complete that in coming
months.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
New Feature Request(s))

Happy testing, 
Regards-- 
Subrata,


--=-dmKyU666W3tfxP0HdEKc
Content-Disposition: attachment; filename=March-2009_Changelog.txt
Content-Type: text/plain; name=March-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
Addition of CONTROLLER AREA NETWORK tests to LTP. Signed-Off-By: Oliver Har=
tkopp <oliver.hartkopp@volkswagen.de>.

Added Files:
ltp/testcases/network/can/filter-tests/00_Descriptions.txt
ltp/testcases/network/can/filter-tests/INSTALL
ltp/testcases/network/can/filter-tests/Makefile
ltp/testcases/network/can/filter-tests/canecho.c
ltp/testcases/network/can/filter-tests/run_ltp-can_tests.sh
ltp/testcases/network/can/filter-tests/tst-bcm-cycle.c
ltp/testcases/network/can/filter-tests/tst-bcm-dump.c
ltp/testcases/network/can/filter-tests/tst-bcm-filter.c
ltp/testcases/network/can/filter-tests/tst-bcm-rtr.c
ltp/testcases/network/can/filter-tests/tst-bcm-rx-sendto.c
ltp/testcases/network/can/filter-tests/tst-bcm-server.c
ltp/testcases/network/can/filter-tests/tst-bcm-single.c
ltp/testcases/network/can/filter-tests/tst-bcm-throttle.c
ltp/testcases/network/can/filter-tests/tst-bcm-tx-sendto.c
ltp/testcases/network/can/filter-tests/tst-bcm-tx_read.c
ltp/testcases/network/can/filter-tests/tst-err.c
ltp/testcases/network/can/filter-tests/tst-filter-master.c
ltp/testcases/network/can/filter-tests/tst-filter-server.c
ltp/testcases/network/can/filter-tests/tst-packet.c
ltp/testcases/network/can/filter-tests/tst-proc.c
ltp/testcases/network/can/filter-tests/tst-raw-filter.c
ltp/testcases/network/can/filter-tests/tst-raw-sendto.c
ltp/testcases/network/can/filter-tests/tst-raw.c

2) Log Message:
Add LTP Command File for CAN Filter Tests. Signed-Off-By: Oliver Hartkopp <=
oliver.hartkopp@volkswagen.de>.

Added Files:
ltp/runtest/can

3) Log Message:
Add Info For Running CAN tests in runalltests.sh. Signed-Off-By: Oliver Har=
tkopp <oliver.hartkopp@volkswagen.de>.

Modified Files:
ltp/runalltests.sh

4) Log Message:
Add Kernel Config Options for CAN tests. Signed-Off-By: Oliver Hartkopp <ol=
iver.hartkopp@volkswagen.de>.

Modified Files:
ltp/README

5) Log Message:
[PATCH 1/4] ltp: posix message queue namespaces: first test: Add the first =
test for posix message queue namespaces, plus a test to detect whether they=
 are enabled. Note that the kernel version check is currently bogus - these=
 are are in -mm. Based on older version by Nadia Derbey.
Changelog:
        Mar 02 2009: moved to the libclone do_clone() helper.
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>,
Signed-off-by: Serge Hallyn <serue@us.ibm.com>.

Modified Files:
ltp/README
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/README
ltp/testcases/kernel/containers/container_test.sh
Added Files:
ltp/testcases/kernel/containers/mqns/Makefile
ltp/testcases/kernel/containers/mqns/check_mqns_enabled.c
ltp/testcases/kernel/containers/mqns/mqns.h
ltp/testcases/kernel/containers/mqns/mqns_01.c
ltp/testcases/kernel/containers/mqns/runmqnstest.sh

6) Log Message:
[PATCH 2/4] ltp: posix mqns: test parent to child mq access: It's kind of r=
edundant with test 01 since there is no hierarchical relationship between i=
pc namespaces - they are all completely isolated. But heck it can't hurt.=20
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>,
Signed-off-by: Serge Hallyn <serue@us.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/mqns/runmqnstest.sh
Added Files:
ltp/testcases/kernel/containers/mqns/mqns_02.c

7) Log Message:
[PATCH 3/4] ltp: posix mqns: test vfs and mq interaction: Test that the int=
eraction between mqueuefs and ipc namespaces is correct (one mqueuefs for e=
ach ipc namespace, living at least as long as the namespace). Signed-off-by=
: Serge Hallyn <serue@us.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/mqns/mqns.h
ltp/testcases/kernel/containers/mqns/runmqnstest.sh
Added Files:
ltp/testcases/kernel/containers/mqns/mqns_03.c

8) Log Message:
[PATCH 4/4] ltp: posix mqns: test that user mount of posixmq survives the i=
pcns: If the mqueuefs for a ipc namespace is mounted in a mounts namespace =
which outlives the ipcns, then the view of the fs remains valid until someo=
ne umounts it.  Run some tests to make sure that all is sane. Signed-off-by=
: Serge Hallyn <serue@us.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/mqns/mqns.h
ltp/testcases/kernel/containers/mqns/runmqnstest.sh
Added Files:
ltp/testcases/kernel/containers/mqns/mqns_04.c

9) Log Message:
Make the acpi device-driver test compilable with Linux kernel 2.6.28. Compl=
etely drop supporting older kernels which are not compatible with 2.6.28. S=
igned-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>.

Modified File(s):
ltp/testcases/kernel/device-drivers/acpi/LtpAcpiCmds.c
ltp/testcases/kernel/device-drivers/acpi/LtpAcpiMain.c
ltp/testcases/kernel/device-drivers/acpi/Makefile

10) Log Message:
Replace ARCH_i386 with __i386__: Because of compilation fault for non x86 a=
rch. (In my case for Microblaze cpu). Signed-off-by: Michal Simek <monstr@m=
onstr.eu>.

Modified File(s):
ltp/testcases/kernel/sched/hyperthreading/Makefile
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTaffinity.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTenabled.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTinterrupt.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTutils.c

11) Log Message:
[Patch 1/5]Library of reusable functions for Power Management testing: Libr=
ary of reusable functions modified. Few more functions implemented to suppo=
rt sched domain validation. Signed-off-by: poornima nayak <mpnayak@linux.vn=
et.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/lib/sched_mc.py

12) Log Message:
[PATCH 02/05]: Patch to implement test case to validate sched domain tree: =
Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Added Files:
ltp/testcases/kernel/power_management/sched_domain.py

13) Log Message:
Patch to integrate sched domain testcase to LTP: Signed-off-by: poornima na=
yak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/Makefile
ltp/testcases/kernel/power_management/runpwtests.sh

14) Log Message:
Patch for modified cpu_consolidation testcase: Patch for for cpu_consolidat=
ion testcase modified w.r.t new function calls and review comments by devel=
opers. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/cpu_consolidation.py

15) Log Message:
Patch to fix cpufreq governor load and unload. Signed-Off-By: Poornima naya=
k <mpnayak@linux.vnet.ibm.com>.=20

Modified Files:
ltp/testcases/kernel/power_management/pwkm_load_unload.sh

16) Log Message:
Calculate the allowed latency dynamicaly for cpu controller latency tests: =
This patch adds the proper logic for calculating the allowed value of laten=
cy that is being used as the PASS/FAIL criterion in cpuctl latency testcase=
s. Signed-off-by Sudhir Kumar <skumar@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/cpuctl/cpuctl_latency_check_task.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_testplan.txt
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_latency_test.sh

17) Log Message:
INOTIFY02: add warning about bug: we have many messages about this bug in m=
ail lists. Signed-Off-BY: Andrew Vagin <avagin@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/inotify02.c

18) Log Message:
Patch for enabling the ftruncate04 testcase:
-add mount mandatory option to enable test run. this test case doesn't work=
 almost all the time we use it.
-modified ftruncate04.c for the situation when the /tmp(or other test) dire=
ctory is in a LVM filesystem where there are three output lines
-modified ltp-full-20081031/runtest/syscalls and testcases/kernel/syscalls/=
ftruncate/Makefile to make this testcase can be started by the two new adde=
d script ftruncate.sh and ftruncate_64.sh.
Signed-off-by : fredrick he <fhe@novell.com>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/ftruncate/Makefile
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c
Added Files:
ltp/testcases/kernel/syscalls/ftruncate/ftruncate.sh
ltp/testcases/kernel/syscalls/ftruncate/ftruncate_64.sh

19) Log Message:
utimensat testcase: do kernel version check at build time: I'd like to subm=
it a change to be done on utimensat testcase. This test performs a kernel v=
ersion check both at build time and  runtime. At build time, the test perfo=
rms a check at makefile level. The same check is also repeated in the "inst=
all" target of the same Makefile. Moreover, at runtime the script "utimensa=
t_tests.sh" used to run the test (by standard runltp script) performs again=
 the same check. Now, my opinion about that is the following:
1) for i386 arch: One of the above checks should be removed.
2) for cross-build: The above structure of the test is really a problem. In=
 fact, at build time the Makefile (as it is) cross-builds (by ${CC} env var=
.) the binary "check_for_utimensat_support" which, clearly, can't be execut=
ed on the host side (even though it will detect the "host" kernel version a=
nd not the "target" ones!). I cross-build & run LTP on SH based archs so th=
at the utimensat testcase failed at runtime as the binary utimensat01 wasn'=
t copied to $LTPROOT/testcases/bin due to error on "check_for_utimensat_sup=
port" execution (Exec format error. Wrong Architecture). I've solved the ab=
ove problem disabling the check of the kernel version at build time (removi=
ng the check on the Makefile). I keep only the check at runtime. Signed-Off=
-By: Francesco RUNDO <francesco.rundo@st.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/utimensat/Makefile

20) Log Message:
lcov: improve function name filtering. Only remove those characters from fu=
nction names which would conflict with internal delimiters. Peter Oberparle=
iter <oberpapr@users.sourceforge.net>.

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo

21) Log Message:
pselect01 & nanosleep02: Warnings about Syscall Execution Time: This patch =
addes warnings in pselect01 and nanosleep02 test cases that the certain fai=
lures may due to the limitation of the way it calculates the system call ex=
ecution time. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/syscalls/nanosleep/nanosleep02.c
ltp/testcases/kernel/syscalls/pselect/pselect01.c

22) Log Message:
Proc01: Check Both SELinux Libraries and Headers v3: Version 3 fixes line w=
rapping problem and adds more comments. This late patch is to address Masat=
ake YAMATO's concern for,
<1> selinux.h is available, but libselinux is not.
<2> libselinux is available, but selinux.h is not.
Therefore, we only set HAVE_LIBSELINUX_DEVEL when all libraries and headers=
 are available. Signed-off-by: Masatake YAMATO <yamato@redhat.com>, Signed-=
off-by: CAI Qian <caiqian@cclom.cn>.

Modifies File(s):
ltp/m4/ltp-selinux.m4
ltp/testcases/kernel/fs/proc/proc01.c

23) Log Message:
Stress script to load all modules: In testing one of the distros (unrelease=
d), i recently discovered a problem where the kernel hangs while loading al=
l the modules sequentially. This was a random testing conducted through the=
 following simple script. The distro kernel hanged in several instances of =
testing, and, the machine had to be rebooted each time. When i verified the=
 same script through some other already stable distros, i found that those =
stable kernels handle the situation well by not laoding those modules for w=
hich controllers does not exist. Module loading errors were expected, never=
theless i expected the kernel to hang each time this script executed. I tho=
ught this could be a good stress generation script for any system. Signed-O=
ff-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Added Files:
ltp/testscripts/load_stress_all_kernel_modules.sh

24) Log Message:
This is the v4l-test 0.9 for LTP patch. Changes: Test cases added for VIDIO=
C_S_CROP. Test steps added for VIDIOC_S_CTRL. Signed-Off-By: M=C3=A1rton N=
=C3=A9meth <nm127@freemail.hu>.

Modified File(s):
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROP.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROPCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/video_limits.h
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html

25) Log Message:
Formatted the 'ls -l' command for testcase #22, which verifies the verbose =
output of 'ar' against a formatted 'ls -l' of file1.in, file2.in, and file3=
.in.

Modified File(s):
ltp/testcases/commands/ade/ar/ar01

26) Log Message:
Fixed test #17 that tests the -s flag to regenerate the symbol table.  It w=
as incorrectly testing for this by reading block size. The simple solution =
was to compare file size before running 'strip', after running 'strip and '=
ar -s'.  I suppose a more "elegant" solution would be to use 'nm'. Also rem=
oved an irrelevant use of the "-t" flag in test #17.

Modified File(s):
ltp/testcases/commands/ade/ar/ar01

27) Log Message:
Symlink01: Not Run Invalid Tests v2: Renumber testcases in the symlink01 fi=
le, reflecting some added tests: http://article.gmane.org/gmane.linux.ltp/6=
987. Enabled 2 seems invalid tests, which caused link01 and rename01A test =
cases failure,Looking from the code, the first failure looks indeed broken =
according to its own comment,The second one is because it makes assumption =
that the link and target files are located in different filesystems, which =
is incorrect.This patch reverts some parts of the above patch, and return i=
t to its original behavior. I have also added some comments there to explai=
n so. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/kernel/syscalls/symlink/symlink01.c

28) Log Message:
Sysconf01: Fix Wrong Errno v2: This patch fixes an error that use the retur=
n of the function instead of errno. In addition, errno has been saved first=
 to avoid to be changed by tst_resm(). Signed-off-by: CAI Qian <caiqian@ccl=
om.cn>.=20

Modified Files:
ltp/testcases/kernel/syscalls/sysconf/sysconf01.c

29) Log Message:
Ln_test01 & Unzip01: Fix Bugs v2: The patch fixes 2 bugs. The first one is =
in ln_test01, which always failed due to the expected result file is wrongl=
y generated,The second one is in unzip01 caused by the recently introduced =
Makefile change named: http://article.gmane.org/gmane.linux.ltp/7635. Signe=
d-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/commands/fileutils/ln/ln_tests.sh
ltp/testcases/commands/unzip/Makefile

30) Log Message:
Fixed testcase #19 in a similar manner as #17.

Modified File(s):
ltp/testcases/commands/ade/ar/ar01

31) Log Message:
Modified two scripts ftruncate.sh and ftruncate_64.sh to improvement this t=
estcase. Signed-off-by : fredrick he <fhe@novell.com>, Acked-By: CAI Qian <=
caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/syscalls/ftruncate/ftruncate.sh
ltp/testcases/kernel/syscalls/ftruncate/ftruncate_64.sh

32) Log Message:
The epoll-ltp testcase tests zero size argument to epoll_create and reports=
 that particular case as a failure if the kernel returned a positive intege=
r. According to 'man epoll_create', this size argument is actually ignored =
and the kernel dynamically sizes the required data structures. Hence removi=
ng this check in epoll-ltp testcase. Signed-Off-By: Chandru S <chandru@linu=
x.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/epoll/epoll-ltp.c

33) Log Message:
Writev06: Fix Error Checking for mmap(): Sometimes, writev06 test case fail=
ed due to receiving a SIGSEGV signal. The test gives too little information=
 to figure it out what might be wrong. This failure is not always reproduci=
ble, and I have seen the SIGSEGV has just arrived after a few mmap() calls.=
 The following patch makes it easier to debug this type of failure by fixin=
g error checking code for mmap() calls. Signed-off-by: CAI Qian <caiqian@cc=
lom.cn>.

Modified File(s):
ltp/testcases/kernel/syscalls/writev/writev06.c

34) Log Message:
Writev06: Fix Error Checking for mmap() v2: Sometimes, writev06 test case f=
ailed due to receiving a SIGSEGV signal. This is due to out of range access=
 of array. In addition, The test gives too little information to figure it =
out what might be wrong. The following patch makes it easier to debug this =
type of failure by fixing error checking code for mmap() calls. Signed-off-=
by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/syscalls/writev/writev06.c

35) Log Message:
The following patch named: [PATCH 3/6] Integrate the File System Permission=
s Tests in to Default LTP run, http://article.gmane.org/gmane.linux.ltp/687=
5. Added fs_perm test case to the default run, but it failed to execute pro=
perly. The following patch fixes it by installing a needed binary. Signed-o=
ff-by: CAI Qian <caiqian@redhat.com>, Signed-off-by: Subrata Modak <subrata=
@linux.vnet.ibm.com>,

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/Makefile
ltp/testcases/kernel/fs/fs_perms/fs_perms.c
ltp/testcases/kernel/fs/fs_perms/fs_perms_simpletest.sh

36) Log Message:
Pipeio: Fix Error Use of Semctl(2): [PATCH] aio and nonblocking io in tlibi=
o.c and pipeio.c, http://article.gmane.org/gmane.linux.ltp/6643, unfortunat=
ely introduced a segmentation fault on PPC64.
# ./pipeio -T pipeio_1 -c 5 -s 4090 -i 100 -b -f x80
Segmentation fault
This is due to the error use of semctl(2) pointed by Jakub Jelinek. The tes=
tcase is buggy. See man 3p semctl: The semctl() function provides a variety=
 of semaphore control operations as specified by cmd. The fourth argument i=
s optional and depends upon the operation requested. If you fix the testcas=
e up, it works just fine. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/ipc/pipeio/pipeio.c

37) Log Message:
This patch is to fix the 2 further issues apart from the patch I sent out y=
estoday: [PATCH] Fs_perms: Miss Installing a Binary. Fs_perms test always g=
ives false failure. This is because in the script, it returns whatever the =
last "fs_perms" command returns. In the case, if "fs_perms" passes, it will=
 return "1" (it returns whatever the expected result specificed. That is 1 =
here). The patch fixes it by validating the return code of every "fs_perms"=
 command, and returns the final result at the end of the main script -- fs_=
perms_simpletest.sh. The other issue is that, some tests need to access fil=
es in "${LTPROOT}/testcases/bin" directory. For example, "fs_perms" and "fs=
_racer". As the result, if we are running the tests outside of that directo=
ry through "pan" alone, "runltp.sh" or "runltplite.sh", those tests are not=
 running properly. The patch fixes it in both "runltp.sh" and "runltplite.s=
h" by changing the current working directory to the "bin" just before runni=
ng "pan", and restore it back. However, the problem still exist if running =
those tests by "pan" alone not through either "runltp.sh" or "runltplite.sh=
". This patch has been tested by running the most of LTP tests through "run=
ltp.sh" without seen any negative affect. Signed-off-by: CAI Qian <caiqian@=
cclom.cn>.

Modified File(s):
ltp/runltp
ltp/runltplite.sh
ltp/testcases/kernel/fs/fs_perms/fs_perms_simpletest.sh

38) Log Message:
v4l-test 0.10 for LTP: Changes: Test cases added for VIDIOC_G_PARM. Duplica=
ted test for V4L2_BUF_TYPE_VIDEO_CAPTURE removed in VIDIOC_ENUM_FMT test. S=
igned-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_PARM.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_PARM.h

39) Log Message:
Fs_perms & Runltp: Fix 2 Issues: Subrata, can you apply the following to re=
vert this part of patch that you made previous? I don't think we need this =
part yet after all other related patches applied. In addition, it causes th=
e test failed to run from the its own directory, which we could test it the=
re before. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/kernel/fs/fs_perms/fs_perms.c

40) Log Message:
Fallocate: Use TCONF instead of TWARN: This patch fixes TWARN with TCONF to=
 indicate the system does not support those test cases. Signed-off-by: CAI =
Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c

41) Log Message:
Execve04: No Such File: Execve04 test case can fail due to the required fil=
e not found. It because it uses a relative path, so it depends on where to =
run the test. This patch fixes it by using a absolute path, and also make s=
ure it can handle a long name. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/execve/execve04.c

42) Log Message:
Realtime: fix testpi2 parser from invalid index type error: realtime: fix t=
estpi2 parser from invalid index type error. Signed-off-by: Gowrishankar M =
<gowrishankar.m@in.ibm.com>, Tested-by: Gowrishankar M <gowrishankar.m@in.i=
bm.com>, Acked-by: Vernon Mauery <vernux@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/func/pi-tests/parse-testpi2.py

43) Log Message:
Cleanup user space device-driver Makefiles: Signed-Off-By: N=C3=A9meth M=C3=
=A1rton <nm127@freemail.hu>.

Modified File(s):
ltp/testcases/kernel/device-drivers/agp/user_space/Makefile
ltp/testcases/kernel/device-drivers/base/user_base/Makefile
ltp/testcases/kernel/device-drivers/dev_sim_framework/user_space/Makefile
ltp/testcases/kernel/device-drivers/pci/user_tpci/Makefile
ltp/testcases/kernel/device-drivers/tbio/user_space/Makefile
ltp/testcases/kernel/device-drivers/usb/user_usb/Makefile

44) Log Message:
Coding Syle Cleanups. Signed-Off-By: <michal.simek@petalogix.com>.

Modified Files:
ltp/testcases/kernel/syscalls/abort/abort01.c
ltp/testcases/kernel/syscalls/accept/accept01.c
ltp/testcases/kernel/syscalls/accept4/accept4_01.c
ltp/testcases/kernel/syscalls/access/access01.c
ltp/testcases/kernel/syscalls/access/access02.c
ltp/testcases/kernel/syscalls/access/access03.c
ltp/testcases/kernel/syscalls/access/access04.c
ltp/testcases/kernel/syscalls/access/access05.c
ltp/testcases/kernel/syscalls/acct/acct01.c
ltp/testcases/kernel/syscalls/acct/acct02.c
ltp/testcases/kernel/syscalls/adjtimex/adjtimex01.c
ltp/testcases/kernel/syscalls/adjtimex/adjtimex02.c
ltp/testcases/kernel/syscalls/alarm/alarm01.c
ltp/testcases/kernel/syscalls/alarm/alarm02.c
ltp/testcases/kernel/syscalls/alarm/alarm03.c
ltp/testcases/kernel/syscalls/alarm/alarm05.c
ltp/testcases/kernel/syscalls/alarm/alarm06.c
ltp/testcases/kernel/syscalls/alarm/alarm07.c
ltp/testcases/kernel/syscalls/asyncio/asyncio02.c
ltp/testcases/kernel/syscalls/bind/bind01.c
ltp/testcases/kernel/syscalls/bind/bind02.c
ltp/testcases/kernel/syscalls/brk/brk01.c
ltp/testcases/kernel/syscalls/capget/capget01.c
ltp/testcases/kernel/syscalls/capget/capget02.c
ltp/testcases/kernel/syscalls/capset/capset01.c
ltp/testcases/kernel/syscalls/capset/capset02.c
ltp/testcases/kernel/syscalls/chdir/chdir01.c
ltp/testcases/kernel/syscalls/chdir/chdir02.c
ltp/testcases/kernel/syscalls/chdir/chdir03.c
ltp/testcases/kernel/syscalls/chdir/chdir04.c
ltp/testcases/kernel/syscalls/chmod/change_owner.c
ltp/testcases/kernel/syscalls/chmod/change_owner.mode.sh
ltp/testcases/kernel/syscalls/chmod/chmod01.c
ltp/testcases/kernel/syscalls/chmod/chmod02.c
ltp/testcases/kernel/syscalls/chmod/chmod03.c
ltp/testcases/kernel/syscalls/chmod/chmod04.c
ltp/testcases/kernel/syscalls/chmod/chmod05.c
ltp/testcases/kernel/syscalls/chmod/chmod06.c
ltp/testcases/kernel/syscalls/chmod/chmod07.c
ltp/testcases/kernel/syscalls/chown/change_owner.c
ltp/testcases/kernel/syscalls/chown/change_owner.mode.sh
ltp/testcases/kernel/syscalls/chown/chown01.c
ltp/testcases/kernel/syscalls/chown/chown02.c
ltp/testcases/kernel/syscalls/chown/chown03.c
ltp/testcases/kernel/syscalls/chown/chown04.c
ltp/testcases/kernel/syscalls/chown/chown05.c
ltp/testcases/kernel/syscalls/chroot/chroot01.c
ltp/testcases/kernel/syscalls/chroot/chroot02.c
ltp/testcases/kernel/syscalls/chroot/chroot03.c
ltp/testcases/kernel/syscalls/chroot/chroot04.c
ltp/testcases/kernel/syscalls/clone/clone01.c
ltp/testcases/kernel/syscalls/clone/clone02.c
ltp/testcases/kernel/syscalls/clone/clone03.c
ltp/testcases/kernel/syscalls/clone/clone04.c
ltp/testcases/kernel/syscalls/clone/clone05.c
ltp/testcases/kernel/syscalls/clone/clone06.c
ltp/testcases/kernel/syscalls/clone/clone07.c
ltp/testcases/kernel/syscalls/close/close01.c
ltp/testcases/kernel/syscalls/close/close02.c
ltp/testcases/kernel/syscalls/close/close08.c
ltp/testcases/kernel/syscalls/confstr/confstr01.c
ltp/testcases/kernel/syscalls/connect/connect01.c
ltp/testcases/kernel/syscalls/creat/creat01.c
ltp/testcases/kernel/syscalls/creat/creat03.c
ltp/testcases/kernel/syscalls/creat/creat04.c
ltp/testcases/kernel/syscalls/creat/creat05.c
ltp/testcases/kernel/syscalls/creat/creat06.c
ltp/testcases/kernel/syscalls/creat/creat07.c
ltp/testcases/kernel/syscalls/creat/creat08.c
ltp/testcases/kernel/syscalls/creat/creat09.c
ltp/testcases/kernel/syscalls/creat/test1.c
ltp/testcases/kernel/syscalls/dup/dup01.c
ltp/testcases/kernel/syscalls/dup/dup02.c
ltp/testcases/kernel/syscalls/dup/dup03.c
ltp/testcases/kernel/syscalls/dup/dup04.c
ltp/testcases/kernel/syscalls/dup/dup05.c
ltp/testcases/kernel/syscalls/dup/dup06.c
ltp/testcases/kernel/syscalls/dup/dup07.c
ltp/testcases/kernel/syscalls/dup2/dup201.c
ltp/testcases/kernel/syscalls/dup2/dup202.c
ltp/testcases/kernel/syscalls/dup2/dup203.c
ltp/testcases/kernel/syscalls/dup2/dup204.c
ltp/testcases/kernel/syscalls/dup2/dup205.c
ltp/testcases/kernel/syscalls/dup3/dup3_01.c
ltp/testcases/kernel/syscalls/epoll/README.1ST
ltp/testcases/kernel/syscalls/epoll/epoll-ltp.c
ltp/testcases/kernel/syscalls/epoll2/examples/epoll-test.c
ltp/testcases/kernel/syscalls/epoll2/man/epoll.4
ltp/testcases/kernel/syscalls/epoll2/man/epoll_create.2
ltp/testcases/kernel/syscalls/epoll2/man/epoll_ctl.2
ltp/testcases/kernel/syscalls/epoll2/man/epoll_wait.2
ltp/testcases/kernel/syscalls/epoll2/src/epoll.c
ltp/testcases/kernel/syscalls/epoll_create1/epoll_create1_01.c
ltp/testcases/kernel/syscalls/eventfd/eventfd01.c
ltp/testcases/kernel/syscalls/eventfd2/eventfd2_01.c
ltp/testcases/kernel/syscalls/eventfd2/eventfd2_02.c
ltp/testcases/kernel/syscalls/execl/execl01.c
ltp/testcases/kernel/syscalls/execle/execle01.c
ltp/testcases/kernel/syscalls/execlp/execlp01.c
ltp/testcases/kernel/syscalls/execv/execv01.c
ltp/testcases/kernel/syscalls/execve/execve01.c
ltp/testcases/kernel/syscalls/execve/execve02.c
ltp/testcases/kernel/syscalls/execve/execve03.c
ltp/testcases/kernel/syscalls/execve/execve04.c
ltp/testcases/kernel/syscalls/execve/execve05.c
ltp/testcases/kernel/syscalls/execve/execve06.c
ltp/testcases/kernel/syscalls/execvp/execvp01.c
ltp/testcases/kernel/syscalls/exit/exit01.c
ltp/testcases/kernel/syscalls/exit/exit02.c
ltp/testcases/kernel/syscalls/faccessat/faccessat01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise02.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c
ltp/testcases/kernel/syscalls/fchdir/fchdir01.c
ltp/testcases/kernel/syscalls/fchdir/fchdir02.c
ltp/testcases/kernel/syscalls/fchdir/fchdir03.c
ltp/testcases/kernel/syscalls/fchmod/change_owner.c
ltp/testcases/kernel/syscalls/fchmod/change_owner.mode.sh
ltp/testcases/kernel/syscalls/fchmod/fchmod01.c
ltp/testcases/kernel/syscalls/fchmod/fchmod02.c
ltp/testcases/kernel/syscalls/fchmod/fchmod03.c
ltp/testcases/kernel/syscalls/fchmod/fchmod04.c
ltp/testcases/kernel/syscalls/fchmod/fchmod05.c
ltp/testcases/kernel/syscalls/fchmod/fchmod06.c
ltp/testcases/kernel/syscalls/fchmod/fchmod07.c
ltp/testcases/kernel/syscalls/fchmodat/fchmodat01.c
ltp/testcases/kernel/syscalls/fchown/change_owner.mode.sh
ltp/testcases/kernel/syscalls/fchownat/fchownat01.c
ltp/testcases/kernel/syscalls/fcntl/fcntl01.c
ltp/testcases/kernel/syscalls/fcntl/fcntl02.c
ltp/testcases/kernel/syscalls/fcntl/fcntl03.c
ltp/testcases/kernel/syscalls/fcntl/fcntl04.c
ltp/testcases/kernel/syscalls/fcntl/fcntl05.c
ltp/testcases/kernel/syscalls/fcntl/fcntl06.c
ltp/testcases/kernel/syscalls/fcntl/fcntl07.c
ltp/testcases/kernel/syscalls/fcntl/fcntl07B.c
ltp/testcases/kernel/syscalls/fcntl/fcntl08.c
ltp/testcases/kernel/syscalls/fcntl/fcntl09.c
ltp/testcases/kernel/syscalls/fcntl/fcntl10.c
ltp/testcases/kernel/syscalls/fcntl/fcntl11.c
ltp/testcases/kernel/syscalls/fcntl/fcntl12.c
ltp/testcases/kernel/syscalls/fcntl/fcntl13.c
ltp/testcases/kernel/syscalls/fcntl/fcntl14.c
ltp/testcases/kernel/syscalls/fcntl/fcntl15.c
ltp/testcases/kernel/syscalls/fcntl/fcntl16.c
ltp/testcases/kernel/syscalls/fcntl/fcntl17.c
ltp/testcases/kernel/syscalls/fcntl/fcntl18.c
ltp/testcases/kernel/syscalls/fcntl/fcntl19.c
ltp/testcases/kernel/syscalls/fcntl/fcntl20.c
ltp/testcases/kernel/syscalls/fcntl/fcntl21.c
ltp/testcases/kernel/syscalls/fcntl/fcntl22.c
ltp/testcases/kernel/syscalls/fcntl/fcntl23.c
ltp/testcases/kernel/syscalls/fcntl/fcntl24.c
ltp/testcases/kernel/syscalls/fcntl/fcntl25.c
ltp/testcases/kernel/syscalls/fcntl/fcntl26.c
ltp/testcases/kernel/syscalls/fcntl/fcntl27.c
ltp/testcases/kernel/syscalls/fcntl/fcntl28.c
ltp/testcases/kernel/syscalls/fdatasync/fdatasync01.c
ltp/testcases/kernel/syscalls/fdatasync/fdatasync02.c
ltp/testcases/kernel/syscalls/flock/flock01.c
ltp/testcases/kernel/syscalls/flock/flock02.c
ltp/testcases/kernel/syscalls/flock/flock03.c
ltp/testcases/kernel/syscalls/flock/flock04.c
ltp/testcases/kernel/syscalls/flock/flock05.c
ltp/testcases/kernel/syscalls/flock/flock06.c
ltp/testcases/kernel/syscalls/fmtmsg/fmtmsg01.c
ltp/testcases/kernel/syscalls/fork/fork01.c
ltp/testcases/kernel/syscalls/fork/fork02.c
ltp/testcases/kernel/syscalls/fork/fork03.c
ltp/testcases/kernel/syscalls/fork/fork04.c
ltp/testcases/kernel/syscalls/fork/fork05.c
ltp/testcases/kernel/syscalls/fork/fork06.c
ltp/testcases/kernel/syscalls/fork/fork07.c
ltp/testcases/kernel/syscalls/fork/fork08.c
ltp/testcases/kernel/syscalls/fork/fork09.c
ltp/testcases/kernel/syscalls/fork/fork10.c
ltp/testcases/kernel/syscalls/fork/fork11.c
ltp/testcases/kernel/syscalls/fork/fork12.c
ltp/testcases/kernel/syscalls/fpathconf/fpathconf01.c
ltp/testcases/kernel/syscalls/fstat/fstat01.c
ltp/testcases/kernel/syscalls/fstat/fstat02.c
ltp/testcases/kernel/syscalls/fstat/fstat03.c
ltp/testcases/kernel/syscalls/fstat/fstat04.c
ltp/testcases/kernel/syscalls/fstat/fstat05.c
ltp/testcases/kernel/syscalls/fstatat/fstatat01.c
ltp/testcases/kernel/syscalls/fstatfs/fstatfs01.c
ltp/testcases/kernel/syscalls/fstatfs/fstatfs02.c
ltp/testcases/kernel/syscalls/fsync/fsync01.c
ltp/testcases/kernel/syscalls/fsync/fsync02.c
ltp/testcases/kernel/syscalls/fsync/fsync03.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate01.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate02.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate03.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c
ltp/testcases/kernel/syscalls/get_robust_list/get_robust_list01.c
ltp/testcases/kernel/syscalls/getcontext/getcontext01.c
ltp/testcases/kernel/syscalls/getcpu/getcpu01.c
ltp/testcases/kernel/syscalls/getcwd/getcwd01.c
ltp/testcases/kernel/syscalls/getcwd/getcwd02.c
ltp/testcases/kernel/syscalls/getcwd/getcwd03.c
ltp/testcases/kernel/syscalls/getdents/getdents01.c
ltp/testcases/kernel/syscalls/getdents/getdents02.c
ltp/testcases/kernel/syscalls/getdents/getdents03.c
ltp/testcases/kernel/syscalls/getdents/getdents04.c
ltp/testcases/kernel/syscalls/getdomainname/getdomainname01.c
ltp/testcases/kernel/syscalls/getdtablesize/getdtablesize01.c
ltp/testcases/kernel/syscalls/getegid/getegid01.c
ltp/testcases/kernel/syscalls/getegid/getegid02.c
ltp/testcases/kernel/syscalls/geteuid/geteuid01.c
ltp/testcases/kernel/syscalls/getgid/getgid01.c
ltp/testcases/kernel/syscalls/getgid/getgid03.c
ltp/testcases/kernel/syscalls/getgroups/getgroups01.c
ltp/testcases/kernel/syscalls/getgroups/getgroups02.c
ltp/testcases/kernel/syscalls/getgroups/getgroups03.c
ltp/testcases/kernel/syscalls/getgroups/getgroups04.c
ltp/testcases/kernel/syscalls/gethostid/gethostid01.c
ltp/testcases/kernel/syscalls/gethostname/gethostname01.c
ltp/testcases/kernel/syscalls/getitimer/getitimer01.c
ltp/testcases/kernel/syscalls/getitimer/getitimer02.c
ltp/testcases/kernel/syscalls/getitimer/getitimer03.c
ltp/testcases/kernel/syscalls/getpagesize/getpagesize01.c
ltp/testcases/kernel/syscalls/getpeername/getpeername01.c
ltp/testcases/kernel/syscalls/getpgid/getpgid01.c
ltp/testcases/kernel/syscalls/getpgid/getpgid02.c
ltp/testcases/kernel/syscalls/getpgrp/getpgrp01.c
ltp/testcases/kernel/syscalls/getpid/getpid01.c
ltp/testcases/kernel/syscalls/getpid/getpid02.c
ltp/testcases/kernel/syscalls/getppid/getppid01.c
ltp/testcases/kernel/syscalls/getppid/getppid02.c
ltp/testcases/kernel/syscalls/getpriority/getpriority01.c
ltp/testcases/kernel/syscalls/getpriority/getpriority02.c
ltp/testcases/kernel/syscalls/getresgid/getresgid01.c
ltp/testcases/kernel/syscalls/getresgid/getresgid02.c
ltp/testcases/kernel/syscalls/getresgid/getresgid03.c
ltp/testcases/kernel/syscalls/getresuid/getresuid01.c
ltp/testcases/kernel/syscalls/getresuid/getresuid02.c
ltp/testcases/kernel/syscalls/getresuid/getresuid03.c
ltp/testcases/kernel/syscalls/getrlimit/getrlimit01.c
ltp/testcases/kernel/syscalls/getrlimit/getrlimit02.c
ltp/testcases/kernel/syscalls/getrusage/getrusage01.c
ltp/testcases/kernel/syscalls/getrusage/getrusage02.c
ltp/testcases/kernel/syscalls/getsid/getsid01.c
ltp/testcases/kernel/syscalls/getsid/getsid02.c
ltp/testcases/kernel/syscalls/getsockname/getsockname01.c
ltp/testcases/kernel/syscalls/getsockopt/getsockopt01.c
ltp/testcases/kernel/syscalls/gettid/gettid01.c
ltp/testcases/kernel/syscalls/gettimeofday/gettimeofday01.c
ltp/testcases/kernel/syscalls/gettimeofday/gettimeofday02.c
ltp/testcases/kernel/syscalls/getuid/getuid01.c
ltp/testcases/kernel/syscalls/getuid/getuid02.c
ltp/testcases/kernel/syscalls/getuid/getuid03.c
ltp/testcases/kernel/syscalls/inotify/README
ltp/testcases/kernel/syscalls/inotify/inotify01.c
ltp/testcases/kernel/syscalls/inotify/inotify02.c
ltp/testcases/kernel/syscalls/inotify/inotify03.c
ltp/testcases/kernel/syscalls/inotify_init/inotify_init1_01.c
ltp/testcases/kernel/syscalls/inotify_init/inotify_init1_02.c
ltp/testcases/kernel/syscalls/io_cancel/io_cancel01.c
ltp/testcases/kernel/syscalls/io_destroy/io_destroy01.c
ltp/testcases/kernel/syscalls/io_getevents/io_getevents01.c
ltp/testcases/kernel/syscalls/io_setup/io_setup01.c
ltp/testcases/kernel/syscalls/io_submit/io_submit01.c
ltp/testcases/kernel/syscalls/ioctl/ioctl01.c
ltp/testcases/kernel/syscalls/ioctl/ioctl02.c
ltp/testcases/kernel/syscalls/ioctl/ioctl03.c
ltp/testcases/kernel/syscalls/ioctl/test_ioctl
ltp/testcases/kernel/syscalls/ioperm/ioperm01.c
ltp/testcases/kernel/syscalls/ioperm/ioperm02.c
ltp/testcases/kernel/syscalls/iopl/iopl01.c
ltp/testcases/kernel/syscalls/iopl/iopl02.c
ltp/testcases/kernel/syscalls/ipc/lib/libipc.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl01.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl02.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl03.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl04.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl05.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl06.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl07.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl08.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl09.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl10.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl11.c
ltp/testcases/kernel/syscalls/ipc/msgget/msgget01.c
ltp/testcases/kernel/syscalls/ipc/msgget/msgget02.c
ltp/testcases/kernel/syscalls/ipc/msgget/msgget03.c
ltp/testcases/kernel/syscalls/ipc/msgget/msgget04.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv01.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv02.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv03.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv04.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv05.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv06.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd01.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd02.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd03.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd04.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd05.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd06.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl01.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl02.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl03.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl04.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl05.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl06.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl07.c
ltp/testcases/kernel/syscalls/ipc/semget/semget01.c
ltp/testcases/kernel/syscalls/ipc/semget/semget02.c
ltp/testcases/kernel/syscalls/ipc/semget/semget03.c
ltp/testcases/kernel/syscalls/ipc/semget/semget05.c
ltp/testcases/kernel/syscalls/ipc/semget/semget06.c
ltp/testcases/kernel/syscalls/ipc/semop/semop01.c
ltp/testcases/kernel/syscalls/ipc/semop/semop02.c
ltp/testcases/kernel/syscalls/ipc/semop/semop03.c
ltp/testcases/kernel/syscalls/ipc/semop/semop04.c
ltp/testcases/kernel/syscalls/ipc/semop/semop05.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat01.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat02.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat03.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl01.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl02.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl03.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl04.c
ltp/testcases/kernel/syscalls/ipc/shmdt/shmdt01.c
ltp/testcases/kernel/syscalls/ipc/shmdt/shmdt02.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget01.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget02.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget03.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget04.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget05.c
ltp/testcases/kernel/syscalls/kill/kill01.c
ltp/testcases/kernel/syscalls/kill/kill02.c
ltp/testcases/kernel/syscalls/kill/kill03.c
ltp/testcases/kernel/syscalls/kill/kill04.c
ltp/testcases/kernel/syscalls/kill/kill05.c
ltp/testcases/kernel/syscalls/kill/kill06.c
ltp/testcases/kernel/syscalls/kill/kill07.c
ltp/testcases/kernel/syscalls/kill/kill08.c
ltp/testcases/kernel/syscalls/kill/kill09.c
ltp/testcases/kernel/syscalls/kill/kill10.c
ltp/testcases/kernel/syscalls/kill/kill11.c
ltp/testcases/kernel/syscalls/kill/kill12.c
ltp/testcases/kernel/syscalls/lchown/create_link.c
ltp/testcases/kernel/syscalls/lchown/create_link.mode.sh
ltp/testcases/kernel/syscalls/lchown/lchown01.c
ltp/testcases/kernel/syscalls/lchown/lchown02.c
ltp/testcases/kernel/syscalls/libevent/buffer.c
ltp/testcases/kernel/syscalls/libevent/epoll.c
ltp/testcases/kernel/syscalls/libevent/epoll_sub.c
ltp/testcases/kernel/syscalls/libevent/err.c
ltp/testcases/kernel/syscalls/libevent/evbuffer.c
ltp/testcases/kernel/syscalls/libevent/event.3
ltp/testcases/kernel/syscalls/libevent/event.c
ltp/testcases/kernel/syscalls/libevent/install-sh
ltp/testcases/kernel/syscalls/libevent/kqueue.c
ltp/testcases/kernel/syscalls/libevent/poll.c
ltp/testcases/kernel/syscalls/libevent/rtsig.c
ltp/testcases/kernel/syscalls/libevent/select.c
ltp/testcases/kernel/syscalls/libevent/signal.c
ltp/testcases/kernel/syscalls/libevent/sample/event-test.c
ltp/testcases/kernel/syscalls/libevent/sample/signal-test.c
ltp/testcases/kernel/syscalls/libevent/sample/time-test.c
ltp/testcases/kernel/syscalls/libevent/test/bench.c
ltp/testcases/kernel/syscalls/libevent/test/regress.c
ltp/testcases/kernel/syscalls/libevent/test/test-eof.c
ltp/testcases/kernel/syscalls/libevent/test/test-init.c
ltp/testcases/kernel/syscalls/libevent/test/test-time.c
ltp/testcases/kernel/syscalls/libevent/test/test-weof.c
ltp/testcases/kernel/syscalls/libevent/test/test.sh
ltp/testcases/kernel/syscalls/link/link02.c
ltp/testcases/kernel/syscalls/link/link03.c
ltp/testcases/kernel/syscalls/link/link04.c
ltp/testcases/kernel/syscalls/link/link05.c
ltp/testcases/kernel/syscalls/link/link06.c
ltp/testcases/kernel/syscalls/link/link07.c
ltp/testcases/kernel/syscalls/linkat/linkat01.c
ltp/testcases/kernel/syscalls/listen/listen01.c
ltp/testcases/kernel/syscalls/llseek/llseek01.c
ltp/testcases/kernel/syscalls/llseek/llseek02.c
ltp/testcases/kernel/syscalls/lseek/lseek01.c
ltp/testcases/kernel/syscalls/lseek/lseek02.c
ltp/testcases/kernel/syscalls/lseek/lseek03.c
ltp/testcases/kernel/syscalls/lseek/lseek04.c
ltp/testcases/kernel/syscalls/lseek/lseek05.c
ltp/testcases/kernel/syscalls/lseek/lseek06.c
ltp/testcases/kernel/syscalls/lseek/lseek07.c
ltp/testcases/kernel/syscalls/lseek/lseek08.c
ltp/testcases/kernel/syscalls/lseek/lseek09.c
ltp/testcases/kernel/syscalls/lseek/lseek10.c
ltp/testcases/kernel/syscalls/lstat/lstat01.c
ltp/testcases/kernel/syscalls/lstat/lstat02.c
ltp/testcases/kernel/syscalls/lstat/lstat03.c
ltp/testcases/kernel/syscalls/madvise/madvise01.c
ltp/testcases/kernel/syscalls/madvise/madvise02.c
ltp/testcases/kernel/syscalls/madvise/madvise03.c
ltp/testcases/kernel/syscalls/mallopt/mallopt01.c
ltp/testcases/kernel/syscalls/memcmp/memcmp01.c
ltp/testcases/kernel/syscalls/memcpy/memcpy01.c
ltp/testcases/kernel/syscalls/memmap/mem03.c
ltp/testcases/kernel/syscalls/memset/memset01.c
ltp/testcases/kernel/syscalls/mincore/mincore01.c
ltp/testcases/kernel/syscalls/mincore/mincore02.c
ltp/testcases/kernel/syscalls/mkdir/mkdir01.c
ltp/testcases/kernel/syscalls/mkdir/mkdir02.c
ltp/testcases/kernel/syscalls/mkdir/mkdir03.c
ltp/testcases/kernel/syscalls/mkdir/mkdir04.c
ltp/testcases/kernel/syscalls/mkdir/mkdir05.c
ltp/testcases/kernel/syscalls/mkdir/mkdir08.c
ltp/testcases/kernel/syscalls/mkdir/mkdir09.c
ltp/testcases/kernel/syscalls/mknod/mknod01.c
ltp/testcases/kernel/syscalls/mknod/mknod02.c
ltp/testcases/kernel/syscalls/mknod/mknod03.c
ltp/testcases/kernel/syscalls/mknod/mknod04.c
ltp/testcases/kernel/syscalls/mknod/mknod05.c
ltp/testcases/kernel/syscalls/mknod/mknod06.c
ltp/testcases/kernel/syscalls/mknod/mknod07.c
ltp/testcases/kernel/syscalls/mknod/mknod08.c
ltp/testcases/kernel/syscalls/mknod/mknod09.c
ltp/testcases/kernel/syscalls/mknodat/mknodat01.c
ltp/testcases/kernel/syscalls/mlock/mlock01.c
ltp/testcases/kernel/syscalls/mlock/mlock02.c
ltp/testcases/kernel/syscalls/mlockall/mlockall01.c
ltp/testcases/kernel/syscalls/mlockall/mlockall02.c
ltp/testcases/kernel/syscalls/mlockall/mlockall03.c
ltp/testcases/kernel/syscalls/mmap/mmap001.c
ltp/testcases/kernel/syscalls/mmap/mmap01.c
ltp/testcases/kernel/syscalls/mmap/mmap02.c
ltp/testcases/kernel/syscalls/mmap/mmap03.c
ltp/testcases/kernel/syscalls/mmap/mmap04.c
ltp/testcases/kernel/syscalls/mmap/mmap05.c
ltp/testcases/kernel/syscalls/mmap/mmap06.c
ltp/testcases/kernel/syscalls/mmap/mmap07.c
ltp/testcases/kernel/syscalls/mmap/mmap08.c
ltp/testcases/kernel/syscalls/mmap/mmap09.c
ltp/testcases/kernel/syscalls/modify_ldt/modify_ldt01.c
ltp/testcases/kernel/syscalls/modify_ldt/modify_ldt02.c
ltp/testcases/kernel/syscalls/mount/mount01.c
ltp/testcases/kernel/syscalls/mount/mount02.c
ltp/testcases/kernel/syscalls/mount/mount03.c
ltp/testcases/kernel/syscalls/mount/mount04.c
ltp/testcases/kernel/syscalls/mount/setuid_test.c
ltp/testcases/kernel/syscalls/mount/setuid_test.mode.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages01.c
ltp/testcases/kernel/syscalls/move_pages/move_pages02.c
ltp/testcases/kernel/syscalls/move_pages/move_pages03.c
ltp/testcases/kernel/syscalls/move_pages/move_pages04.c
ltp/testcases/kernel/syscalls/move_pages/move_pages05.c
ltp/testcases/kernel/syscalls/move_pages/move_pages06.c
ltp/testcases/kernel/syscalls/move_pages/move_pages07.c
ltp/testcases/kernel/syscalls/move_pages/move_pages08.c
ltp/testcases/kernel/syscalls/move_pages/move_pages09.c
ltp/testcases/kernel/syscalls/move_pages/move_pages10.c
ltp/testcases/kernel/syscalls/move_pages/move_pages11.c
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.c
ltp/testcases/kernel/syscalls/mprotect/mprotect01.c
ltp/testcases/kernel/syscalls/mprotect/mprotect02.c
ltp/testcases/kernel/syscalls/mprotect/mprotect03.c
ltp/testcases/kernel/syscalls/mremap/mremap01.c
ltp/testcases/kernel/syscalls/mremap/mremap02.c
ltp/testcases/kernel/syscalls/mremap/mremap03.c
ltp/testcases/kernel/syscalls/mremap/mremap04.c
ltp/testcases/kernel/syscalls/msync/msync01.c
ltp/testcases/kernel/syscalls/msync/msync02.c
ltp/testcases/kernel/syscalls/msync/msync03.c
ltp/testcases/kernel/syscalls/msync/msync04.c
ltp/testcases/kernel/syscalls/msync/msync05.c
ltp/testcases/kernel/syscalls/munlock/munlock01.c
ltp/testcases/kernel/syscalls/munlock/munlock02.c
ltp/testcases/kernel/syscalls/munlockall/munlockall01.c
ltp/testcases/kernel/syscalls/munlockall/munlockall02.c
ltp/testcases/kernel/syscalls/munmap/munmap01.c
ltp/testcases/kernel/syscalls/munmap/munmap02.c
ltp/testcases/kernel/syscalls/munmap/munmap03.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep01.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep02.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep03.c
ltp/testcases/kernel/syscalls/nanosleep/nanosleep04.c
ltp/testcases/kernel/syscalls/nftw/lib.c
ltp/testcases/kernel/syscalls/nftw/lib64.c
ltp/testcases/kernel/syscalls/nftw/nftw.c
ltp/testcases/kernel/syscalls/nftw/nftw64.c
ltp/testcases/kernel/syscalls/nftw/test.c
ltp/testcases/kernel/syscalls/nftw/test64.c
ltp/testcases/kernel/syscalls/nftw/test_func.c
ltp/testcases/kernel/syscalls/nftw/test_func64.c
ltp/testcases/kernel/syscalls/nftw/tools.c
ltp/testcases/kernel/syscalls/nftw/tools64.c
ltp/testcases/kernel/syscalls/nice/nice01.c
ltp/testcases/kernel/syscalls/nice/nice02.c
ltp/testcases/kernel/syscalls/nice/nice03.c
ltp/testcases/kernel/syscalls/nice/nice04.c
ltp/testcases/kernel/syscalls/nice/nice05.c
ltp/testcases/kernel/syscalls/open/open01.c
ltp/testcases/kernel/syscalls/open/open02.c
ltp/testcases/kernel/syscalls/open/open03.c
ltp/testcases/kernel/syscalls/open/open04.c
ltp/testcases/kernel/syscalls/open/open05.c
ltp/testcases/kernel/syscalls/open/open06.c
ltp/testcases/kernel/syscalls/open/open07.c
ltp/testcases/kernel/syscalls/open/open08.c
ltp/testcases/kernel/syscalls/open/open09.c
ltp/testcases/kernel/syscalls/open/open10.c
ltp/testcases/kernel/syscalls/openat/openat01.c
ltp/testcases/kernel/syscalls/pathconf/pathconf01.c
ltp/testcases/kernel/syscalls/pause/pause01.c
ltp/testcases/kernel/syscalls/pause/pause02.c
ltp/testcases/kernel/syscalls/pause/pause03.c
ltp/testcases/kernel/syscalls/pcllib/README
ltp/testcases/kernel/syscalls/pcllib/config.guess
ltp/testcases/kernel/syscalls/pcllib/libtool
ltp/testcases/kernel/syscalls/pcllib/ltmain.sh
ltp/testcases/kernel/syscalls/pcllib/pcl/pcl.c
ltp/testcases/kernel/syscalls/pcllib/pcl/pcl_version.c
ltp/testcases/kernel/syscalls/pcllib/test/cobench.c
ltp/testcases/kernel/syscalls/pcllib/test/cothread.c
ltp/testcases/kernel/syscalls/personality/personality01.c
ltp/testcases/kernel/syscalls/personality/personality02.c
ltp/testcases/kernel/syscalls/pipe/pipe01.c
ltp/testcases/kernel/syscalls/pipe/pipe02.c
ltp/testcases/kernel/syscalls/pipe/pipe03.c
ltp/testcases/kernel/syscalls/pipe/pipe04.c
ltp/testcases/kernel/syscalls/pipe/pipe05.c
ltp/testcases/kernel/syscalls/pipe/pipe06.c
ltp/testcases/kernel/syscalls/pipe/pipe07.c
ltp/testcases/kernel/syscalls/pipe/pipe08.c
ltp/testcases/kernel/syscalls/pipe/pipe09.c
ltp/testcases/kernel/syscalls/pipe/pipe10.c
ltp/testcases/kernel/syscalls/pipe/pipe11.c
ltp/testcases/kernel/syscalls/pipe2/pipe2_01.c
ltp/testcases/kernel/syscalls/pipe2/pipe2_02.c
ltp/testcases/kernel/syscalls/poll/poll01.c
ltp/testcases/kernel/syscalls/prctl/prctl01.c
ltp/testcases/kernel/syscalls/prctl/prctl02.c
ltp/testcases/kernel/syscalls/pread/pread01.c
ltp/testcases/kernel/syscalls/pread/pread02.c
ltp/testcases/kernel/syscalls/pread/pread03.c
ltp/testcases/kernel/syscalls/profil/profil01.c
ltp/testcases/kernel/syscalls/pselect/pselect01.c
ltp/testcases/kernel/syscalls/ptrace/ptrace01.c
ltp/testcases/kernel/syscalls/ptrace/ptrace02.c
ltp/testcases/kernel/syscalls/ptrace/ptrace03.c
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c
ltp/testcases/kernel/syscalls/ptrace/ptrace06.c
ltp/testcases/kernel/syscalls/pwrite/pwrite01.c
ltp/testcases/kernel/syscalls/pwrite/pwrite02.c
ltp/testcases/kernel/syscalls/pwrite/pwrite03.c
ltp/testcases/kernel/syscalls/pwrite/pwrite04.c
ltp/testcases/kernel/syscalls/read/read01.c
ltp/testcases/kernel/syscalls/read/read02.c
ltp/testcases/kernel/syscalls/read/read03.c
ltp/testcases/kernel/syscalls/read/read04.c
ltp/testcases/kernel/syscalls/readdir/readdir01.c
ltp/testcases/kernel/syscalls/readdir/readdir02.c
ltp/testcases/kernel/syscalls/readlink/creat_slink.c
ltp/testcases/kernel/syscalls/readlink/readlink01.c
ltp/testcases/kernel/syscalls/readlink/readlink02.c
ltp/testcases/kernel/syscalls/readlink/readlink03.c
ltp/testcases/kernel/syscalls/readlink/readlink04.c
ltp/testcases/kernel/syscalls/readlinkat/readlinkat01.c
ltp/testcases/kernel/syscalls/readv/readv01.c
ltp/testcases/kernel/syscalls/readv/readv02.c
ltp/testcases/kernel/syscalls/readv/readv03.c
ltp/testcases/kernel/syscalls/reboot/reboot01.c
ltp/testcases/kernel/syscalls/reboot/reboot02.c
ltp/testcases/kernel/syscalls/recv/recv01.c
ltp/testcases/kernel/syscalls/recvfrom/recvfrom01.c
ltp/testcases/kernel/syscalls/recvmsg/recvmsg01.c
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages02.c
ltp/testcases/kernel/syscalls/rename/rename01.c
ltp/testcases/kernel/syscalls/rename/rename02.c
ltp/testcases/kernel/syscalls/rename/rename03.c
ltp/testcases/kernel/syscalls/rename/rename04.c
ltp/testcases/kernel/syscalls/rename/rename05.c
ltp/testcases/kernel/syscalls/rename/rename06.c
ltp/testcases/kernel/syscalls/rename/rename07.c
ltp/testcases/kernel/syscalls/rename/rename08.c
ltp/testcases/kernel/syscalls/rename/rename09.c
ltp/testcases/kernel/syscalls/rename/rename10.c
ltp/testcases/kernel/syscalls/rename/rename12.c
ltp/testcases/kernel/syscalls/rename/rename13.c
ltp/testcases/kernel/syscalls/rename/rename14.c
ltp/testcases/kernel/syscalls/renameat/renameat01.c
ltp/testcases/kernel/syscalls/rmdir/rmdir01.c
ltp/testcases/kernel/syscalls/rmdir/rmdir02.c
ltp/testcases/kernel/syscalls/rmdir/rmdir03.c
ltp/testcases/kernel/syscalls/rmdir/rmdir04.c
ltp/testcases/kernel/syscalls/rmdir/rmdir05.c
ltp/testcases/kernel/syscalls/sbrk/sbrk01.c
ltp/testcases/kernel/syscalls/sched_get_priority_max/sched_get_priority_max=
01.c
ltp/testcases/kernel/syscalls/sched_get_priority_max/sched_get_priority_max=
02.c
ltp/testcases/kernel/syscalls/sched_get_priority_min/sched_get_priority_min=
01.c
ltp/testcases/kernel/syscalls/sched_get_priority_min/sched_get_priority_min=
02.c
ltp/testcases/kernel/syscalls/sched_getparam/sched_getparam01.c
ltp/testcases/kernel/syscalls/sched_getparam/sched_getparam02.c
ltp/testcases/kernel/syscalls/sched_getparam/sched_getparam03.c
ltp/testcases/kernel/syscalls/sched_getscheduler/sched_getscheduler01.c
ltp/testcases/kernel/syscalls/sched_getscheduler/sched_getscheduler02.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval01=
.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval02=
.c
ltp/testcases/kernel/syscalls/sched_rr_get_interval/sched_rr_get_interval03=
.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam01.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam02.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam03.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam04.c
ltp/testcases/kernel/syscalls/sched_setparam/sched_setparam05.c
ltp/testcases/kernel/syscalls/sched_setscheduler/sched_setscheduler01.c
ltp/testcases/kernel/syscalls/sched_setscheduler/sched_setscheduler02.c
ltp/testcases/kernel/syscalls/sched_yield/sched_yield01.c
ltp/testcases/kernel/syscalls/select/select01.c
ltp/testcases/kernel/syscalls/select/select02.c
ltp/testcases/kernel/syscalls/select/select03.c
ltp/testcases/kernel/syscalls/send/send01.c
ltp/testcases/kernel/syscalls/sendfile/sendfile02.c
ltp/testcases/kernel/syscalls/sendfile/sendfile03.c
ltp/testcases/kernel/syscalls/sendfile/sendfile04.c
ltp/testcases/kernel/syscalls/sendfile/sendfile05.c
ltp/testcases/kernel/syscalls/sendfile/sendfile06.c
ltp/testcases/kernel/syscalls/sendfile/sendfile07.c
ltp/testcases/kernel/syscalls/sendmsg/sendmsg01.c
ltp/testcases/kernel/syscalls/sendto/sendto01.c
ltp/testcases/kernel/syscalls/set_robust_list/set_robust_list01.c
ltp/testcases/kernel/syscalls/setdomainname/setdomainname01.c
ltp/testcases/kernel/syscalls/setdomainname/setdomainname02.c
ltp/testcases/kernel/syscalls/setdomainname/setdomainname03.c
ltp/testcases/kernel/syscalls/setegid/setegid01.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid01.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid02.c
ltp/testcases/kernel/syscalls/setfsgid/setfsgid03.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid01.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid02.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid03.c
ltp/testcases/kernel/syscalls/setfsuid/setfsuid04.c
ltp/testcases/kernel/syscalls/setgid/setgid01.c
ltp/testcases/kernel/syscalls/setgid/setgid02.c
ltp/testcases/kernel/syscalls/setgid/setgid03.c
ltp/testcases/kernel/syscalls/setgroups/setgroups01.c
ltp/testcases/kernel/syscalls/setgroups/setgroups02.c
ltp/testcases/kernel/syscalls/setgroups/setgroups03.c
ltp/testcases/kernel/syscalls/setgroups/setgroups04.c
ltp/testcases/kernel/syscalls/sethostname/sethostname01.c
ltp/testcases/kernel/syscalls/sethostname/sethostname02.c
ltp/testcases/kernel/syscalls/sethostname/sethostname03.c
ltp/testcases/kernel/syscalls/setitimer/setitimer01.c
ltp/testcases/kernel/syscalls/setitimer/setitimer02.c
ltp/testcases/kernel/syscalls/setitimer/setitimer03.c
ltp/testcases/kernel/syscalls/setpgid/setpgid01.c
ltp/testcases/kernel/syscalls/setpgid/setpgid02.c
ltp/testcases/kernel/syscalls/setpgid/setpgid03.c
ltp/testcases/kernel/syscalls/setpgrp/setpgrp01.c
ltp/testcases/kernel/syscalls/setpgrp/setpgrp02.c
ltp/testcases/kernel/syscalls/setpriority/setpriority01.c
ltp/testcases/kernel/syscalls/setpriority/setpriority02.c
ltp/testcases/kernel/syscalls/setpriority/setpriority03.c
ltp/testcases/kernel/syscalls/setpriority/setpriority04.c
ltp/testcases/kernel/syscalls/setpriority/setpriority05.c
ltp/testcases/kernel/syscalls/setregid/setregid01.c
ltp/testcases/kernel/syscalls/setregid/setregid02.c
ltp/testcases/kernel/syscalls/setregid/setregid03.c
ltp/testcases/kernel/syscalls/setregid/setregid04.c
ltp/testcases/kernel/syscalls/setresgid/setresgid01.c
ltp/testcases/kernel/syscalls/setresgid/setresgid02.c
ltp/testcases/kernel/syscalls/setresgid/setresgid03.c
ltp/testcases/kernel/syscalls/setresuid/setresuid01.c
ltp/testcases/kernel/syscalls/setresuid/setresuid02.c
ltp/testcases/kernel/syscalls/setresuid/setresuid03.c
ltp/testcases/kernel/syscalls/setresuid/setresuid04.c
ltp/testcases/kernel/syscalls/setreuid/setreuid01.c
ltp/testcases/kernel/syscalls/setreuid/setreuid02.c
ltp/testcases/kernel/syscalls/setreuid/setreuid03.c
ltp/testcases/kernel/syscalls/setreuid/setreuid04.c
ltp/testcases/kernel/syscalls/setreuid/setreuid05.c
ltp/testcases/kernel/syscalls/setreuid/setreuid06.c
ltp/testcases/kernel/syscalls/setreuid/setreuid07.c
ltp/testcases/kernel/syscalls/setrlimit/setrlimit01.c
ltp/testcases/kernel/syscalls/setrlimit/setrlimit02.c
ltp/testcases/kernel/syscalls/setrlimit/setrlimit03.c
ltp/testcases/kernel/syscalls/setsid/setsid01.c
ltp/testcases/kernel/syscalls/setsockopt/setsockopt01.c
ltp/testcases/kernel/syscalls/settimeofday/settimeofday01.c
ltp/testcases/kernel/syscalls/settimeofday/settimeofday02.c
ltp/testcases/kernel/syscalls/setuid/setuid01.c
ltp/testcases/kernel/syscalls/setuid/setuid02.c
ltp/testcases/kernel/syscalls/setuid/setuid03.c
ltp/testcases/kernel/syscalls/setuid/setuid04.c
ltp/testcases/kernel/syscalls/sigaction/sigaction01.c
ltp/testcases/kernel/syscalls/sigaction/sigaction02.c
ltp/testcases/kernel/syscalls/sigaltstack/sigaltstack01.c
ltp/testcases/kernel/syscalls/sigaltstack/sigaltstack02.c
ltp/testcases/kernel/syscalls/sighold/sighold02.c
ltp/testcases/kernel/syscalls/signal/signal01.c
ltp/testcases/kernel/syscalls/signal/signal02.c
ltp/testcases/kernel/syscalls/signal/signal03.c
ltp/testcases/kernel/syscalls/signal/signal04.c
ltp/testcases/kernel/syscalls/signal/signal05.c
ltp/testcases/kernel/syscalls/signalfd/signalfd01.c
ltp/testcases/kernel/syscalls/signalfd4/signalfd4_01.c
ltp/testcases/kernel/syscalls/signalfd4/signalfd4_02.c
ltp/testcases/kernel/syscalls/sigpending/sigpending02.c
ltp/testcases/kernel/syscalls/sigprocmask/sigprocmask01.c
ltp/testcases/kernel/syscalls/sigrelse/sigrelse01.c
ltp/testcases/kernel/syscalls/sigsuspend/sigsuspend01.c
ltp/testcases/kernel/syscalls/socket/socket01.c
ltp/testcases/kernel/syscalls/socket/socket02.c
ltp/testcases/kernel/syscalls/socket/socket03.c
ltp/testcases/kernel/syscalls/socketcall/socketcall01.c
ltp/testcases/kernel/syscalls/socketcall/socketcall02.c
ltp/testcases/kernel/syscalls/socketcall/socketcall03.c
ltp/testcases/kernel/syscalls/socketcall/socketcall04.c
ltp/testcases/kernel/syscalls/socketpair/socketpair01.c
ltp/testcases/kernel/syscalls/socketpair/socketpair02.c
ltp/testcases/kernel/syscalls/sockioctl/sockioctl01.c
ltp/testcases/kernel/syscalls/splice/splice01.c
ltp/testcases/kernel/syscalls/stat/stat01.c
ltp/testcases/kernel/syscalls/stat/stat02.c
ltp/testcases/kernel/syscalls/stat/stat03.c
ltp/testcases/kernel/syscalls/stat/stat05.c
ltp/testcases/kernel/syscalls/stat/stat06.c
ltp/testcases/kernel/syscalls/statfs/statfs01.c
ltp/testcases/kernel/syscalls/statfs/statfs02.c
ltp/testcases/kernel/syscalls/statfs/statfs03.c
ltp/testcases/kernel/syscalls/statvfs/statvfs01.c
ltp/testcases/kernel/syscalls/stime/stime01.c
ltp/testcases/kernel/syscalls/stime/stime02.c
ltp/testcases/kernel/syscalls/string/string01.c
ltp/testcases/kernel/syscalls/swapoff/swapoff01.c
ltp/testcases/kernel/syscalls/swapoff/swapoff02.c
ltp/testcases/kernel/syscalls/swapon/swapon01.c
ltp/testcases/kernel/syscalls/swapon/swapon02.c
ltp/testcases/kernel/syscalls/swapon/swapon03.c
ltp/testcases/kernel/syscalls/switch/endian_switch01.c
ltp/testcases/kernel/syscalls/symlink/symlink01.c
ltp/testcases/kernel/syscalls/symlink/symlink02.c
ltp/testcases/kernel/syscalls/symlink/symlink03.c
ltp/testcases/kernel/syscalls/symlink/symlink04.c
ltp/testcases/kernel/syscalls/symlink/symlink05.c
ltp/testcases/kernel/syscalls/symlinkat/symlinkat01.c
ltp/testcases/kernel/syscalls/sync/sync01.c
ltp/testcases/kernel/syscalls/sync/sync02.c
ltp/testcases/kernel/syscalls/sync_file_range/sync_file_range01.c
ltp/testcases/kernel/syscalls/syscall/syscall01.c
ltp/testcases/kernel/syscalls/sysconf/sysconf01.c
ltp/testcases/kernel/syscalls/sysctl/sysctl01.c
ltp/testcases/kernel/syscalls/sysctl/sysctl03.c
ltp/testcases/kernel/syscalls/sysctl/sysctl04.c
ltp/testcases/kernel/syscalls/sysctl/sysctl05.c
ltp/testcases/kernel/syscalls/sysfs/sysfs01.c
ltp/testcases/kernel/syscalls/sysfs/sysfs02.c
ltp/testcases/kernel/syscalls/sysfs/sysfs03.c
ltp/testcases/kernel/syscalls/sysfs/sysfs04.c
ltp/testcases/kernel/syscalls/sysfs/sysfs05.c
ltp/testcases/kernel/syscalls/sysfs/sysfs06.c
ltp/testcases/kernel/syscalls/sysinfo/sysinfo01.c
ltp/testcases/kernel/syscalls/sysinfo/sysinfo02.c
ltp/testcases/kernel/syscalls/syslog/syslog01
ltp/testcases/kernel/syscalls/syslog/syslog02
ltp/testcases/kernel/syscalls/syslog/syslog03
ltp/testcases/kernel/syscalls/syslog/syslog04
ltp/testcases/kernel/syscalls/syslog/syslog05
ltp/testcases/kernel/syscalls/syslog/syslog06
ltp/testcases/kernel/syscalls/syslog/syslog07
ltp/testcases/kernel/syscalls/syslog/syslog08
ltp/testcases/kernel/syscalls/syslog/syslog09
ltp/testcases/kernel/syscalls/syslog/syslog10
ltp/testcases/kernel/syscalls/syslog/syslog11.c
ltp/testcases/kernel/syscalls/syslog/syslog12.c
ltp/testcases/kernel/syscalls/syslog/syslogtst.c
ltp/testcases/kernel/syscalls/tee/tee01.c
ltp/testcases/kernel/syscalls/time/time01.c
ltp/testcases/kernel/syscalls/time/time02.c
ltp/testcases/kernel/syscalls/timerfd/timerfd01.c
ltp/testcases/kernel/syscalls/timerfd/timerfd02.c
ltp/testcases/kernel/syscalls/timerfd/timerfd03.c
ltp/testcases/kernel/syscalls/times/times01.c
ltp/testcases/kernel/syscalls/times/times03.c
ltp/testcases/kernel/syscalls/truncate/truncate01.c
ltp/testcases/kernel/syscalls/truncate/truncate02.c
ltp/testcases/kernel/syscalls/truncate/truncate03.c
ltp/testcases/kernel/syscalls/truncate/truncate04.c
ltp/testcases/kernel/syscalls/ulimit/ulimit01.c
ltp/testcases/kernel/syscalls/umask/umask01.c
ltp/testcases/kernel/syscalls/umask/umask02.c
ltp/testcases/kernel/syscalls/umask/umask03.c
ltp/testcases/kernel/syscalls/umount/umount01.c
ltp/testcases/kernel/syscalls/umount/umount02.c
ltp/testcases/kernel/syscalls/umount/umount03.c
ltp/testcases/kernel/syscalls/uname/uname01.c
ltp/testcases/kernel/syscalls/uname/uname02.c
ltp/testcases/kernel/syscalls/uname/uname03.c
ltp/testcases/kernel/syscalls/unlink/unlink05.c
ltp/testcases/kernel/syscalls/unlink/unlink06.c
ltp/testcases/kernel/syscalls/unlink/unlink07.c
ltp/testcases/kernel/syscalls/unlink/unlink08.c
ltp/testcases/kernel/syscalls/unlinkat/unlinkat01.c
ltp/testcases/kernel/syscalls/ustat/ustat01.c
ltp/testcases/kernel/syscalls/ustat/ustat02.c
ltp/testcases/kernel/syscalls/utime/utime01.c
ltp/testcases/kernel/syscalls/utime/utime02.c
ltp/testcases/kernel/syscalls/utime/utime03.c
ltp/testcases/kernel/syscalls/utime/utime04.c
ltp/testcases/kernel/syscalls/utime/utime05.c
ltp/testcases/kernel/syscalls/utime/utime06.c
ltp/testcases/kernel/syscalls/utimensat/check_for_utimensat_support.c
ltp/testcases/kernel/syscalls/utimensat/utimensat01.c
ltp/testcases/kernel/syscalls/utimensat/utimensat_tests.sh
ltp/testcases/kernel/syscalls/vfork/vfork01.c
ltp/testcases/kernel/syscalls/vfork/vfork02.c
ltp/testcases/kernel/syscalls/vhangup/vhangup01.c
ltp/testcases/kernel/syscalls/vhangup/vhangup02.c
ltp/testcases/kernel/syscalls/vmsplice/vmsplice01.c
ltp/testcases/kernel/syscalls/wait/wait02.c
ltp/testcases/kernel/syscalls/wait4/wait401.c
ltp/testcases/kernel/syscalls/wait4/wait402.c
ltp/testcases/kernel/syscalls/waitpid/waitpid01.c
ltp/testcases/kernel/syscalls/waitpid/waitpid02.c
ltp/testcases/kernel/syscalls/waitpid/waitpid03.c
ltp/testcases/kernel/syscalls/waitpid/waitpid04.c
ltp/testcases/kernel/syscalls/waitpid/waitpid05.c
ltp/testcases/kernel/syscalls/waitpid/waitpid06.c
ltp/testcases/kernel/syscalls/waitpid/waitpid07.c
ltp/testcases/kernel/syscalls/waitpid/waitpid08.c
ltp/testcases/kernel/syscalls/waitpid/waitpid09.c
ltp/testcases/kernel/syscalls/waitpid/waitpid10.c
ltp/testcases/kernel/syscalls/waitpid/waitpid11.c
ltp/testcases/kernel/syscalls/waitpid/waitpid12.c
ltp/testcases/kernel/syscalls/waitpid/waitpid13.c
ltp/testcases/kernel/syscalls/write/write01.c
ltp/testcases/kernel/syscalls/write/write02.c
ltp/testcases/kernel/syscalls/write/write03.c
ltp/testcases/kernel/syscalls/write/write04.c
ltp/testcases/kernel/syscalls/write/write05.c
ltp/testcases/kernel/syscalls/writev/writev01.c
ltp/testcases/kernel/syscalls/writev/writev02.c
ltp/testcases/kernel/syscalls/writev/writev03.c
ltp/testcases/kernel/syscalls/writev/writev04.c
ltp/testcases/kernel/syscalls/writev/writev05.c
ltp/testcases/kernel/syscalls/writev/writev06.c


45) Log Message:
Integrate ebizzy-0.3. Signed-Off-By: Poornima Nayak <mpnayak@linux.vnet.ibm=
.com>.

Modified Files:
ltp/utils/Makefile
ltp/utils/benchmark/Makefile
Added Files:
ltp/utils/benchmark/ebizzy-0.3/ChangeLog
ltp/utils/benchmark/ebizzy-0.3/LICENSE
ltp/utils/benchmark/ebizzy-0.3/Makefile
ltp/utils/benchmark/ebizzy-0.3/README
ltp/utils/benchmark/ebizzy-0.3/configure
ltp/utils/benchmark/ebizzy-0.3/ebizzy.c
ltp/utils/benchmark/ebizzy-0.3/ebizzy.h
Removed Files:
ltp/utils/benchmark/ebizzy-0.2/ChangeLog
ltp/utils/benchmark/ebizzy-0.2/LICENSE
ltp/utils/benchmark/ebizzy-0.2/Makefile
ltp/utils/benchmark/ebizzy-0.2/README
ltp/utils/benchmark/ebizzy-0.2/configure
ltp/utils/benchmark/ebizzy-0.2/ebizzy.c

46) Log Message:
Patch to fix ebizzy compile issue. Signed-Off-By: Poornima Nayak <mpnayak@l=
inux.vnet.ibm.com>.

Modified Files:
ltp/Makefile

47) Log Message:
Patch to fix testcases exit status issue. Signed-Off-By: Poornima Nayak <mp=
nayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/change_freq.sh
ltp/testcases/kernel/power_management/change_govr.sh
ltp/testcases/kernel/power_management/check_config.sh
ltp/testcases/kernel/power_management/check_cpufreq_sysfs_files.sh
ltp/testcases/kernel/power_management/check_cpuidle_sysfs_files.sh
ltp/testcases/kernel/power_management/cpu_consolidation.py
ltp/testcases/kernel/power_management/pwkm_load_unload.sh
ltp/testcases/kernel/power_management/runpwtests.sh
ltp/testcases/kernel/power_management/sched_domain.py
ltp/testcases/kernel/power_management/test_sched_mc.sh

48) Log Message:
mqns: update kernel version check: (Against the March intermediate release)=
 mqns support is expect in 2.6.30, not 2.6.29. Signed-off-by: Serge Hallyn =
<serge@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/mqns/check_mqns_enabled.c

49) Log Message:
Modified existing reusable functions to test cpu consolidation on hyper thr=
eaded system. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/lib/sched_mc.py

50) Log Message:
Modified cpu consolidation testcase to support sched_smt_mc_power_savings &=
 sched_smt_power_saving FVT. Signed-off-by: poornima nayak <mpnayak@linux.v=
net.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/cpu_consolidation.py

51) Log Message:
Modified sched domain validation testcase to run on hyper threaded system. =
Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/sched_domain.py

52) Log Message:
gcov-kernel: add patches for 2.6.29. Signed-Off-By: Peter Oberparleiter <ob=
erpapr@users.sourceforge.net>

Added File(s):
ltp/utils/analysis/gcov-kernel/linux-2.6.29-gcov-arm-eabi.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.29-gcov-arm-hack.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.29-gcov.patch

53) Log Message:
It has come to our attention that when running multicast tests that the mul=
ticast ping test assumes that all the machines on the network, including th=
e machine getting tested, have multicast ping enabled.  This has not been t=
he case since 2005 when multicast ping was disabled by default, mostly to i=
nhibit ddos activity.  See this conversation for more details: https://bugz=
illa.redhat.com/show_bug.cgi?id=3D159367. Now on all kernels, /proc/sys/net=
/icmp_echo_ignore_broadcasts is set to 1 by default, thereby failing this t=
est.  But the error message is wrong. Multicast is not disabled, only multi=
cast ping.  This patch modifies the error message and tells that it is now =
normal to fail.Signed-off-by: Vernon Mauery <vernux@us.ibm.com>, Acked-by: =
Sripathi Kodi <sripathik@in.ibm.com>.

Modified File(s):
ltp/testcases/network/multicast/mc_cmds/mc_cmds

--=-dmKyU666W3tfxP0HdEKc--

