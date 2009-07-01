Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZGAM1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZGAM1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZGAM1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:27:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47244 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZGAM1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:27:31 -0400
Subject: [LTP] [ANNOUNCE] The Linux Test Project has been Released for JUNE
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Francesco Rundo <francesco.rundo@st.com>,
       Cyril Hrubis <chrubis@suse.cz>, rohit verma <rohit.170309@gmail.com>,
       Nicolas Joly <njoly@pasteur.fr>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Jiri Palecek <jpalecek@web.de>,
       Naresh Kamboju <naresh.kernel@gmail.com>,
       Manas Kumar Nayak <maknayak@in.ibm.com>,
       nobuhiro <nobuhiro@andestech.com>, Masatake YAMATO <yamato@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Henry Yei <hyei@mvista.com>, Darren Hart <dvhltc@us.ibm.com>,
       Gowrishankar <gowrishankar.m@in.ibm.com>,
       "poornima.nayak" <poornima.nayak@in.ibm.com>,
       poornima nayak <mpnayak@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary="=-NGig3EtqKugynN4mpdIn"
Organization: IBM
Date: Wed, 01 Jul 2009 17:56:40 +0530
Message-Id: <1246451200.6978.53.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NGig3EtqKugynN4mpdIn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
JUNE 2009. Please see ltp/INSTALL file carefully, as, there has been
multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
JUNE 2009 Highlights:
========================
* Addition of 6 testcases for 5 new system calls,
* Major fixes for all new syscall tests,
* Major fixes for Power Management tests,
* Fixes for numerous other tests,
------------------------------

==============================
JUNE 2009 LTP Contributors:
==============================
* Manas Kumar Nayak,
* Márton Németh,
* Francesco Rundo,
* Cyril Hrubis,
* Rohit Verma,
* Nicolas Joly,
* Wei Yongjun,
* Jiri Palecek,
* Naresh Kamboju,
* Nobuhiro,
* Masatake YAMATO,
* Sukadev Bhattiprolu,
* Henry Yei,
* Darren Hart,
* Gowrishankar,
* Poornima Nayak,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
Manas completed porting the remaining tests from Crackerjack to LTP. Due
to inherent design issues in the existing tests, we found major build
issues on varied archs/distors. Jiri/Naresh chipped in to solve majority
of them. I hope all such issues has been fixed by now. 

There is always a price to be paid for newer test cases. And the price
for fixing them is definitely lesser provided the benefits the new test
cases bring in. Some of you are very skeptical and wants every release
of LTP to be very stable. Let me point that even there are situations
when the Linux kernel itself breaks to build on certain situations. And
trying to build LTP on multiple platforms and distros is a much bigger
challenge. Stability takes some time to arrive.

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

--=-NGig3EtqKugynN4mpdIn
Content-Disposition: attachment; filename=June-2009_Changelog.txt
Content-Type: text/plain; name=June-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
Update the KERNEL_CONFIG Options accordingly. Subrata Modak<subrata@linux.v=
net.ibm.com>.

Modified File(s):
ltp/README

2) Log Message:
This is the v4l-test 0.15 patch for LTP. Changes: Test cases added for VIDI=
OC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS and VIDIOC_TRY_EXT_CTRLS. Signed-off-by:=
 M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/results.html
Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_EXT_CTRLS.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_EXT_CTRLS.h

3) Log Message:
I'd like to submit a request to change the method to check if CGROUPS suppo=
rt is enabled and available or not. I'm referring to the kernel/controllers=
/xxx testcase. I'm using the LTP-full-20090430 cross-compiled for SH based =
arch with a kernel 2.6.23. The used/released  method placed inside kernel/c=
ontrollers/Makefile, tries to understand if the cgroups (and others related=
...) support has been enabled in the current kernel, performing a check in =
the root filesystem under "/proc". It makes something like that: CHECK_CGRO=
UP :=3D $(shell test -f /proc/cgroups && echo 'cgroup') Now, in the context=
 of LTP built for i386, the above check works fine. But what happen if LTP =
