Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZBBMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZBBMNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZBBMMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:12:54 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51522 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBMMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:12:51 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for JANUARY
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Veerendra C <veerendrac@in.ibm.com>,
       =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Masatake YAMATO <yamato@redhat.com>, CAI Qian <caiqian@cclom.cn>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Dmitry Guryanov <dguryanov@parallels.com>,
       Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>,
       "Edjunior B. Machado" <emachado@linux.vnet.ibm.com>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       Mike Frysinger <vapier@gentoo.org>, Jiri Palecek <jpalecek@web.de>,
       Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>,
       michael.knigge@set-software.de, Matt Helsley <matthltc@us.ibm.com>,
       Sonic Zhang <sonic.adi@gmail.com>
Content-Type: multipart/mixed; boundary="=-/unkifp5sDyc/jJR8swp"
Organization: IBM
Date: Mon, 02 Feb 2009 17:39:14 +0530
Message-Id: <1233576556.5934.31.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/unkifp5sDyc/jJR8swp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
JANUARY 2009. Please see ltp/INSTALL file carefully, as, there has been
multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
JANUARY 2009 Highlights:
========================
* Addition of socket02, socket03, signalfd4_01, signalfd4_02,
eventfd2_01, eventfd2_02, timerfd02, timerfd03, epoll_create2_01,
dup3_01, pipe2_01, pipe2_02,  inotify_init1_01, inotify_init1_02 &
socketpair02 system call tests,
* Addition of Numerous IPC & MQ Namespace tests & diotest07,
* Addition of Block Device Drivers tests,
* GCOV Patches for 2.6.28,
* Fixes for numerous other tests,
------------------------------

==============================
JANUARY 2009 LTP Contributors:
==============================
* Veerendra Chandrappa,
* Németh Márton,
* Masatake YAMATO,
* CAI Qian,
* Kamalesh Babulal,
* Dmitry Guryanov,
* Ramon de Carvalho Valle,
* Edjunior B. Machado,
* Vinay Sridhar,
* Peter Oberlarlieter,
* Mike Frysinger,
* Jiri Palecek,
* Seiichi Ikarashi,
* Michael Knigge,
* Matt Helsley,
* Sonic Zhang,
* Subrata Modak,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
2009 started with a good note with lots of new test cases being added
this month. We will continue this trend and will discuss more on LTP &
OLS 2009 in the coming days.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (JANUARY 2009) for detailed
changes.

Happy testing, 
Regards-- 
Subrata,

--=-/unkifp5sDyc/jJR8swp
Content-Disposition: attachment; filename=Jan-2009_Changelog.txt
Content-Type: text/plain; name=Jan-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 8bit

1) Log Message:
Please find a patch to fix the sigsegv error on pidns13.c on containers. Signed-off-by: Veerendra C <veerendrac@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/pidns/pidns13.c

2) Log Message:
Today I released version 0.3 of v4l-test, see http://v4l-test.sourceforge.net/ for details. I also updated the LTP tree, and I attached the two files in this email. The first file is a patch against ltp-full-20081231. The second file is a tar.gz which contains the binary image files which are part of the original V4L2 API specification, revision 0.24. Signed-Off-By: Németh Márton <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_CROPCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDIO.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_STD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.h
ltp/testcases/kernel/device-drivers/v4l/user_space/video_limits.h
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html

Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDOUT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMOUTPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMOUTPUT.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_LOG_STATUS.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_LOG_STATUS.h
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.h

3) Log Message:
Introduce autoconf to inotify03.c. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/inotify03.c

4) Log Message:
The way to report a bug about configure: Introducing autoconf still causes a troble. Shooting the trouble may not be so difficult. However, some information is needed. I'll write them on INSTALL file. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/INSTALL

5) Log Message:
Convert hardlinks to softlinks in testcases/commands/unzip/Makefile:
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote: The make install of the testcases/commands/unzip fails, when the ltp sources are mounted on different filesystem other than /tmp, because the hardlinks are created by the testcase Makefile. This patches converts the hardlinks to softlinks. Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>.
CAI Qian <caiqian@cclom.cn> replied: Are you really want to change the above two soft links to hard links? I do not see it helps to fix your problem, and it will leave broken links after "make clean".
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> replied: Thanks for the review. I am resending the patch with the changes you have recommended. Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/commands/unzip/Makefile

6) Log Message:
There is a testcase in mmapstress03, which checks, that we can't mmap 2Gb-512Kb of RAM at address 0x7ff80000. But if host has > 2Gb of RAM+swap - it's valid operation: mmap maps 2Gb of ram at some other address and returns no errors. For correct working of this testcase we should add MAP_FIXED flag to mmap. Signed-Off-By: Dmitry Guryanov <dguryanov@parallels.com>.

Modified Files:
ltp/testcases/kernel/mem/mmapstress/mmapstress03.c

7) Log Message:
mmapstress03: fix mmapstress03 on x86_64: There is a testcase in mmapstress03, which tries to mmap 2Gb-4Kb at address 0x7ffff000 and checks it returns error and errno is set to ENOMEM. But such mmap is possible on x86_64. So lets tune size and address to more suitable for 64-bit architectures.. Signed-Off-By: Dmitry Guryanov <dguryanov@parallels.com>. 

