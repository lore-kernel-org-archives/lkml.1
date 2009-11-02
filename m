Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZKBNRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZKBNRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKBNRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:17:21 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39368 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZKBNRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:17:17 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for OCTOBER
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Garrett Cooper <yanegomi@gmail.com>, Miao Xie <miaox@cn.fujitsu.com>,
       poornima nayak <mpnayak@linux.vnet.ibm.com>,
       Liu Bo <liubo-fnst@cn.fujitsu.com>, Hushan Jia <hjia@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>, Pavel Kiryukhin <vksavl@gmail.com>,
       chrubis@suse.cz, Chandru S <chandru@linux.vnet.ibm.com>,
       Henry Yei <hyei@mvista.com>, Masatake YAMATO <yamato@redhat.com>,
       Nicolas Joly <njoly@pasteur.fr>, Gowri <gomuthuk@linux.vnet.ibm.com>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       Jiri Palecek <jpalecek@web.de>, Nate Straz <nate@refried.org>
Content-Type: multipart/mixed; boundary="=-S+uMJvhGoFwxx1dKPyIA"
Organization: IBM
Date: Mon, 02 Nov 2009 18:47:01 +0530
Message-Id: <1257167821.4977.41.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S+uMJvhGoFwxx1dKPyIA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,

The Linux Test Project test suite has been released for the month of
OCTOBER 2009. Please see ltp/INSTALL file carefully, as, there has
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
OCTOBER 2009 Highlights:
======================== 
     1. LTP Makefiles rewrite:(Project started 1.2 years back) 
             I. To accommodate correct build/installation practices, 
            II. better integrate Autoconf/Automake with tests for safer
                builds, 
           III. better cross-compilation of LTP sources. 
     2. 119 test scenarios for EXT4 functionality testing, with 56.1%
        lines and 66.4% functions coverage of 2.6.31 EXT4-kernel code, 
     3. GETUID16, GETUID64, GETEUID16 & PTRACE syscall() test
        additions, 
     4. SIGRETURN01 Test case removal, 
     5. LCOV Fixes, 
     6. ILB and CPU Consolidation test cases and fixes in Power
        Management (I am sorry to have overlooked this last month),
------------------------------

==============================
OCTOBER 2009 LTP Contributors:
============================== 
     1. Garrett Cooper, 
     2. Mike Frysinger, 
     3. Miao Xie, 
     4. Poornima Nayak, 
     5. Liu Bo, 
     6. Hushan Jia, 
     7. Pavel Kiryukhin, 
     8. Cyril Hrubis, 
     9. Chandru S, 
    10. Henry Yei, 
    11. Masatake YAMATO, 
    12. Nicolas Joly, 
    13. Gowri, 
    14. Peter Oberparleiter, 
    15. Jiri Palecek,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
There is no need for a special explanation of why this month was so
important for LTP. LTP now has all brand new Makefiles. Thanks to Garret
and his tiring work spanning more than an year. And off course not to
forget Mike and Nate for reviewing them deeply before they were
committed.
Another significant development was contribution of the EXT4
functional/regression tests to LTP by Miao. This is something which we
were looking for long. And i would like to bring Peter to everybodyś
attention as he single-handedly manages the LTP-Coverage mailing list
providing assistance to everybody having doubts on coverage process.
Thanks peter for doing this seamlessly again-and-again.

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

--=-S+uMJvhGoFwxx1dKPyIA
Content-Disposition: attachment; filename=Oct-2009_Changelog.txt
Content-Type: text/plain; name=Oct-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
Fix issues in cpu consolidation verification functions: Arguments passed fo=
r cpu consolidation was not used appropriatly. Provided TINFO messages to i=
ndicate dependency test failures. Signed-off-by: poornima nayak <mpnayak@li=
nux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/pm_include.sh

2) Log Message:
Developed new functions and fixed issues causing ilb test failure: CPU Cons=
olidation verification function is fixed to handle variations in CPU utiliz=
ation. Threshold is selected based on test conducted on 2.6.31 on dual core=
, quad core & hyper threaded system. Developed new function to generate hyp=
er threaded siblings list and get job count for hyper threaded system and m=
ultisocket system. Modified kernbench workload execution time for 5 min, he=
nce test execution time will be reduced further. Developed new functions to=
 stop workload. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/lib/sched_mc.py

3) Log Message:
Modified ilb test to run with ebizzy as default workload. Signed-off-by: po=
ornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/ilb_test.py

4) Log Message:
Enhanced & Modified cpu_consolidation testcase: We can pass additional argu=
ment performance to use the same testcase for Performance test. Fixed issue=
s in cpu consolidation test. Signed-off-by: poornima nayak <mpnayak@linux.v=
net.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/cpu_consolidation.py

5) Log Message:
Modified master script to pass appropriate arguments for cpu consolidation =
test cases. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/power_management/runpwtests.sh

6) Log Message:
utimes: fix failure of utimes01: In /testcases/kernel/syscalls/utimes, case=
02 expects "EACCES" error. According to utimes's manual: EACCES  times is N=
ULL, the caller=E2=80=99s effective user ID does not match the owner of the=
 file, the caller does not have write access to the file, and the caller is=
 not privileged (Linux: does  not  have either the CAP_DAC_OVERRIDE or the =
CAP_FOWNER capability). However, now case02's times is not NULL so that it =
can only get "EPERM". So, change case02's times to NULL to reach its expect=
. This patch fixes the problem. Signed-off-by: Liu Bo <liubo-fnst@cn.fujits=
u.com>.

Modified Files:
ltp/testcases/kernel/syscalls/utimes/utimes01.c

7) Log Message:
network: fix rpc use rsh instead of ssh: rpcinfo01 testcase use ssh to run =
command on remote machine, which will prompt for authentication and passwor=
d. I think it is a typo because all network tests use rsh. Signed-off-by: H=
ushan Jia <hjia@redhat.com>.

Modified Files:
ltp/testcases/network/rpc/basic_tests/rpcinfo/rpcinfo01

8) Log Message:
Fix false success for exp test: if I get it right there is error in ltp-ful=
l-20090831/testcases/misc/math/float/exp_log/genexp.c (see genexp_resfile.p=
atch). Resulting file exp_out.ref is wrong, but it is not catch by test - n=
an_compare.patch make correct nan comparison. Signed-off-by: Pavel Kiryukhi=
n <vksavl@gmail.com>.

Modified File(s):
ltp/testcases/misc/math/float/thread_code.c
ltp/testcases/misc/math/float/exp_log/genexp.c

9) Log Message:
IMA tcb policy: Dependency section update. Signed-off-by: Mimi Zohar <zohar=
@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/integrity/ima/README