is cross-built ? Unfortunately, the "/proc" entry checked by the above Make=
file rule, is the ones placed in the host and not the "/proc" of the  targe=
t root filesysetm (in my case SH based target). This is wrong! Moreover,  "=
/proc" is an entry which makes sense at runtime while it is useless at buil=
t time so the above check is "always" not applicable in case of LTP is buil=
t for other arch different from i386. In order to cover the scenario in whi=
ch LTP is cross-built, I've patched the Makefile , replacing the above rule=
 with the following ones: The above checked header file "cgroupstats.h" is =
placed in the target rootfs.  If the cgroups support is available (and enab=
led...likely ;-) the above header is placed in the target rootfs. In that w=
ay, in case of cross-compilation (the env CROSS_COMPILE was defined) the ch=
eck will be done in the header file instead of  /proc. The env TARGET_DIR w=
orks like a "--prefix" fixing the path of the cross-target rootfs. Of cours=
e, If you have another checks/methods which can be done to understand -at b=
uild time- if cgroups support is available and/or enabled -for target platf=
orm-, please feel free to post a comment to LTP. Anyway, I'll attach the pa=
tch I've applied in our system. Advices and feedbacks are welcome!. Signed-=
off-by: Francesco Rundo <francesco.rundo@st.com>.

Modified File(s):
ltp/testcases/kernel/controllers/Makefile

4) Log Message:
Test library cleanups: Removing no longer used code from test.h eg. test_er=
ror.c is no longer in ltp, and the same for t_res.c so there is no need to =
include function prototypes for these. Adding void to functions that doesn'=
t take any parameters; tst_exit() -> tst_exit(void); so code that pases par=
ameters to these is not compileable any more. Also fixes all test broken by=
 that change. As parameters passed to tst_exit() are ignored anyway it's qu=
ite safe to just remove them; but I'would rather see someone take a closer =
look. Code cleanups and fixes in tst_res.c:
* removed trivial and useless comments,
* cleaned coding style,
* and much more,
TODO: there is much redundant code in tst_res.c I'll eliminate that by stat=
ic functions. Signed-off-by: chrubis@suse.cz.

Modified Files:
ltp/include/compiler.h
ltp/include/test.h
ltp/lib/get_high_address.c
ltp/lib/tst_is_cwd_nfs.c
ltp/lib/tst_is_cwd_tmpfs.c
ltp/lib/tst_res.c
ltp/lib/tst_tmpdir.c
ltp/testcases/kernel/containers/mqns/mqns_01.c
ltp/testcases/kernel/containers/mqns/mqns_02.c
ltp/testcases/kernel/containers/mqns/mqns_03.c
ltp/testcases/kernel/containers/mqns/mqns_04.c
ltp/testcases/kernel/containers/pidns/pidns30.c
ltp/testcases/kernel/containers/pidns/pidns31.c
ltp/testcases/kernel/containers/sysvipc/shmnstest.c
ltp/testcases/kernel/mem/mmapstress/mmapstress01.c
ltp/testcases/kernel/security/cap_bound/cap_bounds_r.c
ltp/testcases/kernel/security/cap_bound/cap_bounds_rw.c
ltp/testcases/kernel/security/cap_bound/cap_bset_inh_bounds.c
ltp/testcases/kernel/security/cap_bound/check_pe.c
ltp/testcases/kernel/security/cap_bound/exec_with_inh.c
ltp/testcases/kernel/security/cap_bound/exec_without_inh.c
ltp/testcases/kernel/syscalls/madvise/madvise03.c
ltp/testcases/kernel/syscalls/sbrk/sbrk01.c
ltp/testcases/kernel/syscalls/setpgrp/setpgrp01.c

5) Log Message:
Detect test results more accurately when generating HTML. PFA the patch for=
 the changes to pan driver for a possible fix to the report generation issu=
e. I have modified genhtml.pl script to reflect changes in pan driver. Note=
: The 'Initiation-status' column is now present after Test-output column. S=
igned-off-by: rohit verma <rohit.170309@gmail.com>.

Modified Files:
ltp/pan/ltp-pan.c
ltp/tools/genhtml.pl
ltp/tools/html_report_header.txt

6) Log Message:
LTP May 2009 build fail fix for ssgetmask() syscall: Don't `syscall()' macr=
o already take care ot this ? What about adding the __NR_sgetmask/__NR_sset=
mask to <arch>.in files instead ? Just to test, i added the following lines=
 to testcases/kernel/include/i386.in :