Modified Files:
ltp/testcases/kernel/mem/mmapstress/mmapstress03.c

8) Log Message:
madvice03: report TCONF instead of TWARN on old kernels: If kernel is too old for executing this test, we should report TCONF for exit code will be 0. Signed-Off-By: Dmitry Guryanov <dguryanov@parallels.com>.

Modified Files:
ltp/testcases/kernel/syscalls/madvise/madvise03.c

9) Log Message:
Nancy <nancydreaming@gmail.com> reported: Case "endian_switch01" FAIL on IBM Power 6 machine. The case failed on IBM JS22, p570 and p550. Is that the case bug or the OS bug? Thank you!. Subrata Modak <subrata@linux.vnet.ibm.com> replied: This will fail for all POWER machines which are not P6 & above, and, for all other archs. However, for other archs, it will throw you appropriate message like: 
$./testcases/bin/endian_switch01 
endian_switch01    1  CONF  :  This system does not support running of switch() syscall
In P6 (and above), even it will fail if the kernel is not 2.6.26 & above. The support for this syscall was added only from then. Please see: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=745a14cc264b1832c638e41812e0cb04328b2db1. If you are running 2.6.26 on p6, then we need to investigate why this is failing, else, i would prefer to merge the following patch for avoiding to test in systems where the switch() support is not available at the first place itself. Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>,

Modified File(s):
ltp/testcases/kernel/syscalls/switch/endian_switch01.c

10) Log Message:
This patch adds RHEL4 and RHEL5 detection to refpolicy Makefile and fixes policy compilation errors on RHEL5 introduced by the bounds test policy. Signed-off-by: Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/Makefile

11) Log Messsage:
checking sys/capability.c for pidns14 and pidns16: this patch adds "sys/capability.c" checking for pidns14 and pidns16 testcases using autoconf support. Signed-off-by: Edjunior B. Machado <emachado@linux.vnet.ibm.com>.

Modified File(s):
ltp/configure.ac
ltp/testcases/kernel/containers/pidns/pidns14.c
ltp/testcases/kernel/containers/pidns/pidns16.c

12) Log Message:
Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com> wrote: in a ppc64 machine running SLES11 RC1, I'm trying to build the December 2008 LTP release (ltp-full-20081231) but it fails on "make". Mike Frysinger <vapier@gentoo.org> replied: tcore only works on x86 systems ... building/running on other systems makes no sense. Subrata Modak <subrata@linux.vnet.ibm.com> answered: Mike, Then the following Patch will be needed: Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files(s):
ltp/testcases/misc/tcore_patch_test_suites/tcore.c

13) Log Message:
A while back I had submitted an LTP patch for the vmsplice01 test case (sent on 03/27/2008). However, the code I see in the vmsplice01.c file now is not what the patch contains. Please find below the correction against the latest ltp release : Signed-off by: Vinay Sridhar <vinay@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/vmsplice/vmsplice01.c

14) Log Message:
Update kernel/device-drivers/nls test for 2.6.25: the attached patch makes the ltp/testcases/kernel/device-drivers/nls testsuite compileable under Linux kernel 2.6.25. Currently the test_nls_base() crashes with 2.6.25, but without calling that function the module loads and unloads cleanly. This can be a base for checking what is going wrong with nls. Signed-off-by: Márton Németh <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/nls/Makefile
ltp/testcases/kernel/device-drivers/nls/nlsTest.c
ltp/testcases/kernel/device-drivers/nls/nlsTest.h
ltp/testcases/kernel/device-drivers/nls/userBlockNLS.c
ltp/testcases/kernel/device-drivers/tbio/kernel_space/Makefile
Added Files:
ltp/testcases/kernel/device-drivers/nls/README

15) Log Message:
gcov-kernel: add patches for 2.6.28, by, Peter Oberparleiter <oberpapr@users.sourceforge.net>

Added Files:
ltp/utils/analysis/gcov-kernel/linux-2.6.28-gcov-arm-eabi.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.28-gcov-arm-hack.patch
ltp/utils/analysis/gcov-kernel/linux-2.6.28-gcov.patch

16) Log Message:
Sending the new patch along with the batch file to run the tests. Also made small modifications in the mesgq_nstest.c to fix
a) the warnings on tst_exit().
b) to remove the global var.
And to return correct error num in the batch file runipcnstest.sh. Signed-off-by: Veerendra C <veerendra@in.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/sysvipc/runipcnstest.sh
Added Files:
ltp/testcases/kernel/containers/sysvipc/mesgq_nstest.c

17) Log Message:
Avoiding build failures on ppc64, adding proper FLAG definitions and improving a bit of LTP specific stuff. Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/misc/tcore_patch_test_suites/Makefile
ltp/testcases/misc/tcore_patch_test_suites/tcore.c
ltp/testcases/misc/tcore_patch_test_suites/tcore.sh

18) Log Message:
set flags properly and just use implicit make rules. Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/testcases/misc/tcore_patch_test_suites/Makefile

19) Log Message:
I attached a preliminary testsuite for testing linux/block/genhd.c. The goal of this test suite is to check whether using block device is stable enough. A lot of test suites under ltp/testcases/kernel/device-drivers are based on the usage of block device so it shall work relayable. Note that the module under test is different in case of ltp/testcases/kernel/device-drivers/tbio/kernel_space testsuite. Signed-off-by: Márton Németh <nm127@freemail.hu>.