10) Log Message:
Remove `verbose mode' from runltp*:
1. This option really doesn't buy us much in runltp*, and we've almost alre=
ady run out of options anyhow...
2. Correct some ugly indentation.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified File(s):
ltp/runltp
ltp/runltplite.sh

11) Log Message:
realtime: Remove printing of cpu affinity masks in pi-tests: Some tests und=
er realtime/func/pi-tests in LTP display junk values for cpu affinity masks=
:
Start ./testpi-2
protocol in mutexattr is 1
Thread 14574 started running with priority 10 on CPU 1110536304
Thread 14574 at start pthread pol 2 pri 10 - Got global lock
Thread 14575 started running with prio 20 on CPU 1084272752
Thread 14576 started running with prio 30 on CPU 1118929008
Thread 14577 started running with prio 40 on CPU 1127321712
Noise Thread 14578 started running with prio 40 on CPU 1099915376

testpi-1 and testpi-4 also report similar wrong values.

The cause of this problem is the incorrect way in which sched_getaffinity o=
utput is used in the tests. I think there is no need to call getaffinity() =
to know the cpu mask, because we test the return value of setaffinity() bef=
ore that. The following patch removes all calls to sched_affinity() and rem=
oves printing cpu affinity masks.
Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>,
Acked-by: Gowrishankar <gowrishankar.m@in.ibm.com>,

Modified File(s):
ltp/testcases/realtime/func/pi-tests/testpi-1.c
ltp/testcases/realtime/func/pi-tests/testpi-2.c
ltp/testcases/realtime/func/pi-tests/testpi-4.c

12) Log Message:
fix memcg_function_test's bug: testcase_25() uses a wrong "$?" value , Now =
use "ret" to record the real "$?" value for test. Signed-off-by: Liu Bo <li=
ubo-fnst@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh

13) Log Message:
fix possible tst_xxx buffer overrun: Following patch fixes tst_** functions=
 that would segfault for printing messages longer than 2048 chars. Now such=
 message is truncated. Signed-off-by: <chrubis@suse.cz>.

Modified File(s):
ltp/lib/tst_res.c

14) Log Message:
Just another printf cleanup: attached patch fixes some more printf formatin=
g issues as well as some coding style errors. Signed-off-by: <chrubis@suse.=
cz>.

Modified Files:
ltp/testcases/kernel/fs/proc/proc01.c
ltp/testcases/kernel/fs/stream/stream03.c
ltp/testcases/kernel/mem/mtest06/mmap1.c
ltp/testcases/kernel/mem/shmt/shmt05.c
ltp/testcases/kernel/mem/shmt/shmt09.c
ltp/testcases/kernel/mem/vmtests/data_space.c
ltp/testcases/kernel/mem/vmtests/stack_space.c
ltp/testcases/kernel/sched/nptl/nptl01.c
ltp/testcases/kernel/syscalls/close/close08.c
ltp/testcases/kernel/syscalls/dup/dup01.c
ltp/testcases/kernel/syscalls/dup/dup02.c
ltp/testcases/kernel/syscalls/dup/dup03.c
ltp/testcases/kernel/syscalls/dup/dup04.c
ltp/testcases/kernel/syscalls/dup/dup05.c

15) Log Message:
Remove this test and it=C5=9B reference anywhere as requested by Cyril Hrub=
is <chrubis@suse.cz>. Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.=
com>.

Modified Files:
ltp/runtest/syscalls
Removed Files:
ltp/testcases/kernel/syscalls/sigreturn/Makefile
ltp/testcases/kernel/syscalls/sigreturn/sigreturn01.c

16) Message:
Just before doing a CVS diff I noticed that these binary files made it back=
 into the repository:
testcases/ballista/ballista/blexer
testcases/ballista/ballista/bparser
testcases/ballista/ballista/mut.out
This change removes them again: Signed-off-by: Garrett Cooper <yanegomi@gma=
il.com>.

Removed Files:
ltp/testcases/ballista/ballista/blexer
ltp/testcases/ballista/ballista/bparser
ltp/testcases/ballista/ballista/mut.out

17) Log Message:
Byte compiled python files should not be in the repo.

Removed Files:
ltp/testcases/network/nfsv4/acl/random_gen.pyc

18) Log Message:
make strptrace() inline to avoid unused warnings

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/spawn_ptrace_child.h

19) Log Message:
tweak how we notify unsupported arches so the code is always compiled

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c

20) Log Message:
add some simple trace code to help with debugging

Modified Files:
ltp/testcases/kernel/syscalls/ptrace/spawn_ptrace_child.h=20
Added Files:
ltp/testcases/kernel/syscalls/ptrace/make_syscall_list.sh
ltp/testcases/kernel/syscalls/ptrace/simple_tracer.c syscalls.h

21) Log Message:
1. Please see README.mk-devel for a full description of the changes from a =
Make perspective.
2. Several files were changed to accomodate correct installation practices,=
 most notably ones in testcases/network/{ipv6,tcp_cmds}, testcases/kernel/s=
ched/hyperthreading/ht_enabled/..., and some items in tools/..., and also t=
o avoid collisions as far as installed testcases (scripts, compiled C apps)=
 were concerned.
3. Several apps weren't autoconf safe and some autoconf tests and condition=
al statements have been placed in sourcecode and in Makefiles to either
	a) prevent the tests from being built / installed or
	b) turn the tests into dummy apps which print out TCONF messages due to la=
ck-of-build support.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Added Files:
ltp/README.ltp-devel.in
ltp/README.mk-devel
ltp/README.mk-user
ltp/TODO
ltp/ltp-devel.spec.in
ltp/doc/Makefile
ltp/include/mk/automake.mk
ltp/include/mk/config.mk.in
ltp/include/mk/env_post.mk
ltp/include/mk/env_pre.mk
ltp/include/mk/functions.mk
ltp/include/mk/generic_leaf_target.inc
ltp/include/mk/generic_leaf_target.mk
ltp/include/mk/generic_trunk_target.inc
ltp/include/mk/generic_trunk_target.mk
ltp/include/mk/lib.mk
ltp/include/mk/man.mk
ltp/include/mk/testcases.mk
ltp/lib/ltp.pc.in
ltp/m4/ltp-cap.m4
ltp/m4/ltp-numa.m4
ltp/m4/ltp-ptrace.m4
ltp/m4/ltp-quota.m4
ltp/runtest/Makefile
ltp/runtest/ipv6_expect
ltp/runtest/tcp_cmds_expect
ltp/testcases/kernel/containers/Makefile.inc
ltp/testcases/kernel/containers/netns/common.c
ltp/testcases/kernel/controllers/Makefile.inc
ltp/testcases/kernel/controllers/cpuset/Makefile.inc
ltp/testcases/kernel/controllers/cpuset/cpuset_funcs.sh
ltp/testcases/kernel/controllers/freezer/run_freezer.sh
ltp/testcases/kernel/fs/fs-bench/random-access-del-create.c
ltp/testcases/kernel/io/aio/aio02/aio_tio.c
ltp/testcases/kernel/io/aio/aio02/common.h
ltp/testcases/kernel/mem/Makefile.inc
ltp/testcases/kernel/mem/hugetlb/Makefile.inc
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/ht_affinity.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/ht_utils.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/ht_utils.h
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/ht_enabled.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/ht_utils.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/ht_utils.h
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/ht_interrupt.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/ht_utils.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/ht_utils.h
ltp/testcases/kernel/security/selinux-testsuite/tests/Makefile.inc
ltp/testcases/kernel/security/smack/smack_common.sh
ltp/testcases/kernel/syscalls/ipc/Makefile.inc
ltp/testcases/lib/Makefile
ltp/testcases/lib/cmdlib.sh
ltp/testcases/lib/net_cmdlib.sh
ltp/testcases/network/tcp_cmds/Makefile.inc
ltp/testcases/network/tcp_cmds/include/netdefs.h
ltp/testcases/network/tcp_cmds/perf_lan/pingpong6.c
ltp/testscripts/default_runtest_set.awk
ltp/testscripts/ltp-missing-install-files.py
ltp/tools/genload/genload.c

Removed Files:
ltp/README.ltp-devel
ltp/config.mk.in
ltp/ltp-devel.spec
ltp/testcases/kernel/containers/check_for_unshare.c
ltp/testcases/kernel/containers/libclone/libnetns.c
ltp/testcases/kernel/containers/mqns/check_mqns_enabled.c
ltp/testcases/kernel/containers/pidns/check_pidns_enabled.c
ltp/testcases/kernel/controllers/freezer/run.sh
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTaffinity.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTutils.h
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTenabled.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTutils.h
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTinterrupt.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTutils.h
ltp/testcases/kernel/security/filecaps/check_xattr.c
ltp/testcases/kernel/security/filecaps/makenumcapsh.c
ltp/testcases/kernel/security/p9auth/checkp9auth.sh
ltp/testcases/kernel/syscalls/lchown/create_link.mode.sh
ltp/testcases/kernel/syscalls/mount/setuid_test.mode.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages03.mode.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages11.mode.sh
ltp/testcases/kernel/syscalls/utimensat/check_for_utimensat_support.c
ltp/testcases/network/ipv6/Makefile
ltp/testcases/network/ipv6/echo6/Makefile
ltp/testcases/network/ipv6/echo6/createfile.c
ltp/testcases/network/ipv6/echo6/echo601
ltp/testcases/network/ipv6/echo6/echoes6.c
ltp/testcases/network/ipv6/finger6/Makefile
ltp/testcases/network/ipv6/finger6/finger601
ltp/testcases/network/ipv6/perf_lan6/Makefile
ltp/testcases/network/ipv6/perf_lan6/perf_lan6
ltp/testcases/network/ipv6/perf_lan6/pingpong6.c
ltp/testcases/network/ipv6/ping6/Makefile
ltp/testcases/network/ipv6/ping6/ping601
ltp/testcases/network/ipv6/sendfile6/Makefile
ltp/testcases/network/ipv6/sendfile6/SF_Server6
ltp/testcases/network/ipv6/sendfile6/sendfile601
ltp/testcases/network/ipv6/sendfile6/testsf_c6.c
ltp/testcases/network/ipv6/sendfile6/testsf_s6.c
ltp/testcases/network/ipv6/tcpdump6/Makefile
ltp/testcases/network/ipv6/tcpdump6/tcpdump601

Modified Files:
890 of them

22) Log Message:
This proposed change makes linktest.pl into linktest.sh, to avoid missing c=
overage with symlinks and hardlinks due to a lacking perl dependency on the=
 target host. This change has been outstanding for some time in our private=
 copy of LTP and needed to get checked into CVS. Signed-off-by: Garrett Coo=
per <yanegomi@gmail.com>.

Modified Files:
ltp/runtest/fs
ltp/runtest/stress.part1
ltp/testcases/kernel/fs/linktest/Makefile

Added Files:
ltp/testcases/kernel/fs/linktest/linktest.sh

Removed Files:
ltp/testcases/kernel/fs/linktest/linktest.pl

23) Log Message:
Dependency for all was wrong.

Modified File(s):
ltp/testcases/kernel/mem/hugetlb/Makefile.inc

24) Log Message:
The following patch adds a signal() syscall to the ppoll01 testcase. The te=
stcase has a signal handler in it but this signal handler is not registered=
 with the kernel through the signal() syscall.  Without the patch the testc=
ase fails when it sends a SIGINT to itself as part of one of the case of th=
e test run. Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

25) Log Message:
File descriptors not cleaned up: This patch for openfile contains the follo=
wing changes:
- test output to use tst_resm functions,
- sets ups and cleans up tmp dir properly,
- closes all opened file descriptors before thread exit(fixes nfs issues on=
 removing tmp dir),
Signed-off-by: Henry Yei <hyei@mvista.com>. This test opens multiple file d=
escriptors to the same file. Perhaps the author meant to open file handles =
for separate files?

Modified Files:
ltp/testcases/kernel/fs/openfile/openfile.c


26) Log Message:
Complete the test cases for getuid16: Some of testcases for *16 and *64 sys=
tem calls have not been completed yet though my makefile trick were introdu=
ced by Suburata. *16 may not be so important but I'd like to complete them =
anyway. The first one is for getuid16. To apply getuid16.patch use -p0 opti=
on. Put compat_uid.h  at testcases/kernel/syscalls/utils/compat_uid.h. Put =
compat_16.h.  at testcases/kernel/syscalls/getuid/compat_16.h. Signed-off-b=
y: Masatake YAMATO <yamato@redhat.com>,

Modified Files:
ltp/testcases/kernel/syscalls/getuid/Makefile
ltp/testcases/kernel/syscalls/getuid/getuid01.c
ltp/testcases/kernel/syscalls/getuid/getuid02.c
ltp/testcases/kernel/syscalls/getuid/getuid03.c
Added Files:
ltp/testcases/kernel/syscalls/getuid/compat_16.h
ltp/testcases/kernel/syscalls/utils/compat_uid.h

27) Log Message:
use default size for blks if parsing df output fails to return numeric argu=
ment: This patch for rwtest.sh sets a default size for the number of blocks=
 within the filesystem the test is executing on if parsing "df output" some=
how results in a non-numeric value(unexpected df output). Also removes trai=
ling whitespace. Garrett, I've attached the patch with your suggested chang=
es. As for making default_sz 1000000, this was to keep to the original func=
tionality, but fix cases where df output was not expected. If you see the o=
riginal code, if sz > max, than it is capped at max=3D1000000 as well. Whet=
her ~ 1GB is a good maximum, I'm not sure. Signed-off-by: Henry Yei <hyei@m=
vista.com>.

Modified Files:
ltp/testcases/kernel/fs/doio/rwtest.sh

28) Log Message:
Move `creating ... directory' to block where: We shouldn't say that we're c=
reating the directory unless we are actually creating the directory. This o=
nly leads to potentialconfusion with LTP newbies. Signed-off-by: Garrett Co=
oper <yanegomi@gmail.com>.

