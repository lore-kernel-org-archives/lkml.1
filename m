Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZFAO34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZFAO34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFAO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:29:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37614 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZFAO3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:29:48 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for MAY 2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Manas Kumar Nayak <maknayak@in.ibm.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Stephen Smalley <sds@tycho.nsa.gov>, Gui Xiaohua <guixh@cn.fujitsu.com>,
       Kiran Prakash <kirpraka@in.ibm.com>, CAI Qian <caiqian@cclom.cn>,
       Miao Xie <miaox@cn.fujitsu.com>, Rohit Verma <rohit.170309@gmail.com>,
       Jiri Palecek <jpalecek@web.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Cyril Hrubis <chrubis@suse.cz>, Mike Frysinger <vapier@gentoo.org>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Suzuki Poulose <suzuki@in.ibm.com>,
       naresh kamboju <naresh.kernel@gmail.com>
Content-Type: multipart/mixed; boundary="=-t7xOsL33NWoX+D6DrkAq"
Organization: IBM
Date: Mon, 01 Jun 2009 19:59:09 +0530
Message-Id: <1243866549.4840.26.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t7xOsL33NWoX+D6DrkAq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
MAY 2009. Please see ltp/INSTALL file carefully, as, there has been
multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
MAY 2009 Highlights:
========================
* Addition/Porting of 33 tests for 28 new system calls from Crackerjack,
* Addition of New Category of CPUSETS tests,
* Addition of Memory Control Group Regression tests,
* Major overhaul of SELINUX Security tests,
* Fixes for numerous other tests,
------------------------------

==============================
MAY 2009 LTP Contributors:
==============================
* Manas Kumar Nayak,
* Márton Németh,
* Stephen Smalley,
* Gui Xiaohua,
* Kiran Prakash,
* CAI Qian,
* Miao Xie,
* Rohit Verma,
* Jiri Palecek,
* Li Zefan,
* Cyril Hrubis,
* Mike Frysinger,
* Wei Yongjun,
* Suzuki Poulose,
* Naresh Kamboju,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
Two things were in the limelight this time. Stephen´s patches fixing all the anomalies in the SELINUX test suit. And the other being Manas´s effort to port huge no. of tests from Crackerjack to LTP. I am hoping that he is going to complete that soon.

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

--=-t7xOsL33NWoX+D6DrkAq
Content-Disposition: attachment; filename=May-2009_Changelog.txt
Content-Type: text/plain; name=May-2009_Changelog.txt; charset=utf-8
Content-Transfer-Encoding: 8bit

1) Log Message:
v4l-test 0.13 for LTP: Changes:
1) Added string content validation;
2) Test cases added for VIDIOC_REQBUFS,
Signed-off-by: Márton Németh <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_AUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDIO.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMAUDOUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMINPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMOUTPUT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUMSTD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_ENUM_FMT.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_MODULATOR.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCAP.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYCTRL.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYMENU.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_STD.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_TUNER.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_validator.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_validator.h
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_REQBUFS.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_REQBUFS.h

2) Log Message:
v4l-test 0.14 for LTP: Changes:
1) Test cases added for VIDIOC_QUERYBUF,
2) Debug functions separated,
Signed-off-by: Márton Németh <nm127@freemail.hu>.

Modified Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/Makefile
ltp/testcases/kernel/device-drivers/v4l/user_space/README
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_REQBUFS.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_test.c
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/index.html
ltp/testcases/kernel/device-drivers/v4l/user_space/doc/results.html
Added Files:
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYBUF.c
ltp/testcases/kernel/device-drivers/v4l/user_space/test_VIDIOC_QUERYBUF.h
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_show.c
ltp/testcases/kernel/device-drivers/v4l/user_space/v4l2_show.h

3) Log Message:
Your patch doesn't apply - looks like it is relative to further local changes you have made in your own git repo (extra args to mktemp).  But applying the corresponding change here does fix that problem for me, yes.  Diff below is relative to ltp cvs. Fix LTPBIN definition in selinux_file.sh. Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/tests/file/selinux_file.sh