Added Files:
ltp/testcases/kernel/device-drivers/block/kernel_space/Makefile
ltp/testcases/kernel/device-drivers/block/kernel_space/README
ltp/testcases/kernel/device-drivers/block/kernel_space/test_block.c
ltp/testcases/kernel/device-drivers/block/kernel_space/test_genhd.c

20) Log Message:
[2nd Updates for kernel/device-drivers/nls test for 2.6.25]: Németh Márton initially wrote: the attached patch makes the ltp/testcases/kernel/device-drivers/nls testsuite compileable under Linux kernel 2.6.25. Currently the test_nls_base() crashes with 2.6.25, but without calling that function the module loads and unloads cleanly. This can be a base for checking what is going wrong with nls. Signed-off-by: Márton Németh <nm127@freemail.hu>.
Subrata Modak replied: Thanks Németh for the patch. I tested the build on my machine 2.6.27, x86_64. I have merged this Patch. However, i would request you to send me another patch containing the following information: 
1) Kernel config options to be enabled & any special library(s) to be installed to allow these tests to be built/run on kernel(s) > 2.6.25 in the following README: http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/README, 
2) Then, http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/device-drivers/nls/README, should contain information to build/install/run these tests. Since these are device drivers tests, and will be executed through insmod, etc, can we have a script which automates these steps and reports error in loading/unloading of modules as such. I think it can be a very small script as well. 
Németh Márton responded by: I added some descriptions in the mentioned READMEs. However, I would wait adding an automated shell script because the tests fails on my x86_32 system with 2.6.28, and for example "rmmod nlsTest" reports "ERROR: Module nlsTest is in use". The real problem is, however, that the one of the test case already caused NULL pointer exception. I also don't have any easy solution to report only the nlsTest output to the user other than first running "dmesg -c" and then load nlsTest.ko. After the module was loaded the "dmesg" will only show the output of the testsuite. The drawback is that the user will loose the first part of his/her "dmesg" in this way. Signed-Off-By: Németh Márton <nm127@freemail.hu>.

Modified File(s):
ltp/README
ltp/testcases/kernel/device-drivers/nls/Makefile
ltp/testcases/kernel/device-drivers/nls/README

21) Log Message:
Prevent false negatives in cron_pos_tests caused by returning exit value of wrong command. This patch fixes erroneous failure caused by returning return value of a wrong command in cron tests. Signed-Off-By: "Jiri Palecek" <jirka@debian.POK.IBM.COM>.

Modified File(s):
ltp/testcases/commands/cron/cron_pos_tests.sh

22) Log Message:
This patch fixes the following error when running sched_cli_serv test case via runltp by making the path of the data file as a runtime option and giving an absolute path of it. Signed-Off-By: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/sched/clisrv/pthcli.c
ltp/testcases/kernel/sched/clisrv/run_sched_cliserv.sh

23) Log Message:
Fix broken symlink to tst_unzip_file.zip: Creating a link to tst_unzip_file.zip by testcases/commands/unzip/Makefile, has a problem and it seems to be fixed by http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/commands/unzip/Makefile?r1=1.2&r2=1.3. So I made a fix (this patch against ltp-full-20081231). Signed-off-by: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>.

Modified File(s):
ltp/testcases/commands/unzip/Makefile

24) Log Message:
Fix for msgctl11.c: Resending the fix after modifications based on suggestions from Mike Frysinger. PS: I've retained SHRT_MAX return value in the patch below as per the reason stated earlier. Signed-off by: Vinay Sridhar <vinay@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl11.c
Added Files:
ltp/include/system_specific_process_info.h
ltp/lib/system_specific_process_info.c

25) Log Message:
I encountered a failure on running ltpstress.sh. This problem seems to be introduced by http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testscripts/ltpstress.sh?r1=1.26&r2=1.27, Since I don't know why it wanted to eliminate rpcinfo command, I wrote two solutions attached. Signed-off-by: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>. 

Modified File(s):
ltp/testscripts/ltpstress.sh

26) Log Message:
Adding AUTOCONF rules for eventfd syscall tests. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/configure.ac
ltp/testcases/kernel/syscalls/eventfd/Makefile
ltp/testcases/kernel/syscalls/eventfd/eventfd01.c
Added Files:
ltp/config.mk.in
ltp/m4/ltp-eventfd.m4

27) Log Message:
Add "tc" paramter for "block" testsuite which enables the testsuite to run test cases separately. The default value of tc is 0 which preserves the original behaviour and runs all the available test cases. A user space shell script "run.sh" is also added which helps to run the test cases in kernel space. Signed-off-by: Márton Németh <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/block/kernel_space/Makefile
ltp/testcases/kernel/device-drivers/block/kernel_space/test_block.c
Added Files:
ltp/testcases/kernel/device-drivers/block/kernel_space/run.sh