Modified Files:
ltp/runltp

29) Log Message:
While trying to figure out why entries don't get entered in the exec log, I=
 found the following issue with a malloc call. I also fixed a typo and a wh=
acky indentation item as well. Signed-off-by: Garrett Cooper <yanegomi@gmai=
l.com>.

Modified File(s):
ltp/pan/ltp-pan.c

30) Log Message:
Check in `creating directory' cosmetic item for runltplite.sh as well, just=
 to be consistent. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.=20

Modified File(s):
ltp/runltplite.sh

31) Log Message:
Remove an accidental circular dependency. Signed-off-by: Garrett Cooper <ya=
negomi@gmail.com>.

Modified Files:
ltp/include/mk/automake.mk

32) Log Message:
autoconf 2.61 / m4 1.4.7 don't define the macro, AC_PROG_AR. This needs to =
be defined in configure.ac, so those versions will continue to function pro=
perly. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/configure.ac

33) Log Message:
Add copyright tort. Abbreviate. Signed-off-by: Garrett Cooper <yanegomi@gma=
il.com>.

Modified Files:
ltp/m4/ltp-unshare.m4

34) Log Message:
AR is defined in configure.ac. Not needed in m4 anymore. Signed-off-by: Gar=
rett Cooper <yanegomi@gmail.com>.

Removed Files:
ltp/m4/ac_prog_ar.m4

35) Log Message:
1. Fix taskstats.m4 so it no longer punts out warnings.
2. Add ltp-swaponoff.m4 to properly detect when we're running an older kern=
el and need linux/swap.h (issue found by compiler team at Cisco).
3. Apply fixes according to 2. to testcases/kernel/syscalls/swap*/*.c.
4. Apply Cyril Hrubis's libcpu_set fix to the .in files and cpuset_lib Make=
file and .c file.
5. Block off functionality in getdelays.c with proper preprocessor defines,=
 as per issues after encountered after ltp-taskstats.m4 was fixed.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/m4/ltp-taskstats.m4
ltp/testcases/kernel/syscalls/swapon/swapon01.c
ltp/testcases/kernel/syscalls/swapon/swapon02.c
ltp/testcases/kernel/syscalls/swapon/swapon03.c
ltp/testcases/kernel/controllers/cgroup/getdelays.c
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/libcpuset.c
ltp/testcases/kernel/syscalls/swapoff/swapoff01.c
ltp/testcases/kernel/syscalls/swapoff/swapoff02.c
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/powerpc64.in
ltp/testcases/kernel/include/s390.in
ltp/configure.ac

Added Files:
ltp/m4/ltp-swaponoff.m4

36) Log Message:
config.mk.in: we're no longer installing directly to the destination direct=
ory until install is called, so let's not pick up anything CPPFLAGS-wise fr=
om that directory. pingpong6.c: get rid of compile warnings, even though th=
e app will eventually go away. Signed-off-by: Garrett Cooper <yanegomi@gmai=
l.com>.

Modified Files:
ltp/testcases/network/tcp_cmds/perf_lan/pingpong6.c
ltp/include/mk/config.mk.in

37) Log Message:
generic_*target.inc: Revive BUILD_DEPS support so dependencies are built pr=
ior to building MAKE_TARGETS, for simplicity of design for the end-user. te=
stcases.mk: Apply proper dependency logic, so submakes no longer require bu=
ilding libltp.a beforehand, or linux_syscall_numbers.h, as they are depende=
ncies of all operations that include testcases.mk. Signed-off-by: Garrett C=
ooper <yanegomi@gmail.com>.

Modified Files:
ltp/include/mk/generic_leaf_target.inc
ltp/include/mk/generic_trunk_target.inc
ltp/include/mk/testcases.mk

38) Log Message:
Rename BUILD_DEPS to MAKE_DEPS to be more consistent with MAKE_TARGETS. Ble=
h... I've dealt with our build system here at Cisco far too much (BUILD_DEP=
S is the variable name...).  Signed-off-by: Garrett Cooper <yanegomi@gmail.=
com>.

Modified Files:
ltp/include/mk/generic_leaf_target.inc
ltp/include/mk/generic_trunk_target.inc
ltp/include/mk/testcases.mk


39) Log Message:
1. Make linux_syscall_numbers.h dependent on the .in files so that it can b=
e regenerated if and when the files are touched.
2. Add the ppoll(2) syscall number to all architectures, as per each arch s=
pecific unistd.h.
Signed-off-by: Nicolas Joly <njoly@pasteur.fr>,

Modified Files:
ltp/testcases/kernel/include/Makefile
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/powerpc64.in
ltp/testcases/kernel/include/s390.in
ltp/testcases/kernel/include/sh.in=20
ltp/testcases/kernel/include/sparc.in
ltp/testcases/kernel/include/sparc64.in
ltp/testcases/kernel/include/x86_64.in

40) Log Message:
Change use of signal to sigaction for more reliability, fix time issue: Her=
e are three patches the help with the issue where these tests miss a signal=
 and hang. The original patches were created before the latest check-ins by=
 jpalecek@web.de , but I believe they still help. I've regenerated the patc=
hes against CVS source and tested on a multi-core machine running MVL6 (x86=
 2.6.28). The clock_nanosleep01 patch changes signal to the more reliable s=
igaction(). mq_timedsend01 patch changes from signal() to sigaction() and c=
orrects the time-specs used by the test. Timespec's passed to mq_timedsend =
are abs time, not relative time. The patch adds the current time to convert=
 relative time to abs time but only if the change won't invalidate the test=
 objective. For example, if the test would have passed -1 for tv_sec to cau=
se an invalid time error, adding the current time would prevent the expecte=
d error. mq_timedrecieve01.patch changes from signal() to sigaction() and c=
orrects the time-specs used by the test. Timespec's passed to mq_timedrecei=
ve are abs time, not relative time. The patch adds the current time to conv=
ert relative time to abs time but only if the change won't invalidate the t=
est objective. For example, if the test would have passed -1 for tv_sec to =
cause an invalid time error, adding the current time would prevent the expe=
cted error. The timeout for SIGINT test is extended to allow time for the s=
ignal to arrive.
Original patches provided by Randy Vinson <rvinson@mvista.com>,
Signed-off by: Henry Yei <hyei@mvista.com>,

Modified Files:
ltp/testcases/kernel/syscalls/clock_nanosleep/clock_nanosleep01.c
ltp/testcases/kernel/syscalls/mq_timedreceive/mq_timedreceive01.c
ltp/testcases/kernel/syscalls/mq_timedsend/mq_timedsend01.c

41) Log Message:
modify fs scenario to use working directory specified by runltp: This patch=
 modifies the fs scenario to remove hard coded paths with /tmp as well as m=
ake sure that tests that take directory arguments use the temporary directo=
ry specified by runltp. I've chosen to pass in the temporary directory rath=
er than change the tests themselves for certain tests take a path as an arg=
ument. Signed-off by: Henry Yei <hyei@mvista.com>.

Modified Files:
ltp/runtest/fs

42) Log Message:
Modify tests to honor tmp directory passed into runltp, convert to LTP form=
at: This is a set of patches for tests in the fs runtest file which make us=
e of tst_tmpdir functions or alternatively, the base tmpdir set by the user=
. Some of the tests have been converted to LTP test format as well. Tests t=
hat are changed: fs_di, fs_perms, lftest, linker01, quota_remount_test01, w=
ritetest. Signed-off by: Henry Yei <hyei@mvista.com>.

Modified Files:
ltp/testcases/kernel/fs/fs_di/fs_di
ltp/testcases/kernel/fs/fs_perms/fs_perms.c
ltp/testcases/kernel/fs/fs_perms/fs_perms_simpletest.sh
ltp/testcases/kernel/fs/quota_remount/quota_remount_test01.sh
ltp/testcases/kernel/fs/racer/fs_racer.sh
ltp/testcases/kernel/io/writetest/writetest.c

43) Log Message:
-laio shouldn't be added to LDLIBS by default. That is just plain wrong.

Modified Files:
ltp/m4/ltp-eventfd.m4

44) Log Message:
1. Honor TMPDIR, as per Henry Yei's note, because linktest.sh doesn't curre=
ntly do that.
2. Add error checking for cd(1) failure.
3. Suffix the temporary directory with $$ to allow multiple copies to execu=
te on the directory at any given time.
4. Add trap(1)'s to delete the temporary files / directories generated in t=
he script.
gcooper@orangebox /scratch/ltp-dev2/ltp $ testcases/kernel/fs/linktest/link=
test.sh 200 1000
linker01    1  TPASS  :  Symbolic Link Errors: 0
linker01    2  TPASS  :  Hard Link Errors: 0
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/kernel/fs/linktest/linktest.sh

45) Log Message:
1. Fix incrementing call to use POSIX compliant version of incrementing.
2. Add function `is_root' to help test writer determine whether or not the =
user is root with one uniform command.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>