__NR_sgetmask            68
__NR_ssetmask            69
and the problem on x86_64 is gone, without any further modification. Nicola=
s Joly <njoly@pasteur.fr>.

Modified Files:
ltp/testcases/kernel/include/i386.in

7) Log Message:
chmod05: fix to modify the group ownership before do dir chmod. Refer to th=
e manpage: # man 2 chmod: If the calling process is not privileged (Linux: =
does not have the CAP_FSETID capability), and the group of the file does no=
t match the effective group ID of the process or one of its supplementary g=
roup IDs, the S_ISGID bit will be turned off, but this will not cause an er=
ror to be returned. So, if we want S_ISGID bit be turned off after chmod(),=
 we can not have the CAP_FSETID capability and not match the effective grou=
p ID. The 'bin' group always has the CAP_FSETID capability, so we can not c=
hange the own of the TESTDIR to 'bin' group, instead, 'nobody' can be used.=
 This patch fixed the problem by change gid of chown to 'nobody' group and =
change the gid of setegid() to 'bin' group. Signed-off-by: Wei Yongjun <yjw=
ei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/chmod/chmod05.c

8) Log Message:
chmod05: fix the effective user when do cleanup: The TESTDIR is created by =
root user, but when we do cleanup, the effective user had been changed to n=
obody, so the cleanup will be failed when the TESTDIR is removed.   chmod05=
     0  WARN  :  tst_rmdir(): rmobj(/tmp/chmOpEdLA) failed: \ remove(/tmp/c=
hmOpEdLA) failed; errno=3D1: Operation not permitted. This patch fixed the =
problem by reset the effective user to root. Signed-off-by: Wei Yongjun <yj=
wei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/chmod/chmod05.c

9) Log Message:
Include config.h in aio01, to get HAVE_LIBAIO_H. This patch is necessary fo=
r aio01 test to actually test something. Signed-off-by: Jiri Palecek <jpale=
cek@web.de>.

Modified Files:
ltp/testcases/kernel/io/aio/aio01/aio01.c

10) Log Message:
Don't create the message queue in mq_open01 when the test specifies O_CREAT=
 flag: The tests need to create the message queue themselves to specify the=
 creation attributes. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/mq_open/mq_open01.c

11) Log Message:
Change syscall numbers to symbolic constants in rt_sigprocmask01: This patc=
h changes the syscall numbers in rt_sigprocmask01 test to symbolic constant=
s, to make it functional on other architectures than i386. Signed-off-by: J=
iri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask01.c

12) Log Message:
Change some absolute paths in the linkat test to  point to its own files in=
stead of /etc/passwd: This avoids unwanted error when /etc and /tmp are on =
different devices. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/linkat/linkat01.c

13) Log Message:
Remove the signal-waiting logic from create_sig_proc(): In create_sig_proc,=
 the child process waits for the parent to wake it with a signal. This does=
n't actually solve anything, and the implementation with pause() syscall is=
 inherently racy (the race results in a deadlock). This patch removes it; i=
t doesn't make the function race-free (it's possible the child will send th=
e signal before the parent had chance to run), but this is the best you can=
 get. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/utils/common_j_h.c

14) Log Message:
Return immediately when the ZOO file couldn't be opened, prevent crash late=
r: There was a crash in pan when the zoofile couldn't be opened; this patch=
 fixes it by disallowing the zoo_open function to continue. Signed-off-by: =
Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/pan/zoolib.c

15) Log Message:
Fix the error handling logic in power_management tests: There is a problem =
with error reporting in power_management tests. Particularly, it wouldn't r=
eport failure to pan when one of the tests failed. This patch does the foll=
owing:
  - make it actually fail when one of the tests fails,
  - assume return values other than 1 (except 0, of course) are errors, too=
,
  - write PASS messages for successful tests,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/power_management/pm_include.sh
ltp/testcases/kernel/power_management/runpwtests.sh

16) Log Message:
gcov-kernel: updated patches to work with .. in source paths. Peter Oberpar=
leiter <oberpapr@users.sourceforge.net>