28) Log Message:
Add  socket02  syscall  test, testing socket(SOCK_CLOEXEC)  and socketpair(SOCK_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/socket/socket02.c

29) Log Message:
Add  paccept01  syscall  test, testing paccept(SOCK_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>,

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/paccept/Makefile
ltp/testcases/kernel/syscalls/paccept/paccept01.c

30) Log Message:
Add  signalfd4_01  syscall  test, testing signalfd4(SFD_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>,

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/signalfd4/Makefile
ltp/testcases/kernel/syscalls/signalfd4/signalfd4_01.c

31) Log Message:
Add  eventfd2_01  syscall  test, testing eventfd2(EFD_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/eventfd2/Makefile
ltp/testcases/kernel/syscalls/eventfd2/eventfd2_01.c

32) Log Message:
Add  timerfd02  syscall  test, testing timerfd_create(TFD_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/timerfd/timerfd02.c

33) Log Message:
Add  epoll_create2_01  syscall  test, testing epoll_create2(EPOLL_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/epoll_create2/Makefile
ltp/testcases/kernel/syscalls/epoll_create2/epoll_create2_01.c

34) Log Message:
Add  dup3_01  syscall  test, testing dup3   (O_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>,.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/dup3/Makefile
ltp/testcases/kernel/syscalls/dup3/dup3_01.c

35) Log Message:
Add  pipe2_01  syscall  test, testing pipe2(O_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/pipe2/Makefile
ltp/testcases/kernel/syscalls/pipe2/pipe2_01.c

36) Log Message:
Add  inotify_init1_01  syscall  test, testing inotify_init1(O_CLOEXEC). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/inotify_init/Makefile
ltp/testcases/kernel/syscalls/inotify_init/inotify_init1_01.c

37) Log Message:
Add  socket03  syscall  test, testing socket(SOCK_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/socket/Makefile
Added Files:
ltp/testcases/kernel/syscalls/socket/socket03.c

38) Log Message:
Add  socketpair02  syscall  test, testing socketpair(SOCK_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/socketpair/Makefile
Added Files:
ltp/testcases/kernel/syscalls/socketpair/socketpair02.c

39) Log Message:
Add  paccept02  syscall  test, testing paccept(SOCK_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/paccept/paccept02.c

40) Log Message:
Add  signalfd4_02  syscall  test, testing signalfd4(SFD_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/signalfd4/signalfd4_02.c

41) Log Message:
Add  eventfd2_02  syscall  test, testing eventfd2(EFD_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/eventfd2/eventfd2_02.c

42) Log Message:
Add  timerfd03  syscall  test, testing timerfd_create(TFD_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/timerfd/timerfd03.c

43) Log Message:
Add  pipe2_02  syscall  test, testing pipe2(O_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/pipe2/pipe2_02.c

44) Log Message:
Add  inotify_init1_02  syscall  test, testing inotify_init1(IN_NONBLOCK). Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/inotify_init/inotify_init1_02.c

45) Log Message:
This patch fixes fcntl27 and fcntl28 test cases failures seen on RHEL 4 kernel (2.6.9 based).
# ./fcntl27
fcntl27     1  FAIL  :  fcntl(tfile_1206, F_SETLEASE, F_RDLCK) failed with errno 11 : Resource temporarily unavailable
# ./fcntl28 
fcntl28     1  FAIL  :  fcntl(tfile_1213, F_SETLEASE, F_RDLCK) failed with errno 11 : Resource temporarily unavailable

It because the expected result in incorrect. There is a kernel version comparison code in both tests.
    if ((results=tst_kvercmp(2,6,10)) >= 0)
          {
            expected_result = -1;
          }
    else if( ((results=tst_kvercmp(2,4,0)) >= 0)&&\
             ((results=tst_kvercmp(2,6,0))< 0) )
      {
            expected_result = 1;
      }
    else if( ((results=tst_kvercmp(2,6,0)) >= 0)&&\
         ((results=tst_kvercmp(2,6,10))< 0) )
      {
            expected_result = 0;
      }
    else
      {
             expected_result = -1;
      }

Because it is kernel 2.6.9, the "expected_result" will be 0. However, th actual return code is the same as other kernels like 2.6.18, as it only allow F_RDLCK option to be placed on a read-only file descriptor (man fcntl). 
# strace ./fcntl27 
...
open("tfile_1453", O_RDWR|O_CREAT, 0777) = 3
...
fcntl(3, 0x400 /* F_??? */, 0)          = -1 EAGAIN (Resource temporarily unavailable)

I have no idea where is the above kernel version and expected code mapping originally came from. I have searched the manpage of fcntl(), but not found any mention of 2.6.10. Since there is a check already, #ifdef F_SETLEASE I have removed the above code like other fcntl* test cases, but I am willing to listen other options. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/kernel/syscalls/fcntl/fcntl27.c
ltp/testcases/kernel/syscalls/fcntl/fcntl28.c