Modified Files:
ltp/testcases/lib/cmdlib.sh

46) Log Message:
The trap signal handler wasn't being disabled on entry thus causing it to b=
e called twice, the first time when tst_cleanup was called; the second when=
 cleanup exited. This fixes that. Signed-off-by: Garrett Cooper <yanegomi@g=
mail.com>.

Modified Files:
ltp/testcases/lib/cmdlib.sh

47) Log Message:
This change (which I'm committing to cvs right now) changes the default to =
the loopback address:
gcooper@orangebox /scratch/ltp-dev2/ltp/testcases/network/tcp_cmds/ping $ .=
/ping01=20
ping01      0  TINFO  :  ping with 8 16 32 64 128 256 512 1024 2048 4064 IC=
MP packets
ping01      0  TINFO  :  calling ping with packet size =3D 8
ping01      0  TINFO  :  calling ping with packet size =3D 16
ping01      0  TINFO  :  calling ping with packet size =3D 32
ping01      0  TINFO  :  calling ping with packet size =3D 64
ping01      0  TINFO  :  calling ping with packet size =3D 128
ping01      0  TINFO  :  calling ping with packet size =3D 256
ping01      0  TINFO  :  calling ping with packet size =3D 512
ping01      0  TINFO  :  calling ping with packet size =3D 1024
ping01      0  TINFO  :  calling ping with packet size =3D 2048
ping01      0  TINFO  :  calling ping with packet size =3D 4064
ping01      0  TINFO  :  Cleaning up.
ping01      1  TPASS  :  Test successful
gcooper@orangebox /scratch/ltp-dev2/ltp/testcases/network/tcp_cmds/ping $=20
The default can still be changed by specifying the RHOST environment variab=
le. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/network/tcp_cmds/ping/ping01

48) Log Message:
The attached patch fixes my issues, but I can't easily verify whether or no=
t it fixes the positive behavior of the testcase itself under all condition=
s:
<<<test_start>>>
tag=3Dima01 stime=3D1255926150 cmdline=3D"  ima_measurements.sh" contacts=
=3D"" analysis=3Dexit
<<<test_output>>>
setup       1  TBROK  :  Failed to mkdir /sys/kernel/security
setup       1  TBROK  :  Cannot mount securityfs
setup       0  TINFO  :  CLEAN: removing /tmp/ltp-VdWwjzuH1v/ima
<<<execution_status>>>
initiation_status=3D"ok" duration=3D0 termination_type=3Dexited termination=
_id=3D1 corefile=3Dno cutime=3D0 cstime=3D0
<<<test_end>>>
<<<test_start>>>
tag=3Dima02 stime=3D1255926150 cmdline=3D"  ima_policy.sh" contacts=3D"" an=
alysis=3Dexit
<<<test_output>>>
setup       1  TBROK  :  Failed to mkdir /sys/kernel/security
setup       1  TBROK  :  Cannot mount securityfs
setup       0  TINFO  :  CLEAN: removing /tmp/ltp-VdWwjzuH1v/ima
<<<execution_status>>>
initiation_status=3D"ok" duration=3D0 termination_type=3Dexited termination=
_id=3D1 corefile=3Dno cutime=3D0 cstime=3D2
<<<test_end>>>
<<<test_start>>>
tag=3Dima03 stime=3D1255926150 cmdline=3D"  ima_tpm.sh" contacts=3D"" analy=
sis=3Dexit
<<<test_output>>>
setup       1  TBROK  :  Failed to mkdir /sys/kernel/security
setup       1  TBROK  :  Cannot mount securityfs
setup       0  TINFO  :  CLEAN: removing /tmp/ltp-VdWwjzuH1v/ima
<<<execution_status>>>
initiation_status=3D"ok" duration=3D0 termination_type=3Dexited termination=
_id=3D1 corefile=3Dno cutime=3D1 cstime=3D1
<<<test_end>>>
<<<test_start>>>
tag=3Dima04 stime=3D1255926150 cmdline=3D"  ima_violations.sh" contacts=3D"=
" analysis=3Dexit
<<<test_output>>>
setup       1  TBROK  :  Failed to mkdir /sys/kernel/security
setup       1  TBROK  :  Cannot mount securityfs
setup       0  TINFO  :  CLEAN: removing /tmp/ltp-VdWwjzuH1v/ima
incrementing stop
<<<execution_status>>>
initiation_status=3D"ok" duration=3D0 termination_type=3Dexited termination=
_id=3D1 corefile=3Dno cutime=3D0 cstime=3D1
<<<test_end>>>
Either way, it's a positive move forward so I'm checking this into cvs now.=
 Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/security/integrity/ima/tests/ima_measurements.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_policy.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_setup.sh