4) Log Message:
Fix MLS handling in selinux tests: Some of the selinux tests were using full security contexts but predated MCS/MLS and thus lacked a MLS field. This broke testing if MLS was enabled in the policy but mcstransd was not running. Change some of the tests to avoid the need to use full contexts at all, and others to conditionally append a MLS suffix if MLS is enabled. Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/tests/file/selinux_file.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/mkdir/selinux_mkdir.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/relabel/selinux_relabel.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/rename/selinux_rename.sh
ltp/testcases/kernel/security/selinux-testsuite/tests/rxdir/selinux_rxdir.sh

5) Log Message:
Update ltp selinux test script and policy: Note:  This does not obsolete or replace the other two patches I have posted (Fix LTPBIN definition in selinux_file.sh, Fix MLS handling in selinux tests), but rather should be applied on top of them. Attached is a patch and a tar file to update the ltp selinux test script and policy so that we no longer conditionally patch the test policy when we run the test script.  The patch does the following:
- Disable patching of the policy in the test script.
- Change the refpolicy Makefile to redirect to a rhel/N/ subdirectory if running on a redhat release and move the rhel-specific definitions there. 
- Change the refpolicy Makefile to only include test_bounds.te if the checkpolicy supports policy.24 (and thus typebounds statements).
- Merge the sbin_deprecated.patch into the test policy.
- Further update the test policy to build cleanly on f11, while preserving backward compatibility on f10.
- Added open permissions as necessary to the test policy (enabled in f11).
- Update the ioctl test policy to reflect the updated selinux_file_ioctl() logic in the kernel.
- Added a missing permission to the wait test policy that was causing it to wrongly report PASS.

The tar file contains a new testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5 subdirectory to preserve a legacy copy of the test policy that works on redhat 5.  The top-level refpolicy Makefile will redirect to this subdirectory when it detects redhat 5.  Similar subdirectories can be added for other stable releases going forward as needed.