46) Log Message:
This problem was reported earlier. Following is a brief history for this issue: The ltp/testcases/kernel/syscalls/ioctl/ioctl02 testcase was failing on 2.6.27 on x86_64 kernel(s).
# ./ioctl02 -D /dev/tty0
ioctl02     0  INFO  :  cflag has incorrect value. 4277
ioctl02     1  FAIL  :  TCGETA/TCSETA tests FAILED with 1 error
ioctl02     0  INFO  :  child: Got SIGTERM from parent.
The following mail archive tells that it can be a kernel driver problem: http://sourceforge.net/mailarchive/message.php?msg_name=48F4CFF7.8070303%0terra.com.br. It seems there is some modification between 2.6.23 and 2.6.24-rc1 which raise this problem. Looking at the git log of file drivers/char/tty_ioctl.c there are few commits between these two releases (3 to be exactly, and one of them is a typo):
tty: expose new methods needed for drivers to get termios right:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f519d728169fa9975bcba001de425f11e18e8e3,
tty_ioctl: fix the baud_table check in encode_baud_rate:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=75e8b71d559632dd70c9799ea8b5c133a2ddcea9,
Somebody says: The ltp-list thread referenced seems to imply that the new functionality is correct and that the relevant LTP test needs to change, whereas others disagreed: Afaics, the ltp-list thread didn't conclude if the testcase should be fixed or if there's a problem in the kernel tty modification. Beyond this, there is this comment from Alan Cox on commit 5f519d728169fa9975bcba001de425f11e18e8e3 (mainly the last 3 paragraphs), mentioning that he was expecting some "tweaking" until the drivers were fixed. However, i tried to set only the HUPCL | CREAD | CLOCAL bits, still the tests failed for 2.6.27 kernels. So, i have prepared 2 patches: 
1) PATCH 1: Patch to Find the core problem with ioctl02: (This is for demonstration and not to be applied)
This clearly demonstrates that something goes wrong when: ioctl(parentfd, TCGETA, &termio) gets called. It alters the value of c_cflag. However other flags´ values remain unchanged:
# ./ioctl02 -D /dev/tty0
ioctl02     0  INFO  :  Trying to the Set the value of c_cflag, present value of c_cflag=0 
ioctl02     0  INFO  :  Trying to the Set the value of c_cflag, value of c_cflag to be set to=5641
ioctl02     0  INFO  :  After Setting the value of c_cflag, value of c_cflag=5641
ioctl02     0  INFO  :  Before Calling ioctl(parentfd, TCSETA, &termio), the value of c_cflag, value of c_cflag=5641
ioctl02     0  INFO  :  After Calling ioctl(parentfd, TCSETA, &termio), the value of c_cflag, value of c_cflag=5641
ioctl02     0  INFO  :  Before Calling ioctl(parentfd, TCGETA, &termio), the value of c_cflag, value of c_cflag=5641
ioctl02     0  INFO  :  After Calling ioctl(parentfd, TCGETA, &termio), the value of c_cflag, value of c_cflag=4277
ioctl02     0  INFO  :  cflag has incorrect value. 4277  
ioctl02     1  FAIL  :  TCGETA/TCSETA tests FAILED with 1 error 
ioctl02     0  INFO  :  child: Got SIGTERM from parent.
2) PATCH 2: Patch to Remove Checking for "termio.c_cflag": The only way Test can handle this to make it pass is to avoid checking for this flag which is causing the trouble, which this patch does: 
# ./ioctl02 -D /dev/tty0
ioctl02     0  INFO  :  termio values are set as expected
ioctl02     1  PASS  :  TCGETA/TCSETA tests SUCCEEDED
ioctl02     0  INFO  :  child: Got SIGTERM from parent.
However, i still believe that there is something to be fixed from the kernel side, rather than from the test side, although this patch will make the test PASS for the time being. And i will not have any problem applying this patch. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/ioctl/ioctl02.c

47) Log Message:
Integrate autotools a bit more so that we can take advantage of the configure features like toolchain selection and build flags. Mike Frysinger <vapier@users.sourceforge.net>.

Modified File(s):
ltp/.gitignore
ltp/Makefile
ltp/config.mk.in
ltp/configure.ac
ltp/m4/GNUmakefile
ltp/m4/Makefile.am
ltp/m4/ac_prog_ar.m4

48) Log Message:
Move documentation from Makefile to INSTALL ... patch by Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/INSTALL
ltp/Makefile

49) Log Message:
Update to OpenHPI 2.13.2. See http://openhpi.org/ for more details.

Modified File(s):
/ltp/testcases/open_hpi_testsuite/

50) Log Message:
The at tests copy the testscript to the home directories of newly created users. This may fail if the home directory does not exist. This patch fixes that by adding an option to create home directories to useradd. Signed-Off-By: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/testcases/commands/at/at_allow01
ltp/testcases/commands/at/at_deny01

51) Log Message:
This patch fixes a segfault of pan, when the command file doesn't end with a newline. Signed-Off-By: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/pan/pan.c

52) Log Message:
Seiichi Ikarashi reported:: I report ia64-specific build failures and a patch for them. Since ia64 glibc does not have the clone() function call, building testcases/kernel/containers/pidns/pidns12.c fails as follows. It's same for pidns13.c, pidns14.c, pidns16.c, pidns20.c, pidns21.c, pidns30.c, and pidns31.c. They should call clone2() instead of clone(), like check_pidns_enabled.c. I attached a patch to fix them. Signed-Off-By: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>. Complete mail thread: http://marc.info/?l=ltp-list&m=123232695003986&w=2.