ltp/testcases/kernel/security/integrity/ima/tests/ima_tpm.sh=20
ltp/testcases/kernel/security/integrity/ima/tests/ima_violations.sh=20


49) Log Message:
1. Add check for locale command with exists command in cmdlib.sh
2. Predefine any and all unbound variables so the set -u call in cmdlib.sh =
will allow the script to continue on to a failure point of some kind (or su=
cceed if all is defined).
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/network/stress/ns-tools/check_envval

50) Log Message:
This is the patch of testcases for the ext4 new features test. It contains =
multi-block alloc/delayed alloc test, inode version test, journal checksumm=
ing test, nanosec timestamps test, online defrag test, persist prealloc tes=
t, subdirectory limit test and uninit groups test of ext4. In this test sui=
te, there is two FAIL in the subdirectory limit test. It is because we cann=
't create more than 32000 subdirectory when block size is small, such as 10=
24, and the name of every subdirectory is very long, such as every name is =
255 bytes. I think it is the bug of the ext4.
Note: Your MUST run configure in the directory testcases/kernel/fs/ext4-new=
-features to config the tool of ffsb, and specify a partition to be used fo=
r test before compiling the tool. The data on the specified partition would=
 be DESTROYED.
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>,
Minor-Segmentation-fault-in-ffsb-fixed-by: Subrata Modak <subrata@linux.vne=
t.ibm.com>,

Modified Files:
ltp/README
ltp/testcases/kernel/fs/Makefile