Subrata, please cvs add the new subdirectory and its files.  Also, please cvs remove the following: ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_policy.te (generated file, should not be in the repository), ltp/testcases/kernel/security/selinux-testsuite/misc/*. Signed-Off-by: Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/Makefile
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_capable_file.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_capable_net.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_capable_sys.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_dyntrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_dyntrans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_entrypoint.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_execshare.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_exectrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_execute_no_trans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_fdreceive.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_file.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_global.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_inherit.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ioctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ipc.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_link.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_mkdir.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_open.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_policy.if
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_ptrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_readlink.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_relabel.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_rename.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_rxdir.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_setattr.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_setnice.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_sigkill.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_stat.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_sysctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_create.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getpgid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getsched.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_getsid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_setpgid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_task_setsched.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_transition.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_wait.te
ltp/testscripts/test_selinux.sh
Added Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/Makefile
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_capable_file.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_capable_net.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_capable_sys.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_dyntrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_dyntrans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_entrypoint.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_execshare.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_exectrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_execute_no_trans.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_fdreceive.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_file.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_global.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_inherit.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_ioctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_ipc.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_link.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_mkdir.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_open.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_policy.if
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_ptrace.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_readlink.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_relabel.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_rename.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_rxdir.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_setattr.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_setnice.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_sigkill.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_stat.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_sysctl.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_create.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_getpgid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_getsched.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_getsid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_setpgid.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_task_setsched.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_transition.te
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/test_wait.te
Removed Files:
ltp/testcases/kernel/security/selinux-testsuite/misc/check_sbin_deprecated.pl
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch
ltp/testcases/kernel/security/selinux-testsuite/misc/update_refpolicy.sh
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/test_policy.te

6) Log Message:
Update the selinux ioctl test in ltp to reflect the revised selinux_file_ioctl() logic in the kernel.  Also requires the corresponding ltp selinux test policy update. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/tests/ioctl/selinux_ioctl.c
ltp/testcases/kernel/security/selinux-testsuite/tests/ioctl/selinux_noioctl.c

7) Log Message:
Fix ltp selinux testsuite for rhel5: Some changes on top of the prior patches to enable the ltp selinux testsuite to run successfully on rhel5.  Changes:  
- Fix the extraction of the release version to exclude Client/Server/etc.
- Make the ioctl test detect kernel version and adjust the test logic to match the expected selinux_file_ioctl() logic.
- Prevent runcon from consuming the options to chcon in selinux_relabel.sh.
Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/Makefile
ltp/testcases/kernel/security/selinux-testsuite/tests/ioctl/selinux_noioctl.c
ltp/testcases/kernel/security/selinux-testsuite/tests/relabel/selinux_relabel.sh

8) Log Message:
Enable the type bounds test in the ltp selinux testsuite: Add the type bounds test case to the runtest/selinux config so that it is executed as part of the ltp selinux testsuite.  The test passes with a sufficiently recent kernel (>= 2.6.28) and checkpolicy, as in Fedora 11.  If we want to avoid test failures on older kernels, we could add an explicit kernel version test to the test program, as I did for the ioctl test case. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/runtest/selinux

9) Log Message:
Update ltp selinux testsuite README: Update the ltp selinux testsuite README. Changes include:  
- Explain the two different locations of test policy up front and then use $POLICYDIR for subsequent references.
- Expand and clarify the kernel configuration options.
- Add a section summarizing the SELinux policy and userland dependencies.
Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/README

10) Log Message:
Fix selinux_capable_file.sh: Fix selinux_capable_file.sh to call setup before running the second set of tests.  This wasn't an issue prior to the $SELINUXTMPDIR patch as cleanup didn't previously remove the temporary directory, just the files.  The bug wasn't evident in enforcing mode since the second set of tests still got error exit values as expected just for the wrong reason. Detected by forcing a run of the testsuite under permissive mode and checking that all of the testcases FAIL as expected. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/tests/capable_file/selinux_capable_file.sh

11) Log Message:
There is a warning occured during i compiled ltp which was released in 20090430: The array of filename was declared with 5 elements, so if you give a value to filename[5], the array will overflow. Signed-off-by: Gui Xiaohua <guixh@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/readlinkat/readlinkat01.c

12) Log Message:
Fix faulty interpretation of PASS/FAIL  bysched_football log parser: The log parser of sched_football sometimes interprets successful runs as FAILed ones as it gets the final result based on the PASS/FAIL value of the first run in the log file. The rationale behind this patch is that sched_football testcase can itself decide if it has passed or failed based on the_ball value. There is no need of the log parser as is the case with the other test cases like pi_perf. Changelog:
- Added pass/fail detection logic to sched_football.c,
- Removed parse_football.py,
- Removed the call to parse_football.py from run_auto.sh.
Signed-off by: Kiran Prakash <kirpraka@in.ibm.com>,
Acked-by: Gowrishankar <gowrishankar.m@linux.vnet.ibm.com>,
Acked-By: Dinakar Guniguntala <dino@in.ibm.com>,
Acked-by: Sripathi Kodi <sripathik@in.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/sched_football/run_auto.sh
ltp/testcases/realtime/func/sched_football/sched_football.c
Removed Files:
ltp/testcases/realtime/func/sched_football/parse-football.py

13) Log Message:
Remove Duplicated Proc01 From Test Lists: The patch removes proc01 test from runtest/crashem, because it has also been present in runtest/fs. There is no need to run it in two places. Signed-off-by: CAI Qian <caiqian@cclom.cn>. 

Modified Files:
ltp/runtest/crashme

14) Log Message:
Add new testcases for cpuset: This is the patch of new testcases for the functionality test of cpuset. It contains cpu hotplug vs cpuset test, load balance vs cpuset test, schedule domains partition test, memory pressure measurement function test, page caches spread test and memory allocation test. Note: page caches spread test(test of cpuset11) may fail because there is something wrong with the kernel. I have made a patch to fix it. Now the patch was adding into -mm tree. Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/controllers/README
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuset/Makefile
ltp/testcases/kernel/controllers/cpuset/README
ltp/testcases/kernel/controllers/cpuset/run_cpuset_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuset_funcs.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_syscall_test/cpuset_syscall_testset.sh
Added Files:
ltp/testcases/kernel/controllers/cpuset/cpuset_hotplug_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_hotplug_test/cpuset_hotplug_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_hotplug_test/cpuset_list_compute.c
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuinfo.c
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/cpuinfo.h
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/meminfo.c
ltp/testcases/kernel/controllers/cpuset/cpuset_lib/meminfo.h
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_cpu_hog.c
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_load_balance_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_sched_domains_check.c
ltp/testcases/kernel/controllers/cpuset/cpuset_load_balance_test/cpuset_sched_domains_test.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_pressure_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_pressure_test/cpuset_memory_pressure.c
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_pressure_test/cpuset_memory_pressure_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_spread_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_spread_test/cpuset_mem_hog.c
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_spread_test/cpuset_memory_spread_testset.sh
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_test/Makefile
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_test/cpuset_memory_test.c
ltp/testcases/kernel/controllers/cpuset/cpuset_memory_test/cpuset_memory_testset.sh

15) Log Message:
The accept4() system call is available starting with Linux 2.6.28; support in glibc is available starting with version 2.10. In v2.9, the function was to be declared. So i did some changes like following. Signed-off-by: Gui Xiaohua <guixh@cn.fujitsu.com>. Acked-By: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/kernel/syscalls/accept4/accept4_01.c

16) Log Message:
Update the ltp selinux testsuite README to note the requirement for the libselinux headers and static library, and provide URLs from which to obtain the SELinux core userland and reference policy if the base distribution does not already include them. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/README

17) Log Message:
Remove obsolete logic from the Makefile in selinux-testsuite/refpolicy/redhat/5. This Makefile only gets used if we are running the testsuite on RHEL5, so we can drop the conditional TARGET definitions based on the redhat-release value. Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>.

Modified Files:
ltp/testcases/kernel/security/selinux-testsuite/refpolicy/redhat/5/Makefile

18) Log Message:
Rohit Verma <rohit.170309@gmail.com> reported: I think there is a bug in the source code. In both the cases the string variable "Type" is not null- terminated. This variable ("Type") indicates the filesystem type, which is used later in the code. In the above said lines of code, I can observe that 'strlen(fstype)' is used within strncpy. Now, strlen returns the length of string excluding the null character. Man page of strncpy states that the 'dest' string is null terminated only if it is present in first 'n'  bytes of the 'src'. In our case, since strlen returns lenght excluding the null character the string "Type" is not null terminated.
CAI Qian <caiqian@cclom.cn> replied: Yes, that is the case. Guo Hongruan posted patches for mount02 and mount03 to fix the same problem before, and we'll also need the similar fix here. Are you capable to make patches for it? Signed-Off-By:  Rohit Verma <rohit.170309@gmail.com>, Acked-by: CAI Qian <caiqian@cclom.cn>,

Modified File(s):
ltp/testcases/kernel/syscalls/umount/umount02.c
ltp/testcases/kernel/syscalls/umount/umount03.c

19) Log Message:
Fix the splice02 test:
Particularly:
- TEST_ERRNO is only set when the syscall is executed using the TEST() macro. The tests gave bad error messages because of that.
- The end of the test was dead code; moved the TPASS code to pass at the end of file.
- The test assumes std. input is a pipe; reflect this in the runtest file.
Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified File(s):
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/splice/splice02.c

20) Log Message:
Patch for fixing Unzip01 Test Not Working Correctly. Signed-Off-By: rohit verma <rohit.170309@gmail.com>. Acked-by: CAI Qian <caiqian@cclom.cn>.

Modified File(s):
ltp/testcases/commands/unzip/unzip_tests.sh

21) Log Message:
Add Memory Cgroup regression tests to LTP: Those testcases can reproduce bugs we found in memcg, and is useful to track future regressions. Note: this test may crash the system with older kernels, so it is disabled for kernels older than 2.6.30. Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified Files:
ltp/runtest/controllers
ltp/testcases/kernel/controllers/Makefile
Added Files:
ltp/testcases/kernel/controllers/memcg/Makefile
ltp/testcases/kernel/controllers/memcg/README
ltp/testcases/kernel/controllers/memcg/memcg_regression_test.sh
ltp/testcases/kernel/controllers/memcg/memcg_test_1.c
ltp/testcases/kernel/controllers/memcg/memcg_test_2.c
ltp/testcases/kernel/controllers/memcg/memcg_test_4.c
ltp/testcases/kernel/controllers/memcg/memcg_test_4.sh

22) Log Message:
Attached (against ltp-full-20090430.tgz) patch renames binaries in pan directory to have ltp- prefix as plain pan when installed in /usr/bin/ directory conflict with gnome pan. It also fixes all occurrences of pan in scripts and howtos. Signed-off-by: Cyril Hrubis <chrubis@suse.cz>.

Modified Files:
ltp/ltp-devel.spec
ltp/runltp
ltp/runltplite.sh
ltp/doc/automation-README.html
ltp/doc/automation-cookbook.html
ltp/doc/ltp-howto.lyx
ltp/doc/ltp-howto.txt
ltp/doc/man1/Makefile
ltp/pan/Makefile
ltp/testscripts/diskio.sh
ltp/testscripts/ltp-aiodio.sh
ltp/testscripts/ltp-scsi_debug.sh
ltp/testscripts/ltpfslvm.sh
ltp/testscripts/ltpfsnolvm.sh
ltp/testscripts/ltpstress.sh
ltp/testscripts/networkstress.sh
ltp/testscripts/networktests.sh
ltp/testscripts/runEALtests.sh
ltp/testscripts/runpan.sh
ltp/testscripts/test_containers.sh
ltp/testscripts/test_filecaps.sh
ltp/testscripts/test_selinux.sh
ltp/testscripts/tpm_tools.sh
Added Files:
ltp/doc/man1/ltp-bump.1
ltp/doc/man1/ltp-pan.1
ltp/pan/ltp-bump.c
ltp/pan/ltp-pan.c
ltp/pan/ltp-scanner.c
Removed Files:
ltp/doc/man1/bump.1
ltp/doc/man1/pan.1
ltp/pan/bump.c
ltp/pan/pan.c
ltp/pan/scanner.c

23) Log Message:
Fix missing return. Signed-off-by: Cyril Hrubis <chrubis@suse.cz>.

Modified File(s):
ltp/testcases/kernel/security/integrity/ima/src/ima_mmap.c

24) Log Message:
Add add_key01 test for add_key syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>,

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/add_key/Makefile
ltp/testcases/kernel/syscalls/add_key/add_key01.c

25) Log Message:
Add add_key02 test for add_key syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/add_key/add_key02.c

26) Log Message:
Add bdflush01 test for bdflush syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/bdflush/Makefile
ltp/testcases/kernel/syscalls/bdflush/bdflush01.c

27) Log Message:
Add exit_group01 test for exit_group syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/exit_group/Makefile
ltp/testcases/kernel/syscalls/exit_group/exit_group01.c

28) Log Message:
Add keyctl01 test for keyctl syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/keyctl/Makefile
ltp/testcases/kernel/syscalls/keyctl/keyctl01.c

29) Log Message:
Add newuname01 test for newuname syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/newuname/Makefile
ltp/testcases/kernel/syscalls/newuname/newuname01.c

30) Log Message:
Add rt_sigaction01 test for rt_sigaction syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/rt_sigaction/Makefile
ltp/testcases/kernel/syscalls/rt_sigaction/rt_sigaction01.c

31) Log Message:
Add rt_sigprocmask01 test for rt_sigprocmask syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/rt_sigprocmask/Makefile
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask01.c

32) Log Message:
Add rt_sigprocmask02 test for rt_sigprocmask syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/rt_sigprocmask/rt_sigprocmask02.c

33) Log Message:
Add rt_sigqueueinfo01 test for rt_sigqueueinfo syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/rt_sigqueueinfo/Makefile
ltp/testcases/kernel/syscalls/rt_sigqueueinfo/rt_sigqueueinfo01.c

34) Log Message:
Add rt_sigsuspend01 test for rt_sigsuspend syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/rt_sigsuspend/Makefile
ltp/testcases/kernel/syscalls/rt_sigsuspend/rt_sigsuspend01.c

35) Log Message:
Add set_thread_area01 test for set_thread_area syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/set_thread_area/Makefile
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area01.c

36) Log Message:
Add set_thread_area02 test for set_thread_area syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/set_thread_area/set_thread_area02.c

37) Log Message:
Add set_tid_address01 test for set_tid_address syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/set_tid_address/Makefile
ltp/testcases/kernel/syscalls/set_tid_address/set_tid_address01.c

38) Log Message:
Add sgetmask01 test for sgetmask syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/sgetmask/Makefile
ltp/testcases/kernel/syscalls/sgetmask/sgetmask01.c

39) Log Message:
Add sigreturn01 test for sigreturn syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/sigreturn/Makefile
ltp/testcases/kernel/syscalls/sigreturn/sigreturn01.c

40) Log Message:
Add ssetmask01 test for ssetmask syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/ssetmask/Makefile
ltp/testcases/kernel/syscalls/ssetmask/ssetmask01.c

41) Log Message:
Add timer_getoverrun01 test for timer_getoverrun01 syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/timer_getoverrun/Makefile
ltp/testcases/kernel/syscalls/timer_getoverrun/timer_getoverrun01.c

42) Log Message:
Add timer_gettime01 test for timer_gettime syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/timer_gettime/Makefile
ltp/testcases/kernel/syscalls/timer_gettime/timer_gettime01.c

43) Log Message:
Add tkill01 test for tkill syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/tkill/Makefile
ltp/testcases/kernel/syscalls/tkill/tkill01.c

44) Log Message:
Add tkill02 test for tkill syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/tkill/tkill02.c

45) Log Message:
Patch for "File" test case issue of 30-April-2009 release. Signed-off-by: rohit verma <rohit.170309@gmail.com>.

Modified File(s):
ltp/testcases/commands/ade/file/file_test.sh

46) Log Message:
I've found that ltp didn't compile on Debian because of old kernel headers, which contain taskstats struct without some of the needed fields. This autoconf test detects it and disables the code that would otherwise break. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

Modified Files:
ltp/configure.ac
ltp/include/config.h.default
ltp/testcases/kernel/controllers/cgroup/getdelays.c
Added Files:
ltp/m4/ltp-taskstats.m4

47) Log Message:
Crash02: Deal with SIGSTOP and SIGSEGV v3: Version 3 also fixed compilation failures on IA-64, since there is no SYS_fork either. It use clone2() instead. Version 2 fixed compilation failures on IA-64, because there is no SYS_vfork there. Instead, it uses clone() syscall for vfork(): clone(child_stack=0, flags=CLONE_VM|CLONE_VFORK|SIGCHLD). We have seen crash02 test can not finish due to the child process got SIGSTOP or SIGSEGV when calling random syscalls like this,
# ps aux
...
168      20121  0.0  0.0   3956   336 ?        Ds   15:10   0:00 ./crash02 -e
-v 100
168      20122  0.0  0.0   3956   336 ?        T    15:10   0:00 ./crash02 -e
-v 100
crash02       X ffff81007fb127a0     0 21272  21271         21273 (L-TLB)
 ffff81004c185d58 0000000000000046 ffff81007b494e08 0000000000000002
 0000000000000002 0000000000000002 ffff81007c5dc860 ffff81007fb127a0
 00000d8ebb800862 000000000000c315 ffff81007c5dca48 0000000300000001
Call Trace:
 [<ffffffff800235a7>] filp_close+0x5c/0x64
 [<ffffffff8001595a>] do_exit+0x913/0x91f
 [<ffffffff80048c18>] cpuset_exit+0x0/0x6c
 [<ffffffff8002ad05>] get_signal_to_deliver+0x42c/0x45a
 [<ffffffff8005a837>] do_notify_resume+0x9c/0x7af
 [<ffffffff80096e2b>] specific_send_sig_info+0x44/0xac
 [<ffffffff8009710e>] force_sig_info+0xae/0xb9
 [<ffffffff80066eed>] do_page_fault+0x81e/0x830
 [<ffffffff8005d6dc>] retint_signal+0x3d/0x79
crash02       X ffff810002376400     0 21273  21271               21272 (L-TLB)
 ffff81004d201f18 0000000000000046 ffff81007b494e08 0000000000000046
 0000000000000046 0000000000000002 ffff810078d3a040 ffffffff802eeae0
 00000d8ebb803430 000000000001a60c ffff810078d3a228 0000000000000000
Call Trace:
 [<ffffffff8001595a>] do_exit+0x913/0x91f
 [<ffffffff80048c18>] cpuset_exit+0x0/0x6c
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0
So we use WUNTRACED option. Also, we found out that if it picks up vfork(), it will generate SIGSEGV. I am not sure what else can generate the same, so only blacklist vfork() at the moment. Signed-off-by: CAI Qian <caiqian@cclom.cn>.

Modified Files:
ltp/testcases/misc/crash/crash02.c

48) Log Message:
Fix sync problem between two processes of pidns12 test: The child-process wait SIGUSR1 which would be sended by parent-process, if the child-process execute sigtimedwait() after parent-process send the signal, it would never receive the SIGUSR1 from parent-process. This patch rewrite child_signal_handler() to handle to SIGUSR1 and instead sigtimedwait() with sleep for 3 seconds. Signed-off-by: Gui Xiaohua <guixh@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/containers/pidns/pidns12.c

49) Log Message:
In reference to the issue with timer_create04 and clock_gettime03 for the kernel version 2.6.29 which was reported in the link: http://www.nabble.com/timer_create-p22376043.html, PFA the patch for fixing the issue. Detail on the issue: A new clockid 'CLOCK_MONOTONIC_RAW' was added since the kernel 2.6.28 (http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.28). This addition caused the above testcases to fail. Now, 5 clock ID's are resent in kernel ver 2.6.28 and later. Signed-off-by: Rohit Verma <rohit.170309@gmail.com>.

Modified Files:
ltp/testcases/kernel/timers/include/common_timers.h
ltp/testcases/kernel/timers/timer_create/timer_create02.c

50) Log Message:
Postponing close() after aio_write() has finished: In aio_return/1-1.c close() is called after asynchronous I/O write was queued. This according to POSIX may end up in one of two ends and it's implementation specified. One end is writing the file correctly while the other one is behave like aio_cancel() was called. (http://www.opengroup.org/onlinepubs/9699919799/functions/close.html). Test mentoined above rely on finishing asynchronous I/O correctly in this case. To fix that you must postpone close() after asynchronous I/O has finished. Signed-of-by: chrubis@suse.cz.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/1-1.c

51) Log Message:
revert previous "style" change which did a lot more damage than good

Modified File(s):
ltp/testcases/kernel/syscalls/ptrace/ptrace04.c
ltp/testcases/kernel/syscalls/ptrace/ptrace06.c

52) Log Message:
execve: remove obsoleted test case execve04. Since latest kernel do execve(2) without get file descriptor(kernel commit e7b9b550f53e81ea38e71d322d6f95730df058a2), it only use one file struct. This cause the case execve04 which test for set EMFILE errno obsoleted. This patch removed test case execve04, and changed the index of the test cases after execve04. Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>.

Modified Files:
ltp/doc/testcases/kernel.txt
ltp/runtest/ltplite
ltp/runtest/stress.part3
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/execve/execve04.c
ltp/testcases/kernel/syscalls/execve/execve05.c
Removed Files:
ltp/testcases/kernel/syscalls/execve/execve06.c

53) Log Message:
Fix typo in testcases/kernel/syscalls/chown/chown03.c, which use ltpuser->pw_uid in call to setegid() should be ltpuser->pw_gid. Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/chown/chown03.c

54) Log Message:
postponing close() after aio_write() has finished II and cleanups: I've fixed all the sources in the aio_return directory (from the same errors as previous one) and cleaned the coding style a little. Signed-off-by: Cyril Hrubis chrubis@suse.cz.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/2-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/3-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/3-2.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/aio_return/4-1.c

55) Log Message:
Renaming binaries to avoid conflicts II. I've missed these three in the first patch, here comes cosmetic changes. Signed-off-by: Cyril Hrubis chrubis@suse.cz.

Modified Files:
ltp/INSTALL ltp/README ltp/README.ltp-devel

56) Log Message:
Port Crackerjack Syscall tests(missing) to LTP. Add/Port Utility Headers for these set of tests. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>. 

Added Files:
ltp/testcases/kernel/syscalls/utils/common_j_h.c
ltp/testcases/kernel/syscalls/utils/include_j_h.h
ltp/testcases/kernel/syscalls/utils/inotify.h
ltp/testcases/kernel/syscalls/utils/ioprio.h
ltp/testcases/kernel/syscalls/utils/numaif.h
ltp/testcases/kernel/syscalls/utils/poll.h

57) Log Message:
Add/Port get_mempolicy01 test for get_mempolicy() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/get_mempolicy/Makefile
ltp/testcases/kernel/syscalls/get_mempolicy/get_mempolicy01.c

58) Log Message:
Add/Port clock_getres01 test for clock_getres() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/clock_getres/Makefile
ltp/testcases/kernel/syscalls/clock_getres/clock_getres01.c

59) Log Message:
Add/Port clock_nanosleep01 test for clock_nanosleep() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/clock_nanosleep/Makefile
ltp/testcases/kernel/syscalls/clock_nanosleep/clock_nanosleep01.c

60) Log Message:
Add/Port mq_notify01 test for mq_notify() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mq_notify/Makefile
ltp/testcases/kernel/syscalls/mq_notify/mq_notify01.c

61) Log Message:
Add/Port ppoll01 test for ppoll() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/ppoll/Makefile
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

62) Log Message:
Add/Port mq_open01 test for mq_open() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mq_open/Makefile
ltp/testcases/kernel/syscalls/mq_open/mq_open01.c

63) Log Message:
Add/Port mq_timedreceive01 test for mq_timedreceive() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mq_timedreceive/Makefile
ltp/testcases/kernel/syscalls/mq_timedreceive/mq_timedreceive01.c

64) Log Message:
Add/Port utimes01 test for utimes() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/utimes/Makefile
ltp/testcases/kernel/syscalls/utimes/utimes01.c

65) Log Message:
Add/Port mq_unlink01 test for mq_unlink() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mq_unlink/Makefile
ltp/testcases/kernel/syscalls/mq_unlink/mq_unlink01.c

66) Log Message:
Add/Port mq_timedsend01 test for mq_timedsend() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/mq_timedsend/Makefile
ltp/testcases/kernel/syscalls/mq_timedsend/mq_timedsend01.c

67) Log Message:
Add/Port unshare01 test for unshare() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/unshare/Makefile
ltp/testcases/kernel/syscalls/unshare/unshare01.c

68) Log Message:
Add/Port unshare02 test for unshare() syscall. Signed-off-by: Manas Kumar Nayak <maknayak@in.ibm.com>.

Modified Files:
ltp/runtest/syscalls
Added Files:
ltp/testcases/kernel/syscalls/unshare/unshare02.c

69) Log Message:
The following patch solves the problem: 
1) Avoids build problem on your very old kernel,
2) Will not run on on your old kernel but on kernel > 2.6.17,
Will revert to Autoconf later. Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/splice/splice02.c

70) Log Message:
Being a non-NUMA machine is not a failure, but an info. So it should not cause the test to have a non zero exit status. Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>.

Modified Files:
ltp/testcases/kernel/syscalls/getcpu/getcpu01.c

71) Log Message:
I come across with this kernel issue in 2.6.27:
http://lkml.org/lkml/2008/9/23/218,
http://lkml.org/lkml/2008/9/23/228,
http://lkml.org/lkml/2008/9/24/180,
http://lkml.org/lkml/2008/9/24/186,
http://lkml.org/lkml/2008/9/24/193,
http://lkml.org/lkml/2008/9/24/243,
http://lkml.org/lkml/2008/9/24/247,
Test cases modification noticed for ltp/testcases/open_posix_testsuite/conformance/interfaces/sigaction/10-1.c. I have modified patch and submitting fix patch. This test case is passed now. Signed-off-by: naresh kamboju <naresh.kernel@gmail.com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/sigaction/10-1.c


--=-t7xOsL33NWoX+D6DrkAq--