Modified File(s):
ltp/testcases/kernel/containers/libclone/libclone.c
ltp/testcases/kernel/containers/libclone/libclone.h
ltp/testcases/kernel/containers/pidns/check_pidns_enabled.c
ltp/testcases/kernel/containers/pidns/pidns12.c
ltp/testcases/kernel/containers/pidns/pidns13.c
ltp/testcases/kernel/containers/pidns/pidns14.c
ltp/testcases/kernel/containers/pidns/pidns16.c
ltp/testcases/kernel/containers/pidns/pidns20.c
ltp/testcases/kernel/containers/pidns/pidns21.c
ltp/testcases/kernel/containers/pidns/pidns30.c
ltp/testcases/kernel/containers/pidns/pidns31.c

53) Log Message:
ftest02: size of 'name' buffer must be more than 3:: name will be passed to mkname function, which will copy to it temporary directory name. So let's it will be 128 as other buffers, passed to mkname. Signed-Off-By: Dmitry Guryanov <dguryanov@parallels.com>.

Modified File(s):
ltp/testcases/kernel/fs/ftest/ftest02.c

54) Log Message:
Help text needs updating then ... now we need to run `make autotools`. this will invoke aclocal and automake.  we dont actually use automake-generated Makefiles, but the fun helper files (install.sh, config.guess, etc...) come from automake. Here is a quickfix. However, it is not perfect. Could you improve this? Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/INSTALL
ltp/Makefile

55) Log Message:
Removed check_header from Makefile of io_* testcases and use autoconf instead of the macro. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/testcases/kernel/syscalls/io_cancel/Makefile
ltp/testcases/kernel/syscalls/io_cancel/io_cancel01.c
ltp/testcases/kernel/syscalls/io_destroy/Makefile
ltp/testcases/kernel/syscalls/io_destroy/io_destroy01.c
ltp/testcases/kernel/syscalls/io_getevents/Makefile
ltp/testcases/kernel/syscalls/io_getevents/io_getevents01.c
ltp/testcases/kernel/syscalls/io_setup/Makefile
ltp/testcases/kernel/syscalls/io_setup/io_setup01.c
ltp/testcases/kernel/syscalls/io_submit/Makefile
ltp/testcases/kernel/syscalls/io_submit/io_submit01.c

56) Log Message:
This patch fixes the syslog tests on Debian. The tests currently fail on Debian, because they check for a nonexistent file. Besides that, this patch adds rsyslogd as another possibility to supported syslog daemons. The patch changes the detection of syslog_cmd and CONFIG_FILE names; they are all detected by checking for possible files. I have not tested it on a different distro than Debian, but it should work on them too. Signed-Off-By: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
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

57) Log Message:
lcov: remove CRLF line breaks in source code when generating html output - added patch by michael.knigge@set-software.de.

Modified Files:
ltp/utils/analysis/lcov/bin/genhtml

58) Log Message:
Create a dummy config.mk when running just `make`. Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/Makefile

59) Log Message:
Require automake-1.10. Mike Frysinger <vapier@users.sourceforge.net>.

Modified File(s):
ltp/configure.ac

60) Log Message:
Info regarding various dependant packages for LTP build/install. Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/INSTALL

61) Log Message:
lcov: modify end-of-line CR removal
- s///g is 10% slower than s///
- \r may be 0x10 or 0x13 (see man perlport),
Peter Oberparleiter <oberpapr@users.sourceforge.net>.

Modified Files:
ltp/utils/analysis/lcov/bin/genhtml

62) Log Message:
geninfo: need to add CR removal to geninfo as well or checksumming will fail. Peter Oberparleiter <oberpapr@users.sourceforge.net>

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo

63) Log Message:
[PATCH 1/6] Do not cleanup if it doesn't make sense: This is the first from the series of minor patches to syslog tests. Parts inspired by CAI Qian's remarks. Resend due to line-wrapping problems.
- Check for existence of the backup file before moving it back,
- Do not restart syslog daemon, if syslog command was not found,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
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

64) Log Message:
[PATCH 2/6] Use TFAIL/TPASS in some syslog tests. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/syslog/syslog09
ltp/testcases/kernel/syscalls/syslog/syslog10

65) Log Message:
[PATCH 3/6] Fix paths for detecting syslog daemons: Allow /usr/sbin/syslog-ng as path to syslog-ng, because this is the path used in Debian syslog-ng packages. Also, detect /sbin/rsyslogd as rsyslog, which is its location on Fedora. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
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

66) Log Message:
[PATCH 4/6] Don't check for existence of the log file before the test with syslog-ng, because it might not exist and still work correctly. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/testcases/kernel/syscalls/syslog/syslog01
ltp/testcases/kernel/syscalls/syslog/syslog02
ltp/testcases/kernel/syscalls/syslog/syslog05
ltp/testcases/kernel/syscalls/syslog/syslog09

67) Log Message:
[PATCH 5/6] Add support for rsyslog in not-syslog-compatible mode: This adds the configuration directive: $ModLoad imuxsock.so; to the beginning of the syslog configuration file when using rsyslog. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
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

68) Log Message:
[PATCH 6/6] Change the message and return value used to report missing supported syslog daemon.
- note rsyslog in the message,
- use TCONF to report unsuitable configuration,
- return 0, which corresponds to other tests failing on TCONF,
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
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