Added Files:
ltp/runtest/fs_ext4
ltp/testcases/kernel/fs/ext4-new-features/Makefile
ltp/testcases/kernel/fs/ext4-new-features/README
ltp/testcases/kernel/fs/ext4-new-features/configure
ltp/testcases/kernel/fs/ext4-new-features/ext4_funcs.sh
ltp/testcases/kernel/fs/ext4-new-features/run_ext4_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-delalloc-mballoc/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-delalloc-mballoc/ext4-alloc-=
test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config0
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config1
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config2
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config3
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config4
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config5
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config6
ltp/testcases/kernel/fs/ext4-new-features/ext4-ffsb-config/ffsb-config7
ltp/testcases/kernel/fs/ext4-new-features/ext4-inode-version/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-inode-version/ext4_get_inode=
_version.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-inode-version/ext4_inode_ver=
sion_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-inode-version/ext4_test_inod=
e_version.c
ltp/testcases/kernel/fs/ext4-new-features/ext4-journal-checksum/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-journal-checksum/ext4_journa=
l_checksum.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-nsec-timestamps/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-nsec-timestamps/ext4_file_ti=
me.c
ltp/testcases/kernel/fs/ext4-new-features/ext4-nsec-timestamps/ext4_nsec_ti=
mestamps_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-online-defrag/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-online-defrag/e4defrag.c
ltp/testcases/kernel/fs/ext4-new-features/ext4-online-defrag/ext4_online_de=
frag_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-persist-prealloc/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-persist-prealloc/ext4_persis=
t_prealloc_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-subdir-limit/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-subdir-limit/create_long_dir=
s.c
ltp/testcases/kernel/fs/ext4-new-features/ext4-subdir-limit/create_short_di=
rs.c
ltp/testcases/kernel/fs/ext4-new-features/ext4-subdir-limit/ext4_subdir_lim=
it_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ext4-uninit-groups/Makefile
ltp/testcases/kernel/fs/ext4-new-features/ext4-uninit-groups/ext4_uninit_gr=
oups_test.sh
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/AUTHORS
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/COPYING
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/INSTALL
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/LICENSE
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/Makefile.am
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/Makefile.in
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/README
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/aclocal.m4
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/cirlist.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/cirlist.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/config.guess
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/config.h.in
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/config.sub
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/configure
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/configure.in
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/depcomp
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_fc.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_fs.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_fs.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_op.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_op.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_stats.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_stats.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_tg.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_tg.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_thread.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/ffsb_thread.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/fh.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/fh.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/filelist.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/filelist.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/fileops.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/fileops.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/install-sh
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/list.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/list.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/main.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/metaops.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/metaops.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/missing
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/mkinstalldirs
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/parser.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/parser.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/public-description
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rand.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rand.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rbt.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rbt.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/registration-descrip=
tion
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rwlock.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/rwlock.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/stamp-h.in
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/util.c
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/util.h
ltp/testcases/kernel/fs/ext4-new-features/ffsb-6.0-rc2/examples/profile_eve=
rything

51) Log Message:
Fix several out-of-build tree issues with CVS HEAD found while building on-=
site with Cisco. Some issues were related to changes I made, and some were =
related to Masatake's  getuid changes as well. Signed-off-by: Garrett Coope=
r <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/setgroups/Makefile
ltp/testcases/kernel/syscalls/getuid/Makefile
ltp/testcases/kernel/syscalls/getegid/Makefile
ltp/testcases/kernel/syscalls/utils/compat_16.mk
ltp/testcases/kernel/syscalls/utils/newer_64.mk
ltp/include/mk/env_post.mk
ltp/include/mk/testcases.mk
ltp/testcases/kernel/syscalls/getgid/Makefile

52) Log Message:
- Add additional quota check for RHEL 4.8 as reported by SimonX on #ltp
- Fix m4 file so that items are properly comma delimited, and thus the cont=
ents aren't incorrectly concatenated.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/m4/ltp-quota.m4
ltp/testcases/kernel/syscalls/quotactl/quotactl01.c

53) Log Message:
Fix indentation and a compile error noted by SimonXu on #ltp. Signed-off-by=
: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area.h
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area01.c
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area02.c

54) Log Message:
Fix two broken Makefiles reported by Gowri at IBM. Signed-off-by: Gowri <go=
muthuk@linux.vnet.ibm.com>, Reviewed-by: Garrett Cooper <yanegomi@gmail.com=
>,

Modified Files:
ltp/testcases/realtime/perf/Makefile
ltp/testcases/realtime/stress/Makefile

55) Log Message:
Check in Makefile, which partially fixes issue with realtime component buil=
d breakage. Originally reported by Gowri (<gomuthuk@linux.vnet.ibm.com>) at=
 IBM. Signed-off-by: Gowrishankar <gowrishankar.m@in.ibm.com>, Tested-by: G=
owrishankar <gowrishankar.m@in.ibm.com>, Acked-by: Sripathi Kodi <sripathik=
@in.ibm.com>,

Modified Files:
ltp/testcases/realtime/Makefile

56) Log Message:
The format string quantifier is incorrect, and thus the compiler prints out=
 a warning. This changes the format quantifier to %ld to remove the compile=
r warning. Signed-off-by: Gowrishankar <gowrishankar.m@in.ibm.com>, Tested-=
by: Gowrishankar <gowrishankar.m@in.ibm.com>, Acked-by: Sripathi Kodi <srip=
athik@in.ibm.com>,

Modified Files:
ltp/testcases/realtime/lib/libstats.c

57) Log Message:
Fix a typo and a warning related to unchecked results from asprintf, punted=
 by from the compiler. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

ltp/testcases/realtime/lib/librttest.c

58) Log Message:
Add a default config.mk file to ease use for non-autoconf users. Signed-off=
-by: Garrett Cooper <yanegomi@gmail.com>.

Added Files:
ltp/include/mk/config.mk.default

59) Log Message:
On second thought, the compiler-related variables should be uncommented. Si=
gned-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/include/mk/config.mk.default

60) Log Message:
1. Get rid of useless documentation (the directions are already in INSTALL)=
.
2. Tell people to read INSTALL instead.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/Makefile
Removed Files:
ltp/README.mk-user

61) Log Message:
Some fixes to make swap* stricter with including sys/swap.h, and defining M=
AX_SWAPFILES, that were hanging out in my dev branch that weren't checked i=
n. Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/swapon/swapon01.c
ltp/testcases/kernel/syscalls/swapon/swapon02.c
ltp/testcases/kernel/syscalls/swapon/swapon03.c
ltp/testcases/kernel/syscalls/swapoff/swapoff01.c
ltp/testcases/kernel/syscalls/swapoff/swapoff02.c

62) Log Message:
Update the documentation for building and installing LTP as per the Makefil=
e infrastructure changes. Signed-off-by: Garrett Cooper <yanegomi@gmail.com=
>.

Modified Files:
ltp/INSTALL
ltp/README.mk-devel
ltp/README.ltp-devel.in

63) Log Message:
testcases.mk: Add a freebie compile for the apicmds, if needed so tests can=
 be run before install. config.mk.in: Remove $(DESTDIR)/$(libdir) from the =
LDFLAGS, because we're no longer installing libraries in all. Signed-off-by=
: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/include/mk/testcases.mk
ltp/include/mk/config.mk.in