Modified File(s):
ltp/utils/analysis/gcov-kernel/linux-2.6.23-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.24-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.25-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.26-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.27-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.28-gcov.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.29-gcov.patch

17) Log Message:
POSIX aio_error/3-1.c. Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.=
com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_error/3-1.c

18) Log Message:
POSIX aio_read/10-1.c. Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.=
com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_read/10-1.c

19) Log Message:
POSIX aio_write/8-1.c. Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.=
com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_write/8-1.c

20) Log Message:
POSIX aio_write/8-2.c. Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.=
com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_write/8-2.c

21) Log Message:
Add eventfd2_03 test for eventfd2() syscall. Signed-off-by: Subrata Modak <=
subrata@linux.vnet.ibm.com> . Original-author-and-copyright-holder: Davide =
Libenzi <davidel@xmailserver.org>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/eventfd2/eventfd2_03.c

22) Log Message:
POSIX aio_cancel/3-1.c. Signed-off-by: Naresh Kamboju < naresh.kernel@gmail=
.com >.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_cancel/3-1.c

23) Log Message:
POSIX mlock/12-1.c and mlock/speculative/12-1.c. EPERM: (Linux 2.6.9 and la=
ter) the caller was not privileged (CAP_IPC_LOCK) and its RLIMIT_MEMLOCK so=
ft resource limit was 0. Signed-off-by: Naresh Kamboju < naresh.kernel@gmai=
l.com >.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/mlock/12-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/mlock/speculative=
/12-1.c

24) Log Message:
Add/Port mbind01 test for mbind() syscall. Signed-off-by: Manas Kumar Nayak=
 <maknayak@in.ibm.com>.=20

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mbind/Makefile
ltp/testcases/kernel/syscalls/mbind/mbind01.c

25) Log Message:
Add/Port sched_getaffinity01 test for sched_getaffinity() syscall. Signed-o=
ff-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/sched_getaffinity/Makefile
ltp/testcases/kernel/syscalls/sched_getaffinity/sched_getaffinity01.c

26) Log Message:
Add/Port waitid01 test for waitid() syscall. Signed-off-by: Manas Kumar Nay=
ak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/waitid/Makefile
ltp/testcases/kernel/syscalls/waitid/waitid01.c

27) Log Message:
Add/Port waitid02 test for waitid() syscall. Signed-off-by: Manas Kumar Nay=
ak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/waitid/waitid02.c

28) Log Message:
Add/Port quotactl01 test for quotactl() syscall. Signed-off-by: Manas Kumar=
 Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/quotactl/Makefile
ltp/testcases/kernel/syscalls/quotactl/quotactl01.c

29) Log Message:
kernel/controllers/ testcase and CGROUPS support. please, replace on the LT=
P main the previous patch with ones attached. The attached patch add the ri=
ght labels of ifdef. This patch allows the cross-build of kernel/controller=
s (cgroups tests) testcase changing the policy to check the cgroups capabil=
ity at build-time. Signed-off-by: Francesco Rundo <francesco.rundo@st.com>.

Modified Files:
ltp/testcases/kernel/controllers/Makefile

30) Log Message:
fchmod05: fix to the group ownership and the effective user: This patch fix=
ed the modify of the group ownership before do dir chmod and fixed the effe=
ctive user when do cleanup. Those problems cause the test failed with the f=
ollowing error message:
  fchmod05    1  FAIL  :  testdir: Incorrect modes 043777, Expected 0777
  fchmod05    0  WARN  :  tst_rmdir(): rmobj(/tmp/fchUout8n) failed: remove=
(/tmp/fchUout8n) failed; errno=3D1: Operation not permitted
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/fchmod/fchmod05.c

31) Log Message:
chown03: fix the effective user when do cleanup. The TESTDIR is created by =
root user, but when we do cleanup, the effective user had been changed to n=
obody, so the cleanup will be failed when the TESTDIR is removed.
  chown03     1  PASS  :  chown() on testfile succeeds, clears setuid/gid b=
its
  chown03     0  WARN  :  tst_rmdir(): rmobj(/tmp/choYm1VHD) failed: remove=