69) Log Message:
CAI Qian wrote: After apply the whole series of patches with the help of '-l'. The only failure for rsyslogd is syslog06:
syslog06    0  INFO  :  syslog: Testing the log option: LOG_NDELAY...
syslogtst    1  FAIL  :  open() has returned unexpected fd: -1,
I have noticed this line here,
# cat syslogtst.c
...
        case 6:
                config_file = "/etc/syslog.conf";
                if (system("[ -e /sbin/syslog-ng ]") == 0)
                        config_file = "/etc/syslog-ng/syslog-ng.conf";
                openlog("without log_ndelay", LOG_PID, LOG_USER);
                fd = open(config_file, O_RDONLY);
...
so it is not a surprise that open() returned -1.
Jiri Palecek <jpalecek@web.de> wrote back: Yes, that code is a gem :-) Does it work with the attached patch?
CAI Qian tested back: It works apart from something untidy.

Modified Files:
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

70) Log Message:
Fix the following build warning:
cc -I../../../../include -Wall    syslogtst.c  -L../../../../lib -lltp -o
syslogtst
syslogtst.c: In function ‘main’:
syslogtst.c:50: warning: unused variable ‘config_file’
Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

71) Log Message:
Matt Helsley reported: The dependency description in testcases/network/lib6/Makefile breaks parallel builds:
 make autoconf
 ./configure
 make -j4 all
 ...
 cc -I../../../include -g -D_GNU_SOURCE   -c -o runcc.o runcc.c
 cc -I../../../include -g -D_GNU_SOURCE    asapi_01.c -L../../../lib runcc.a
-lltp -lpthread  -o asapi_01
 cc: runcc.a: No such file or directory
This patch fixes the problem by properly expressing the build depdency between the TARGET objects and runcc.a. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>.
Garrett Cooper <yanegomi@gmail.com> replied: Sorry to knitpick, but runcc.a should really be librunc"c.a; otherwise it's not really linkable with ld when using -lruncc. You could also omit the lime with CC if implicit rules are enabled. Other than that the patch looks groovy!.
Matt Helsley replied back: Since the -l flag is not being used to link with runcc.a that's not a problem. -l adds the naming requirement and searches multiple directories. Otherwise gcc behaves as if it were just another .o. I think the only reason to prefer -l is if we're going to install it as a library. I checked and, as best I could tell, runcc.a is only used in the network/lib6 testcases. This means using -l has no advantages so I don't intend to change this part of the patch. In fact I can't see why they bothered making an archive at all. But that's a different change than I intend to make :). I guess I never relied much on the implicit rules -- I suppose the implicit rule compiling and linking each target will be triggered because the "empty" rule: 
$(TARGETS): %: %.c runcc.a
did not actually wind up creating its supposed target.. Thanks for the review. I'll post an updated patch soon. This patch fixes the problem by properly expressing the build depdency between the TARGET objects and runcc.a. Rely on the implicit rules as suggested by Garrett Cooper. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>.

Modified File(s):
ltp/testcases/network/lib6/Makefile

72) Log Message:
[Patch 1/2] Used named PIPE in test cases for NOMMU arch instead of anonymous: In NOMMU arch, anonymous PIPE can't be accessed in child process if it is started by vfork/execve. This patch use named PIPE instead. The API sync_pipe_create() and sync_pipe_close() are changed to accept PIPE name. Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>.

Modified Files:
ltp/include/libtestsuite.h
ltp/lib/libtestsuite.c

73) Log Message:
[Patch 2/2] Used named PIPE in test cases for NOMMU arch instead of anonymous: In NOMMU arch, anonymous PIPE can't be accessed in child process if it is started by vfork/execve. This patch uses named PIPE instead and changes related test cases accordingly. Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>.

Modified Files:
ltp/testcases/kernel/syscalls/execve/execve05.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv05.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv06.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd05.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd06.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl01.c
ltp/testcases/kernel/syscalls/ipc/semop/semop05.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl01.c

74) Log Message:
Submitting a new testcase on semaphore to test the IPCNS in the containers. This patch contains the batch file to run the test on LTP. In this patch , I am checking  the IPCNS functionaity: "Semaphore in parent NS is isolated from the container". Changelog: Removed the extra semget call in the check_semaphore(). Corrected the indentation. Acked-by: Serge Hallyn <serue@us.ibm.com>. Signed-Off-By: Veerendra <veeren@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/sysvipc/runipcnstest.sh
Added Files:
ltp/testcases/kernel/containers/sysvipc/sem_nstest.c