64) Log Message:
1. Get rid of psuedo-autoconf scripts in testcases/realtime/scripts.
2. Integrate testcases/realtime with autoconf.
3. Fix compilation, according to report made by Gowri at IBM.
Signed-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/realtime/func/rt-migrate/rt-migrate.c
ltp/testcases/realtime/lib/Makefile
ltp/testcases/realtime/func/pi-tests/Makefile
ltp/testcases/realtime/func/pi-tests/sbrk_mutex.c
ltp/testcases/realtime/scripts/check_pi.sh
ltp/testcases/realtime/scripts/check_robust.sh
ltp/testcases/realtime/Makefile
ltp/testcases/realtime/config.mk
ltp/include/mk/automake.mk
ltp/testcases/realtime/include/librttest.h
ltp/testcases/realtime/m4/GNUmakefile
ltp/testcases/realtime/m4/Makefile.am
ltp/testcases/realtime/m4/check.m4
Added Files:
ltp/testcases/realtime/configure.in

65) Log Message:
Get rid of redundant XOPEN2K #define (_GNU_SOURCE covers this). Signed-off-=
by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/realtime/func/rt-migrate/rt-migrate.c

66) Log Message:
Make sure the end-user knows that they need to run make autotools from $(to=
p_srcdir), to avoid potential confusion. Signed-off-by: Garrett Cooper <yan=
egomi@gmail.com>.

Modified Files:
ltp/INSTALL

67) Log Message:
I thought I removed the recursive LDLIBS definition sneak in. Oh well... Si=
gned-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/realtime/lib/Makefile

68) Log Message:
Accidentally nuking your .c files when running clean isn't a good thing. Si=
gned-off-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/realtime/func/pi-tests/Makefile

69) Log Message:
lcov: improve derive-func-data option
- rewrite graph file handling
- make derive data look at all lines belonging to a function to find out
  whether
  it has been hit or not
- introduce --debug option to better debug problems with graph files
Peter Oberparleiter <oberpapr@users.sourceforge.net>.

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo lcov

70) Log Message:
Fix temporary file creation in mmapstress tests: these are two little fixes=
 of the mmapstress test:
 - the mkstemp() function returns -1 on error; the tests treat 0 as error i=
nstead,
 - mkstemp() returns a file descriptor; no need to open the file once more =
later,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
   ltp/testcases/kernel/mem/mmapstress/mmapstress02.c
   ltp/testcases/kernel/mem/mmapstress/mmapstress05.c

71) Log Message:
Change errno reporting mechanism to TERRNO/TTERRNO in msgctl tests: The TER=
RNO/TTERRNO flags offer more information than the manual errno output used =
previously in the tests. This patch changes the tst_resm(XXX, ..., errno) a=
nd similar statements to tst_resm(XXX|TERRNO, ...). Signed-off-by: Jiri Pal=
ecek <jpalecek@web.de>.

Modified Files:
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

72) Log Message:
Fix some bashisms: this is another patch fixing bashisms in LTP tests (the =
fixes are more or less the same as in the previous patches, except for a fe=
w exceptions). Note that the patch is not complete, in the sense that there=
 may remain further bashisms in the source even after applying the patch (l=
ike use of arrays, which is visible even from this patch). Signed-off-by: J=
iri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/controllers/cgroup_fj/cgroup_fj_utility.sh
ltp/testcases/kernel/controllers/cgroup_fj/run_cgroup_test_fj.sh
ltp/testcases/kernel/controllers/cpuctl_fj/run_cpuctl_test_fj.sh
ltp/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
ltp/testcases/kernel/controllers/memcg/stress/memcg_stress_test.sh
ltp/testcases/kernel/fs/acls/acl_test01
ltp/testcases/kernel/fs/fs-bench/modaltr.sh
ltp/testcases/kernel/fs/fs_di/fs_di
ltp/testcases/kernel/fs/mongo/test.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug02.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug03.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug04.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug06.sar.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug06.top.sh
ltp/testcases/kernel/hotplug/cpu_hotplug/functional/hotplug07.sh
ltp/testcases/network/can/filter-tests/run_ltp-can_tests.sh
ltp/testcases/network/tcp_cmds/netstat/netstat01

73) Log Message:
Printf-style format string warnings (TEST_RETURN related): this patch fixes=
 some printf-format string warnings, concerning the TEST_RETURN variable. T=
EST_RETURN is declared as "long", so it is advisable to use "%ld" in printf=
 format string to avoid undefined behaviour. Note that this patch is not co=
mplete - it fixes the warnings in files near the beginning of the alphabet =
only. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/fs/fs-bench/modaltr.sh
ltp/testcases/kernel/fs/mongo/test.sh
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise02.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c
ltp/testcases/kernel/syscalls/fchmod/fchmod01.c
ltp/testcases/kernel/syscalls/fchmod/fchmod06.c
ltp/testcases/kernel/syscalls/fchown/fchown01.c
ltp/testcases/kernel/syscalls/fchown/fchown04.c
ltp/testcases/kernel/syscalls/fcntl/fcntl02.c
ltp/testcases/kernel/syscalls/fcntl/fcntl03.c
ltp/testcases/kernel/syscalls/fcntl/fcntl04.c
ltp/testcases/kernel/syscalls/fcntl/fcntl05.c
ltp/testcases/kernel/syscalls/fcntl/fcntl08.c
ltp/testcases/kernel/syscalls/fcntl/fcntl09.c
ltp/testcases/kernel/syscalls/fcntl/fcntl10.c
ltp/testcases/kernel/syscalls/fcntl/fcntl22.c
ltp/testcases/kernel/syscalls/fcntl/fcntl23.c
ltp/testcases/kernel/syscalls/fcntl/fcntl24.c
ltp/testcases/kernel/syscalls/fcntl/fcntl25.c
ltp/testcases/kernel/syscalls/fcntl/fcntl26.c
ltp/testcases/kernel/syscalls/fdatasync/fdatasync02.c
ltp/testcases/kernel/syscalls/fork/fork01.c
ltp/testcases/kernel/syscalls/fpathconf/fpathconf01.c
ltp/testcases/kernel/syscalls/fstatfs/fstatfs01.c
ltp/testcases/kernel/syscalls/fsync/fsync01.c
ltp/testcases/kernel/syscalls/get_robust_list/get_robust_list01.c
ltp/testcases/kernel/syscalls/getdomainname/getdomainname01.c
ltp/testcases/kernel/syscalls/getegid/getegid01.c
ltp/testcases/kernel/syscalls/getegid/getegid02.c
ltp/testcases/kernel/syscalls/geteuid/geteuid01.c
ltp/testcases/kernel/syscalls/getgid/getgid01.c
ltp/testcases/kernel/syscalls/getgid/getgid03.c
ltp/testcases/kernel/syscalls/gethostname/gethostname01.c
ltp/testcases/kernel/syscalls/getpgrp/getpgrp01.c
ltp/testcases/kernel/syscalls/getpid/getpid01.c
ltp/testcases/kernel/syscalls/getppid/getppid01.c
ltp/testcases/kernel/syscalls/getpriority/getpriority01.c
ltp/testcases/kernel/syscalls/getpriority/getpriority02.c
ltp/testcases/kernel/syscalls/getrusage/getrusage01.c
ltp/testcases/kernel/syscalls/getrusage/getrusage02.c
ltp/testcases/kernel/syscalls/getsockname/getsockname01.c
ltp/testcases/kernel/syscalls/getsockopt/getsockopt01.c
ltp/testcases/kernel/syscalls/gettid/gettid01.c
ltp/testcases/kernel/syscalls/getuid/getuid01.c
ltp/testcases/kernel/syscalls/getuid/getuid02.c
ltp/testcases/kernel/syscalls/getuid/getuid03.c
ltp/testcases/kernel/syscalls/io_cancel/io_cancel01.c
ltp/testcases/kernel/syscalls/io_destroy/io_destroy01.c
ltp/testcases/kernel/syscalls/io_getevents/io_getevents01.c
ltp/testcases/kernel/syscalls/io_setup/io_setup01.c
ltp/testcases/kernel/syscalls/io_submit/io_submit01.c
ltp/testcases/kernel/syscalls/ioperm/ioperm02.c
ltp/testcases/kernel/syscalls/iopl/iopl01.c
ltp/testcases/kernel/syscalls/iopl/iopl02.c
ltp/testcases/kernel/syscalls/lchown/lchown02.c
ltp/testcases/kernel/syscalls/link/link02.c
ltp/testcases/kernel/syscalls/link/link03.c
ltp/testcases/kernel/syscalls/link/link04.c
ltp/testcases/kernel/syscalls/link/link05.c
ltp/testcases/kernel/syscalls/link/link06.c
ltp/testcases/kernel/syscalls/link/link07.c
ltp/testcases/kernel/syscalls/listen/listen01.c
ltp/testcases/kernel/syscalls/llseek/llseek02.c
ltp/testcases/kernel/syscalls/lseek/lseek02.c
ltp/testcases/kernel/syscalls/lseek/lseek03.c
ltp/testcases/kernel/syscalls/lseek/lseek04.c
ltp/testcases/kernel/syscalls/lseek/lseek05.c
ltp/testcases/kernel/syscalls/lseek/lseek06.c
ltp/testcases/kernel/syscalls/lseek/lseek08.c
ltp/testcases/kernel/syscalls/lseek/lseek09.c
ltp/testcases/kernel/syscalls/lseek/lseek10.c
ltp/testcases/kernel/syscalls/lstat/lstat01.c
ltp/testcases/kernel/syscalls/lstat/lstat02.c
ltp/testcases/kernel/syscalls/madvise/madvise01.c
ltp/testcases/kernel/syscalls/madvise/madvise02.c
ltp/testcases/kernel/syscalls/madvise/madvise03.c
ltp/testcases/kernel/syscalls/mlock/mlock01.c
ltp/testcases/kernel/syscalls/mlock/mlock02.c
ltp/testcases/kernel/syscalls/times/times01.c
ltp/testcases/kernel/syscalls/wait/wait02.c
ltp/testcases/network/tcp_cmds/netstat/netstat01
ltp/testcases/kernel/fs/fs-bench/modaltr.sh
ltp/testcases/kernel/fs/mongo/test.sh
ltp/testcases/network/tcp_cmds/netstat/netstat01