(/tmp/choYm1VHD) failed; errno=3D1: Operation not permitted
This patch fixed the problem by reset the effective user to root. Signed-of=
f-by: Wei Yongjun <yjwei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/chown/chown03.c

32) Log Message:
mmapstress03: consider passed when returning EINVAL in the large mmap test:=
 Some architectures may return EINVAL instead of ENOMEM. This should also b=
e ok according to mmap manual: EINVAL We don't like addr, length, or offset=
 (e.g., they are too large, or not aligned on a page boundary). Signed-off-=
by: nobuhiro <nobuhiro@andestech.com>.

Modified Files:
ltp/testcases/kernel/mem/mmapstress/mmapstress03.c

33) Log Message:
Small typo in sgetmask01.c: Here follow a small patch that fix a typo in sg=
etmask01.c testcase, where __NR_ssetmask is badly used instead of __NR_sget=
mask. Signed-off-by: Nicolas Joly <njoly@pasteur.fr>.

Modified Files:
ltp/testcases/kernel/syscalls/sgetmask/sgetmask01.c

34) Log Message:
Build failure of aio02 test case: --static for gcc is really needed? I cann=
ot find strong reason for it. Signed-off-by: Masatake YAMATO <yamato@redhat=
.com>.=20

Modified Files:
ltp/testcases/kernel/io/aio/aio02/Makefile
ltp/testcases/kernel/io/aio/aio02/main.c

35) Log Message:
pidns17 testcase bugfix/cleanup: Fix minor bugs in the test case that cause=
 the test to fail intermittently. Also, print more debug info when test fai=
ls. This fixes a bug reported by Sachin P. Sant. Signed-off-by: Sukadev Bha=
ttiprolu <sukadev@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/pidns/pidns17.c

36) Log Message:
growfiles: fix static build which needs to link the pthread library: Signed=
-off-by: nobuhiro <nobuhiro@andestech.com>.

Modified Files:
ltp/testcases/kernel/fs/doio/Makefile