75) Log Message:
Here it goes. What i have tried to do is fix only the broken issues, where the test case(s) will not execute if enough hugepages are not available in the system. Now, i leave it on the discrition of the user to increase the hugepages in their system before executing these tests. Else, if you all agree on some way to autoset that before test execution, it would be welcome. Following patches Follow:
__001-Fix_Hugepages-Add_declaration_for_new_functions.patch
__002-Fix_Hugepages-Add_definitions_for_new_functions.patch
__003-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugepageshmget01.patch
__004-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugepageshmget03.patch
__005-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugepageshmget03_remaining_fixes.patch
__006-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugepageshmget05.patch
__007-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugepageshmget02.patch
__008-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmat01.patch
__009-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmat02.patch
__010-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmat03.patch
__011-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmctl01.patch
__012-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmctl02.patch
__013-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmctl03.patch
__014-Fix_Hugepages-Allocate_hugepages_only_if_available_to_hugeshmdt01.patch
Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/mem/hugetlb/hugeshmat/hugeshmat01.c
ltp/testcases/kernel/mem/hugetlb/hugeshmat/hugeshmat02.c
ltp/testcases/kernel/mem/hugetlb/hugeshmat/hugeshmat03.c
ltp/testcases/kernel/mem/hugetlb/hugeshmctl/hugeshmctl01.c
ltp/testcases/kernel/mem/hugetlb/hugeshmctl/hugeshmctl02.c
ltp/testcases/kernel/mem/hugetlb/hugeshmctl/hugeshmctl03.c
ltp/testcases/kernel/mem/hugetlb/hugeshmdt/hugeshmdt01.c
ltp/testcases/kernel/mem/hugetlb/hugeshmget/hugeshmget01.c
ltp/testcases/kernel/mem/hugetlb/hugeshmget/hugeshmget02.c
ltp/testcases/kernel/mem/hugetlb/hugeshmget/hugeshmget03.c
ltp/testcases/kernel/mem/hugetlb/hugeshmget/hugeshmget05.c
Added Files:
ltp/include/system_specific_hugepages_info.h
ltp/lib/system_specific_hugepages_info.c

76) Log Message:
Modify Makefile to include dma_thread_diotest7. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/io/direct_io/Makefile

77) Log Message:
Add dma_thread_diotest7. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Added Files:
ltp/testcases/kernel/io/direct_io/dma_thread_diotest7.c

78) Log Message:
Add test dma_thread_diotest7.sh. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Added Files:
ltp/testcases/kernel/io/direct_io/test_dma_thread_diotest7.sh

79) Log Message:
Add test dma_thread_diotest7 command file. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Added Files:
ltp/runtest/test_dma_thread_diotest7

80) Log Message:
Add test_dma_thread_diotest7 to runalltests.sh. Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runalltests.sh

81) Log Message:
Testing semaphore isolation between 2 containers: Here is a test case to test the semaphore isloation in container environment. Test Assertion: 
- This testcase verifies the semaphore isoloation in 2 diff containers.
- It tries to create/access a semaphore created with the same KEY.
changelog: version 2
* Modified testcase, to use only 2 pipe's to sync between 2 containers.
* Corrected the indentation. 
Signed-off-by: Veerendra C <vechandr@in.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/sysvipc/runipcnstest.sh
Added Files:
ltp/testcases/kernel/containers/sysvipc/semtest_2ns.c

82) Log Message:
Testing shmem isolation between 2 containers: Please find the testcase to test the shared memory isolation in between 2 containers. Test Assertion:
- This testcase verifies the Shared Memory isoloation in 2 containers.
- It tries to create/access a Shared Memory created with the same KEY.
Changelog: Version2
Removed extra pipe, to use only 2 pipe's for synchronizing between containers. Corrected from TPASS to TFAIL in the print statement. Signed-off-by: Veerendra C <vechandr@in.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/sysvipc/runipcnstest.sh
Added Files:
ltp/testcases/kernel/containers/sysvipc/shmem_2nstest.c

83) Log Message:
v4l-test 0.4 for LTP: Test cases for MAX_EM28XX_INPUT, MAX_EM28XX_TVNORMS removed as they might have confusing results if the tests are not executed agains em28xx driver. Some typos fixed. Signed-Off-By: Németh Márton <nm127@freemail.hu>.

Modified File(s):
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_STD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c

84) Log Message:
This patch fixes compilation warnings introduced recently. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/lib/libtestsuite.c
ltp/lib/system_specific_process_info.c
ltp/testcases/kernel/sched/hyperthreading/ht_interrupt/HTutils.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl11.c
ltp/testcases/kernel/syscalls/paccept/paccept01.c
ltp/testcases/kernel/syscalls/paccept/paccept02.c
ltp/testcases/kernel/syscalls/socket/socket02.c
ltp/testcases/kernel/syscalls/socket/socket03.c
ltp/testcases/kernel/syscalls/socketpair/socketpair02.c

85) Log Message:
Paccept() has not been accepted upstream, and accept4() has already been tested in LTP, which does the pretty much same thing as the test here, http://lkml.org/lkml/2008/10/26/123. Hence, remove this test. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/runtest/syscalls
Removed Files:
ltp/testcases/kernel/syscalls/paccept/Makefile
ltp/testcases/kernel/syscalls/paccept/paccept01.c
ltp/testcases/kernel/syscalls/paccept/paccept02.c

86) Log Message:
Make ltp compilable without libaio: This is a patch inspired by numerous whining recently seen on ltp-list concerning compile failures when libaio is not present. This includes changes:
- add stubs to the aio tests,
- remove -laio from doio and pipeio makefile, as it was superfluous,
Changed the signatures of main() function (requested by Garrett Cooper). Signed-Off-By: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/testcases/kernel/fs/doio/Makefile
ltp/testcases/kernel/io/aio/aio01/Makefile
ltp/testcases/kernel/io/aio/aio01/aio01.c
ltp/testcases/kernel/io/aio/aio02/Makefile
ltp/testcases/kernel/io/aio/aio02/main.c
ltp/testcases/kernel/ipc/pipeio/Makefile

87) Log Message:


Modified File(s):


--=-/unkifp5sDyc/jJR8swp--