74) Log Message:
mem/hugetlb: fix failure of hugemmap03: 1) In mmap's manual, The starting a=
ddress for the new mapping is specified in addr. So, if mmap's argument "ad=
dr" is reachable, the mmap will creates a new mapping in the virtual addres=
s space of the call-ing process. The test hugemmap03 will test that a norma=
l page cannot be mapped into a high memory region. This infers that "addr" =
should be higher for 64-bit mode. 2) The test use "-I2" option, and this no=
t only causes TFAIL's loop, but also causes TPASS's loop. For TFAIL, loop i=
s deserved, nor for TPASS. This patch fixed these problems. Signed-off-by: =
Liu Bo <liubo2009@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/mem/hugetlb/hugemmap/hugemmap03.c

75) Log Message:
Some fixes of shell scripts of tests: this patch fixes some minor bugs in t=
he code of LTP shell scripts:=20
 - quote arguments of test(1) in some places concerning redhat detection,
 - don't execute the result of type(1), it makes no sense - even more when =
the output of it should be redirected,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/commands/ade/file/file_test.sh
ltp/testcases/commands/cron/cron_allow01
ltp/testcases/commands/cron/cron_deny01
ltp/testcases/commands/cron/cron_pos_tests.sh
ltp/testcases/commands/mail/mail_tests.sh
ltp/testcases/commands/su/su01
ltp/testcases/network/tcp_cmds/rdist/rdist01

76) Log Message:
Complete the test cases for geteuid16: Another small patch to complete the =
test cases for *16. Put compat_16.h to testcases/kernel/syscalls/geteuid. S=
igned-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/testcases/kernel/syscalls/geteuid/Makefile
ltp/testcases/kernel/syscalls/geteuid/geteuid01.c
Added Files:
ltp/testcases/kernel/syscalls/geteuid/compat_16.h

77) Log Message:
Fix failures messages on multi socket hyper threaded system. Signed-off-by:=
 poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/runpwtests.sh

78) Log Message:
Patch to remove hard coded cpu governers. Signed-off-by: poornima nayak <mp=
nayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/pwkm_load_unload.sh

79) Log Message:
Garret added a new testcase for ptrace() syscall: The following calls ptrac=
e(PTRACE_TRACEME, 0) for all signals and validates that all signals apart f=
rom SIGKILL are properly intercepted and WIFSTOPPED remains true, and SIGKI=
LL is properly treated as WIFSIGNALED() && WTERMSIG() returns SIGKILL.I loo=
ked at it again this weekend, and my criterion for kill (..., 0) was incorr=
ect. The newer version passes, and tests correct criterion, as per the manp=
age:
1. This test app helped unroot another issue with our custom Linux platform=
 here at Cisco,
2. This test application does function properly on a Gentoo Linux based x86=
_64 / 2.6.30 kernel however, so it's an issue with our OS platform,
I will add this application to testcases/kernel/syscalls/ptrace, if someone=
 else sees the value in it. I agree that additional error checking could be=
 added for the calls to kill(2)... I just whipped this up in 45 mins after =
finding this strange behavior on our platform. Signed-off-by: Garrett Coope=
r <yanegomi@gmail.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/ptrace/ptrace05.c

80) Log Message:
lcov: remove unnecessary warning

Modified Files:
ltp/utils/analysis/lcov/bin/geninfo

81) Log Message:
lcov: fix problem with matching filename
- used correct source for filenames
- converted match_filenames to portable version,

Modified Files:
ltp/utils/analysis/lcov/bin/geninfo

82) Log Message:
lcov: remove further unneeded warning + use correct source for list of file=
names

Modified Files:
ltp/utils/analysis/lcov/bin/geninfo

83) Log Message:
lcov: update README to mention required -lgcov switch during linking

Modified File(s):
ltp/utils/analysis/lcov/README

84) Log Message:
lcov: further clarification in the README

Modified Files:
ltp/utils/analysis/lcov/README

85) Log Message:
Fix a bashism that was pointed out in other files by Jiri Palecek. Signed-o=
ff-by: Garrett Cooper <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/lib/cmdlib.sh

86) Log Message:
Avoid a possible issue with the test statement for SHELL_DEBUG if the user =
set it to something nasty like -x. Signed-off-by: Garrett Cooper <yanegomi@=
gmail.com>.

Modified Files:
ltp/testcases/lib/cmdlib.sh

87) Log Message:
Stupid Garrett. I need to increment the value... Signed-off-by: Garrett Coo=
per <yanegomi@gmail.com>.

Modified Files:
ltp/testcases/lib/mdlib.sh


--=-S+uMJvhGoFwxx1dKPyIA--