37) Log Message:
Script to extract description of test case from LTPROOT/doc/testcases/*.txt=
 files: Note: The formatting is applied to only kernel, misc, network and c=
ommands test-cases. Formatting used is based on my ideas and comments from =
Subrata. Comments on the same are welcome. Signed-off-by: rohit verma <rohi=
t.170309@gmail.com>.

Modified Files:
ltp/doc/testcases/commands.txt
ltp/doc/testcases/kernel.txt
ltp/doc/testcases/misc.txt
ltp/doc/testcases/network.txt

38) Log Message:
Regarding ht_enable test case failure: Pls find attached patch for ht_enabl=
ed and ht_affinity. I am not having a 16-CPU machine at my end to test ht_i=
nterrupt test code. Signed-off-by: rohit verma <rohit.170309@gmail.com>.=20

Modified Files:
ltp/runtest/hyperthreading
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTaffinity.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/HTutils.h
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/Makefile
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTenabled.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTutils.c
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/HTutils.h
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/Makefile
Added Files:
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/smt_smp_affinity.sh
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/smt_smp_enabled.sh

39) Log Message:
runltp, set user-defined tmp directory correctly: I'd like to submit this p=
atch to fix the functionality to set user-defined tmp directories for LTP r=
uns. This undos the hardcoded TMPDIR from version 1.33 which added some spe=
cial case handling of the passed in directory string, but broke the general=
 case with what looks like debug code. Patch is against 1.45 version iof ru=
nltp (head). Signed-off-by: Henry Yei <hyei@mvista.com>.=20

Modified Files:
ltp/runltp

40) Log Message:
Fixes of the tcore test. these are little fixes of the tcore.sh script:=20
- use $BIN_DIR for auxiliary files, and $TEST_DIR as temporary directory,
- don't run "cd -" if previous "cd something" failed,
- fixup the value of core_pattern, to replace possibly customized patterns =
using absolute paths or not using the name "core" for corefiles,
- don't hide error messages from expect.
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/misc/tcore_patch_test_suites/tcore.sh

41) Log Message:
Report error with the correct error file in tar_tests.sh: Signed-off-by: Ji=
ri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/commands/tar/tar_tests.sh

42) Log Message:
Fix cleanup procedure in the setuid04 test: Cleanup has to be made only onc=
e in the parent process; when the child makes the cleanup itself, the paren=
t has nothing to cleanup, which makes him sad. Signed-off-by: Jiri Palecek =
<jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/setuid/setuid04.c

43) Log Message:
Fix some bashisms, mainly in the controllers tests: Signed-off-by: Jiri Pal=
ecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/containers/netns/initialize.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_base_ops_test/cpuset_base_op=
s_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_exclusive_test/cpuset_exclus=
ive_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_hierarchy_test/cpuset_hierar=
chy_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_hotplug_test/cpuset_hotplug_=
test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_inherit_test/cpuset_inherit_=
testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuset_funcs.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_loa=
d_balance_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_sch=
ed_domains_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_pressure_test/cpuset_=
memory_pressure_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_spread_test/cpuset_me=
mory_spread_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_test/cpuset_memory_te=
stset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_=
testset.sh
ltp/testcases/kernel/controllers/memcg/memcg_regression_test.sh
ltp/testcases/kernel/io/stress_floppy/generate.sh

44) Log Message:
Setup and cleanup routines for diotest: this patch makes the cleanup proced=
ure in diotest more robust. Particularly:
- simplify cleanup by creating setup and cleanup routines,
- use tst_tmpdir() to create the test files in a temporary directory. Note =
that you can still make it use a different path with the -f filename option=
,
- delete the file in the case it was created, but couldn't be opened with O=
_DIRECT,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/io/direct_io/diotest2.c
ltp/testcases/kernel/io/direct_io/diotest3.c
ltp/testcases/kernel/io/direct_io/diotest4.c
ltp/testcases/kernel/io/direct_io/diotest5.c
ltp/testcases/kernel/io/direct_io/diotest6.c

45) Log Message:
Add test environment variables (TCID et al.) to tpm_version_tests.sh: this =
patch adds variables needed for tst_* routines into the tpm_version_tests.s=
h. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/commands/tpm-tools/tpm/tpm_version/tpm_version_tests.sh

46) Log Message:
Don't overwrite the exit code with junk value in acl_test01: the variable E=
XIT_CODE which contains the result of acl01 test, is overwritten at the end=
 of the test. This patch makes it preserve the correct value. Signed-off-by=
: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/fs/acls/acl_test01

47) Log Message:
Include "config.h" in the aio02 test to get HAVE_LIBAIO_H: Signed-off-by: J=
iri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/io/aio/aio02/main.c

48) Log Message:
This patch fixes compiler warnings for implicit function declarations, part=
icularly snprintf and usleep, in mq_notify and mq_timedreceive. Note that a=
lthough the functions are used in common_j_c.h, the macros have to be defin=
ed in the c files that include it, before any other header. Signed-off-by: =
Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/mq_notify/mq_notify01.c
ltp/testcases/kernel/syscalls/mq_timedreceive/mq_timedreceive01.c
ltp/testcases/kernel/syscalls/utils/common_j_h.c

49) Log Message:
Some makefiles ignore errors from commads ran in shell loops. This patch fi=
xes that. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/doc/man1/Makefile
ltp/doc/man3/Makefile
ltp/include/Makefile
ltp/testcases/ballista/ballista/MakefileTarget.dist
ltp/testcases/commands/unzip/Makefile
ltp/testcases/kernel/containers/netns/Makefile
ltp/testcases/kernel/controllers/cpuset/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_base_ops_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_exclusive_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_hierarchy_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_hotplug_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_inherit_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/Makefile
ltp/testcases/kernel/fs/scsi/ltpscsi/Makefile

50) Log Message:
Adapt the cgroup/test_6_2 test to the various ways clone is called on diffe=
rent architectures: Code shamelessly taken from clone01 test. Signed-off-by=
: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/controllers/cgroup/test_6_2.c
Added Files:
ltp/testcases/kernel/controllers/cgroup/clone_platform.h

51) Log Message:
Define some syscall numbers in the linux_syscall_numbers.h file, not to get=
 build failures or crappy results on other architectures which lack them. S=
igned-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/powerpc.in
ltp/testcases/kernel/include/x86_64.in
ltp/testcases/kernel/performance_counters/performance_counter01.c
ltp/testcases/kernel/performance_counters/performance_counter02.c
ltp/testcases/kernel/syscalls/mq_open/mq_open01.c
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c
ltp/testcases/kernel/syscalls/utils/numaif.h

52) Log Message:
The eventfd test creates some files in the current directory. I think it sh=
ould be creating the files in a temporary directory instead, as is already =
the standard with other LTP tests, because the current might be nonwriteabl=
e and the user might not want the files left there. Signed-off-by: Jiri Pal=
ecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/eventfd/eventfd01.c

53) Log Message:
This patch makes the telnet test avoid timeouts when the remote users promp=
t doesn't contain hostname, or is somehow irregular. It works by explicitly=
 setting the prompt in the remote shell (see the PROMPT variable). Note tha=
t setting literal value as a prompt works even when the remote shell is not=
 bash (the classic bash placeholders do not). Signed-off-by: Jiri Palecek <=
jpalecek@web.de>.

Modified Files:
ltp/testcases/network/tcp_cmds/telnet/telnet01

54) Log Message:
Use present autoconf test for asm/ldt.h in set_thread_area* tests to preven=
t build failures. Signed-off-by: Jiri Palecek <jpalecek@web.de>.=20

Modified Files:
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area01.c
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area02.c

55) Log Message:
Latest fix from Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/setuid/setuid04.c

56) Log Message:
[real-time] sched_footbal atomic start: The current barrier implementation =
results in the lowest priority thread actually starting the game (they are =
the last to be scheduled to call pthread_barrier_wait).  This thread likely=
 gets a priority boost as it holds the hb->lock for the futex associated wi=
th the barrier.  This might lead to it running ahead of the defense threads=
. In fact, any sort of barrier or cond var implementation (short of a pi aw=
are cond broadcast, which is not yet readily available) will result in a th=
undering herd situation when the FUTEX_WAKE_ALL syscall is issued, which ca=
n result in a short run of one or more offense threads while all the thread=
s get to the RUNNABLE state. This patch removes the complex starting mechan=
sims and replaces them with a simple atomic counter.  All player threads ar=
e started and once the players_ready count reaches the total player count, =
the referee starts the game by setting the ball position to zero. Tested on=
 two platforms (both x86_64, 4 and 8-way) for a combined total of 13,000 it=
erations with 0 failures. Signed-off-by: Darren Hart <dvhltc@us.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/sched_football/sched_football.c

57) Log Message:
This is a patch for the splice01 test. Previously the test was checking if =
the current working directory was NFS based as which the test. The patch ch=
anges this test to check whether the test directory is on NFS, as that is a=
ctually where the test gets run. Signed-off-by: Henry Yei <hyei@mvista.com>=
.=20

Modified Files:
ltp/testcases/kernel/syscalls/splice/splice01.c

58) Log Message:
[FIX PATCHES] All patches: To make your job easy, I have attached following=
 patched to fix system call number to __NR_syscall representation. You can =
commit all these patches. LIST:
ltp-fix-add_key.patch
ltp-fix-bdflush.patch
ltp-fix-keyctl.patch
ltp-fix-newuname.patch
ltp-fix-rt_sigprocmask.patch
ltp-fix-rt_sigsuspend.patch
ltp-fix-set_thread_area.patch
ltp-fix-set_tid_address.patch
ltp-fix-ssetmask.patch
ltp-fix-tkill.patch
Signed-off-by: naresh kamboju <naresh.kernel@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/add_key/add_key01.c
ltp/testcases/kernel/syscalls/add_key/add_key02.c
ltp/testcases/kernel/syscalls/bdflush/bdflush01.c
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c
ltp/testcases/kernel/syscalls/newuname/newuname01.c
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask02.c
ltp/testcases/kernel/syscalls/rt_sigsuspend/rt_sigsuspend01.c
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area01.c
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area02.c
ltp/testcases/kernel/syscalls/set_tid_address/set_tid_address01.c
ltp/testcases/kernel/syscalls/ssetmask/ssetmask01.c
ltp/testcases/kernel/syscalls/tkill/tkill01.c
ltp/testcases/kernel/syscalls/tkill/tkill02.c

59) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 1/10]Patch to integrate kernbench to LTP to test sched_mc=
=3D2 To verify CPU consolidation when sched_mc=3D2 we need kernbench. Hence=
 integrating it in LTP. Signed-off-by: poornima nayak <mpnayak@linux.vnet.i=
bm.com>.

Added Files:
ltp/utils/benchmark/kernbench-0.42/COPYING
ltp/utils/benchmark/kernbench-0.42/Makefile
ltp/utils/benchmark/kernbench-0.42/README
ltp/utils/benchmark/kernbench-0.42/kernbench

60) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 2/10]Makefile patch to integrate to LTP. Signed-off-by: po=
ornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/utils/benchmark/Makefile

61) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 3/10]Readme modified with pre-requisite for sched_mc=3D2 t=
est. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/README

62) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 4/10]Reusable functions for consolidation test modified Th=
is patch has fixes for sched_domian test failures in kernel version beyond =
2.6.29. Addtional new reusable functions and fixes for validation functions=
. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/lib/sched_mc.py

63) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 5/10]CPU consolidation testcase updated to handle exceptio=
ns. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/cpu_consolidation.py

64) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 6/10]sched domian testcase updated to handle exceptions. S=
igned-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.=20

Modified Files:
ltp/testcases/kernel/power_management/sched_domain.py

65) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 7/10]Fixes for sched_mc & sched_smt interface test Existin=
g testcase in LTP would fail or not cover all possible sched_mc values. Thi=
s patch has been written to make testcase flexible to run on future release=
s. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/test_sched_mc.sh
ltp/testcases/kernel/power_management/test_sched_smt.sh

66) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 8/10]New set of reusbale Library functions and fixes. Sign=
ed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/pm_include.sh

67) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 9/10]Master script modified to cover additional test scena=
rios. Signed-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/runpwtests.sh

68) Log Message:
Addtional test scenarios & fixes for power management testcases. On doing d=
emo of LTP testcases to developers we realized some more test scenarios has=
 to be added to LTP testcases for better test coverage. Also some bug fixes=
 has to be done for existing test cases to run on future versions on Linux =
Kernel. We also want to integrate kernbench in LTP for sched_mc_power_savin=
gs=3D2. Hence this list of patches include patches to integrate kernbench i=
nto LTP. The test also covers consolidation at core level for hyper threade=
d system. [Patch 10/10]Patch to add another command file in runtest. Signed=
-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Added Files:
ltp/runtest/power_management_tests_exclusive

69) Log Message:
personality test case build fail fix. Signed-off-by: Subrata Modak <subrata=
@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/personality/personality01.c
ltp/testcases/kernel/syscalls/personality/personality02.c

70) Log Message:
cacheflush01, remove extraneous characters for mips specific section: I am =
submitting a patch for cacheflush01, it looks like there are unneeded chara=
cters before return syscall(__NR_cacheflush, addr, nbytes, cache) inside th=
e mips section. Without this patch, the test does not compile with a mips c=
ompiler. Signed-off-by: Henry Yei <hyei@mvista.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/cacheflush/cacheflush01.c

71) Log Message:
Realtime: use mlockall optionally in realtime tests: Below patch adds the s=
upport to enable memory lock in realtime testcases optionally (with -m). Te=
sting Informations: Tested the realtime tests in their default profile and =
as well as using mlock option. Signed-off-by: Vernon Mauery <vernux@us.ibm.=
com>, Signed-off-by: Gowrishankar <gowrishankar.m@in.ibm.com>, Tested-by: G=
owrishankar <gowrishankar.m@in.ibm.com>, Acked-by: Kiran Prakash <kiran@lin=
ux.vnet.ibm.com>, Acked-by: Dinakar Guniguntala <dino@in.ibm.com>, Acked-by=
: Sripathi Kodi <sripathik@in.ibm.com>, Acked-by: Darren Hart <dvhltc@us.ib=
m.com>.

Modified File(s):
ltp/testcases/realtime/scripts/run_c_files.sh
ltp/testcases/realtime/doc/TODO
ltp/testcases/realtime/func/measurement/preempt_timing.c
ltp/testcases/realtime/lib/librttest.c
ltp/testcases/realtime/func/pi-tests/run_auto.sh


--=-NGig3EtqKugynN4mpdIn--

