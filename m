Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYGaOpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYGaOpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYGaOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:45:30 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50685 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYGaOp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:45:28 -0400
Subject: [LTP][ANNOUNCE] The Linux Test Project has been Released for JULY
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Junjiro Okajima <hooanon05@yahoo.co.jp>, Craig Meier <crmeier@ghs.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Masatake YAMATO <yamato@redhat.com>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>,
       Matt Fleming <mjf@gentoo.org>, Serge Hallyn <serue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>,
       Shi Weihua <shiwh@cn.fujitsu.com>,
       Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
       Gilles Carry <Gilles.Carry@bull.net>,
       "Vijay Kumar B." <vijaykumar@bravegnu.org>,
       Veerendra Chandrappa <vechandr@in.ibm.com>,
       crackerjack-devel <crackerjack-devel@lists.sourceforge.net>,
       crackerjack-users <crackerjack-users@lists.sourceforge.net>
Content-Type: multipart/mixed; boundary="=-6JWFAzNkpgjXPoh3gfjy"
Organization: IBM
Date: Thu, 31 Jul 2008 20:14:50 +0530
Message-Id: <1217515491.5363.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6JWFAzNkpgjXPoh3gfjy
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
JULY 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


JULY 2008 Highlights:
* Addition of io_destroy(), io_getevents(), io_setup() & io_submit()
tests,
* Addition of IO-throttle Controllers test, paving the way for launching
of ltp-mm tree,
* GCOV Patches for Kernel 2.6.26,
* Update to OpenHPI 2.12.0,
* Addition of move_pages() tests,
* SELinux tests fix,
* Memory tests fix,
* Filecaps tests fix,
* LTP-AIO fix,
* Hackbench compilation fix,
* Realtime tests fix, etc,


JULY 2008 LTP Contributors:
* Junjiro Okajima,
* Craig Meier,
* Stephen Smalley,
* Masatake YAMATO,
* Peter Oberparleiter,
* Ramon de Carvalho Valle,
* Matt Fleming,
* Serge Hallyn,
* Andrea Righi,
* Shi Weihua,
* Edjunior Barbosa Machado,
* Gilles Carry,
* Vijay Kumar B,
* Veerendra Chandrappa,


Note(s) from the Maintainer:

I participated in OLS 2008. I was exited to meet lot of people from the
community and know their personal opinion about LTP. I patiently heard
improvements to be done in LTP and the course of actions we need to
take. I will shortly start those discussions on the mailing lists. I was
happy to hear that people were happy that the project is active and
kicking. The immediate challenge before us is to increase that pace and
make it more effective, which i hope we will be able to achieve over a
period of time.


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

Please also see the Change Log Attached (JULY 2008) for detailed
changes.

Happy testing, 
Regards-- 
Subrata,

--=-6JWFAzNkpgjXPoh3gfjy
Content-Disposition: attachment; filename=July-2008_Changelog.txt
Content-Type: text/plain; name=July-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

1) Log Message:
I've tried LTP and found some wrong mode at creating file/dir in LTP source files. Here is a patch. Junjiro Okajima<hooanon05@yahoo.co.jp>.

Modified File(s):
ltp/lib/write_log.c
ltp/testcases/kernel/fs/dmapi/attr.c
ltp/testcases/kernel/fs/dmapi/config.c
ltp/testcases/kernel/fs/dmapi/disp.c
ltp/testcases/kernel/fs/dmapi/event_am.c
ltp/testcases/kernel/fs/dmapi/event_an.c
ltp/testcases/kernel/fs/dmapi/event_sd.c
ltp/testcases/kernel/fs/dmapi/event_sn.c
ltp/testcases/kernel/fs/dmapi/handle.c
ltp/testcases/kernel/fs/dmapi/hole.c
ltp/testcases/kernel/fs/dmapi/invis.c
ltp/testcases/kernel/fs/dmapi/mmap.c
ltp/testcases/kernel/fs/dmapi/mmapfile.c
ltp/testcases/kernel/fs/dmapi/mount.c
ltp/testcases/kernel/fs/dmapi/objref.c
ltp/testcases/kernel/fs/dmapi/pmr_post.c
ltp/testcases/kernel/fs/dmapi/pmr_pre.c
ltp/testcases/kernel/fs/dmapi/right.c
ltp/testcases/kernel/fs/dmapi/token.c
ltp/testcases/kernel/fs/fsstress/fsstress.c
ltp/testcases/kernel/fs/scsi/ltpfs/main.c
ltp/testcases/kernel/fs/scsi/ltpscsi/scsimain.c
ltp/testcases/kernel/io/aio/aio02/cases/aio_tio.c
ltp/testcases/kernel/ipc/ipc_stress/shmem_test_03.c
ltp/testcases/kernel/syscalls/open/open08.c

2) Log Message:
Every once in a while, pselect01 fails with the following output:
FAIL  :  Sleep time was incorrect:5 != 6
This is because we expect our sleeps of slightly more than 5 seconds to last at most 5 seconds (if we're uninterrupted, integer truncation will mean this only comes up about 1% of the time).  To fix this, we should instead expect our sleeps to last between 5 and 6 seconds, as in the patch inlined below. Signed-off-by: Craig Meier <crmeier@ghs.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/pselect/pselect01.c

3) Log Message:
Fix a bug in the selinux testsuite makefile, pointed out by David Howells. Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/tests/Makefile

4) Log Message:
TEST_RETURN should not be inverted when logging. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/io_cancel/io_cancel01.c

5) Log Message:
gcov-kernel: refreshed 2.6.16 patch, adding CONFIG_MODVER compatbility

Modified File(s):
ltp/utils/analysis/gcov-kernel/linux-2.6.16-gcov.patch

6) Log Message:
Fixes the following issues:
The LTP selinux-testsuite does not work out of the box on Red Hat Enterprise Linux 4. The testscripts/test_selinux.sh script does not detect if refpolicy should be used or not. The LTP selinux-testsuite test policy uses the can_setcon macro which is not defined in global macros of Red Hat Enterprise Linux 4 selinux policy targeted sources. Some Makefile needs minor fixes and enhancements. Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/policy/Makefile
ltp/testcases/kernel/security/selinux-testsuite/policy/test_global.te
ltp/testcases/kernel/security/selinux-testsuite/tests/Makefile
ltp/testscripts/test_selinux.sh

7) Log Message:
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation. Allow the amount of memory to be used to be passed as a command-line argument. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/mem/mem/mem02.c

8) Log Message:
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation. It can be unsafe to call exit(3) from a signal handler. Call _exit(2) instead. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/mem/mtest06/mmap1.c

9) Log Message:
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation. Allow the number of pages to use for the test to be specified on the command-line. Fix a memory leak. Also, call _exit(2) from child processes which avoids the child calling the atexit functions that the pthread library setup. This fixes an issue where the pthread manager thread would begin exiting at the same time as a child thread. The child thread would run the atexit functions which cause it to wait for a signal to be sent from the thread manager. As the thread manager was trying to exit that signal would never be sent. Calling _exit(2) from the child avoids this whole mess. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/mem/mtest05/mmstress.c

10) Log Messsage:

Modified File(s):
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation.Don't place an upper limit on the amount of time a nanosleep(2) call should take. The nanosleep(2) call will suspend execution for _at least_ the specified time, no upper limit is guaranteed. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/syscalls/nanosleep/nanosleep01.c

11) Log Message:
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation.Allow the number of iterations to be specified on the command line. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/sched/nptl/nptl01.c

12) Log Message:
I've attached some patches that I created for LTP at work. Most of them simply add command-line options to specify the amount of memory/pages to use for tests. However, there's one fix that works around a bug in uClibc's pthread implementation. Check for SYS_getuid32 and SYS_getgid32, these are the versions provided by some architectures. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/syscalls/syscall/syscall01.c

13) Log Message:
There were some mistakes in my previous patch.
- wrong mode 0644 for mkdir().
- unnecessary to add 0644 for open() since the flag doesn't include O_CREAT (while it does no harm).
By this new patch, they are fixed. Junjiro Okajima <hooanon05@yahoo.co.jp>.

Modified File(s):
ltp/lib/write_log.c
ltp/testcases/ballista/ballista/templates/b_mq_attr.tpl
ltp/testcases/ballista/ballista/templates/b_mqd.tpl
ltp/testcases/ballista/ballista/templates/b_mqdSUN.tpl
ltp/testcases/ballista/ballista/templates/b_ptr_sem_t.tpl
ltp/testcases/kernel/fs/dmapi/attr.c
ltp/testcases/kernel/fs/dmapi/config.c
ltp/testcases/kernel/fs/dmapi/disp.c
ltp/testcases/kernel/fs/dmapi/dm_test.h
ltp/testcases/kernel/fs/dmapi/event_am.c
ltp/testcases/kernel/fs/dmapi/event_an.c
ltp/testcases/kernel/fs/dmapi/event_sd.c
ltp/testcases/kernel/fs/dmapi/event_sn.c
ltp/testcases/kernel/fs/dmapi/handle.c
ltp/testcases/kernel/fs/dmapi/hole.c
ltp/testcases/kernel/fs/dmapi/invis.c
ltp/testcases/kernel/fs/dmapi/mmap.c
ltp/testcases/kernel/fs/dmapi/mmapfile.c
ltp/testcases/kernel/fs/dmapi/mount.c
ltp/testcases/kernel/fs/dmapi/objref.c
ltp/testcases/kernel/fs/dmapi/pmr_post.c
ltp/testcases/kernel/fs/dmapi/pmr_pre.c
ltp/testcases/kernel/fs/dmapi/right.c
ltp/testcases/kernel/fs/dmapi/token.c
ltp/testcases/kernel/fs/fsstress/fsstress.c
ltp/testcases/kernel/fs/scsi/ltpfs/main.c
ltp/testcases/kernel/fs/scsi/ltpscsi/scsimain.c
ltp/testcases/kernel/io/aio/aio02/cases/aio_tio.c
ltp/testcases/kernel/syscalls/open/open08.c
ltp/testcases/open_hpi_testsuite/utils/uid_utils.c

14)Log Message:
This patch uses strcpy() instead of strcat(). strcat() should only be used when the 'dest' argument is NULL terminated. In this case, path_buffer is not initialised and so may not contain a NULL character. strcpy() will do the right thing and copy the string to the beginning of path_buffer. Matt Fleming <mjf@gentoo.org>.

Modified File(s):
ltp/testcases/kernel/syscalls/readlink/readlink04.c

15) Log Message:
It eliminates the potential for many false negatives.
1.  Use cap_compare to compare capability sets instead of comparing the far less reliable text representations.
2.  pI' tests were failing bc I started with empty pI. Fill pI before those tests.
3.  Check for libcap-2.11 or later (by checking for cap_compare()).
Signed-off-by: Serge Hallyn <serue@us.ibm.com>

Modified File(s):
ltp/testcases/kernel/security/filecaps/Makefile
ltp/testcases/kernel/security/filecaps/check_simple_capset.c
ltp/testcases/kernel/security/filecaps/filecapstest.sh
ltp/testcases/kernel/security/filecaps/verify_caps_exec.c

16) Log Messsage:
Porting of io_destroy(), io_getevents(), io_setup() & io_submit() syscall tests from Crackerjack to LTP, by Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/runtest/syscalls

Added Files:
ltp/testcases/kernel/syscalls/io_destroy/Makefile
ltp/testcases/kernel/syscalls/io_destroy/io_destroy01.c
ltp/testcases/kernel/syscalls/io_destroy/run-io_destroy.sh
ltp/testcases/kernel/syscalls/io_getevents/Makefile
ltp/testcases/kernel/syscalls/io_getevents/io_getevents01.c
ltp/testcases/kernel/syscalls/io_getevents/run-io_getevents.sh
ltp/testcases/kernel/syscalls/io_setup/Makefile
ltp/testcases/kernel/syscalls/io_setup/io_setup01.c
ltp/testcases/kernel/syscalls/io_setup/run-io_setup.sh
ltp/testcases/kernel/syscalls/io_submit/Makefile
ltp/testcases/kernel/syscalls/io_submit/io_submit01.c
ltp/testcases/kernel/syscalls/io_submit/run-io_submit.sh

17) Log Message:
According to the manpages io_submit() can return the value: EAGAIN Insufficient resources are available to queue any iocbs. We should handle this opportunely trying to re-submit the AIO request again. Maybe an even better approach could be to just sleep a bit before trying to re-submit the request. In any case this would resolve a never-ending loop in aio01.c, where io_getevents() can be continuously called without having issued any actual request if io_submit() failed with -EAGAIN. Signed-off-by: Andrea Righi <righi.andrea@gmail.com>.

Modified File(s):
ltp/testcases/kernel/io/aio/aio01/aio01.c
ltp/testcases/kernel/io/aio/aio02/cases/aio_tio.c

18) Log Message:
Error occured, when i tried to compile ltp on ia64 box. There is a patch to fix it. similar patch on i386/x86_64 has been applied. (http://marc.info/?l=ltp-list&m=121257587007213&w=2). Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/linux_syscall_numbers.h

19) Log Message:
Add the block device I/O bandwidth controller (io-throttle) testcase. See testcase documentation for design and implementation details. See also: http://lkml.org/lkml/2008/7/4/143. Signed-off-by: Andrea Righi <righi.andrea@gmail.com>.

Modified Files:
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/test_controllers.sh

Added Files:
ltp/testcases/kernel/controllers/io-throttle/Makefile
ltp/testcases/kernel/controllers/io-throttle/README
ltp/testcases/kernel/controllers/io-throttle/io_throttle_testplan.txt
ltp/testcases/kernel/controllers/io-throttle/iobw.c
ltp/testcases/kernel/controllers/io-throttle/myfunctions.sh
ltp/testcases/kernel/controllers/io-throttle/run_io_throttle_test.sh

20) Log Message:
The attached patch fixes the following issue: The selinux-testsuite file sigiotask testcase (run as test_fileop_t) needs rw permission to terminals to proceed its execution, which is not allowed by the non refpolicies provided in the testsuite. Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/policy/test_file.te

21) Log Message:
gcov-kernel: patches for 2.6.26

Added Files:
linux-2.6.26-gcov-arm-eabi.patch 
linux-2.6.26-gcov-arm-hack.patch
linux-2.6.26-gcov.patch

22) Log Message:
The following problem i found:
1, utimensat01.c still has not been compiled when check_for_utimensat_support return success.
2, utimensat01 works on only i386 arch.
Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>

Modified File(s):
ltp/testcases/kernel/include/i386.in
ltp/testcases/kernel/include/ia64.in
ltp/testcases/kernel/include/linux_syscall_numbers.h
ltp/testcases/kernel/include/x86_64.in
ltp/testcases/kernel/syscalls/utimensat/Makefile
ltp/testcases/kernel/syscalls/utimensat/check_for_utimensat_support.c
ltp/testcases/kernel/syscalls/utimensat/utimensat01.c

23) Log Message:
Sorry, I took mistake in giving value to TST_* in io_setup01.c and io_submit01.c. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/io_setup/io_setup01.c
ltp/testcases/kernel/syscalls/io_submit/io_submit01.c

24) Log Message:
I found some typos. I cannot remember but maybe I introduced. Signed-off-by: Masatake YAMATO<yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c

25) Log Message:
I get compile error in hackbench. With the following patch, the compiler error is gone. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/sched/cfs-scheduler/hackbench.c

26) Log Message:
In fact, the case "hackbench02 hackbench 150 thread 1000" failed when i tested the latest ltp. the following error message occured: 
--------------------
Creating fdpair (error: Too many open files)
--------------------
The default open files is 1024 (ulimit -n), but hackbench does not close these all opened files in group() when thread mode (process_mode=0). I think we should to limit the num_groups's value. 20 is a suitable value, it works well on my ia64 and i386 machine. what do you think? Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>.

Modified File(s):
ltp/runtest/sched

27) Log Message:
It replaces nested arithmetic operations following example from Open Group specifications, in order to avoid issues with different shells, like dash from Ubuntu Gutsy. Signed-off-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/generate.sh

28) Log Message:
When compiling powerpc binaries, gcc defaults to 32 bit. To do some tests I needed to have a 64 bit binary. Since I'm using realtime, I modified config.mk as below. My questions: is there any official way to turn LTP in 64bit? If not, what shall we do then? Should LTP default to 32 or native-arch bit? Shall we use something like: "if (uname -m) ..." or use a command line option? Any comment?
Gilles.

According to man gcc:
 -m64
     Generate code for a 32-bit or 64-bit environment.  The 32-bit environment sets int, long and pointer to 32 bits and generates code that runs on any i386 system.  The 64-bit environment sets int to 32 bits and long and pointer to 64 bits and generates code for AMD's x86-64 architecture. For darwin only the -m64 option turns off the -fno-pic and -mdynamic-no-pic options. This seems like the right thing to do to me.  Gilles, have you confirmed that this doesn't break things on the x86_64 platforms? No objection from me. 
--Darren

I've also run the involved tests on an x86_64 machine and it was OK. Gilles Carry <Gilles.Carry@bull.net>.

Modified File(s):
ltp/testcases/realtime/config.mk

29) Log Message:
First patch regroups TSC functions and macros definition into librttest. Second patch is to have an atomic reading of the 64-bit timebase register of powerpc64. This new function is only valid if -m64 is used when compiling the whole testcase suite with a powerpc64. Thirs patch is a fix to avoid spurious tsc_minus warning. These patches been tested on a ppc64 machine either with 32 or 64 bit binaries. (-m64).  The same TSC read (rdtscll) macros and tsc_minus where implemented in three different tests. This patch put all this into librttest.*. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. Cc: Tim Chavez <tinytim@us.ibm.com>. Acked-by: Darren Hart <dvhltc@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/func/async_handler/async_handler_tsc.c
ltp/testcases/realtime/func/measurement/preempt_timing.c
ltp/testcases/realtime/func/measurement/rdtsc-latency.c
ltp/testcases/realtime/include/librttest.h
ltp/testcases/realtime/lib/librttest.c

30) Log Messsage:
This macro reads atomically the 64-bit TSC register. Reading the 64-bit register using two 32-bit instructions sometimes causes wrapping when a clock update appears in between. A single 64-bit read fixes this. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. Cc: Tim Chavez <tinytim@us.ibm.com>.  
I suppose the right thing to do in the long run would be to rename this function to something more generic: read_hw_clock() or something like that. But I think this patch performs the first step in getting it working on ppc64. Acked-by: Darren Hart <dvhltc@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/include/librttest.h

31) Log Message:
In tsc_minus, changed test (tsc_begin < tsc_end) by (tsc_begin <= tsc_end) since values can be equal as read operations are sometimes very close. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. Cc: Tim Chavez <tinytim@us.ibm.com>. Acked-by: Darren Hart <dvhltc@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/lib/librttest.c

32) Log Message:
Update to OpenHPI 2.12.0 (see www.openhpi.org for more info)

Modified File(s):
ltp/testcases/open_hpi_testsuite/*

33) Log Message:
Addition of move_pages() syscall tests. The updated patch fixes the warning messages and removes the print_bitmask function (it's not used) which causes build errors on powerpc. Signed-off-by: Vijay Kumar B. <vijaykumar@bravegnu.org>.

Modified Files:
ltp/Makefile
ltp/runtest/numa
ltp/runtest/syscalls
ltp/testcases/kernel/numa/Makefile

Added Files:
ltp/testcases/kernel/syscalls/move_pages/Makefile
ltp/testcases/kernel/syscalls/move_pages/move_pages.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages01.c
ltp/testcases/kernel/syscalls/move_pages/move_pages02.c
ltp/testcases/kernel/syscalls/move_pages/move_pages03.c
ltp/testcases/kernel/syscalls/move_pages/move_pages03.mode.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages04.c
ltp/testcases/kernel/syscalls/move_pages/move_pages05.c
ltp/testcases/kernel/syscalls/move_pages/move_pages06.c
ltp/testcases/kernel/syscalls/move_pages/move_pages07.c
ltp/testcases/kernel/syscalls/move_pages/move_pages08.c
ltp/testcases/kernel/syscalls/move_pages/move_pages09.c
ltp/testcases/kernel/syscalls/move_pages/move_pages10.c
ltp/testcases/kernel/syscalls/move_pages/move_pages11.c
ltp/testcases/kernel/syscalls/move_pages/move_pages11.mode.sh
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.c
ltp/testcases/kernel/syscalls/move_pages/move_pages_support.h
ltp/tools/scripts/numa_test.sh

34) Log Message:
The new patch addresses the other error conditions. Like if its not able to create any dir/files in a ReadOnly dir. Also this patch returns the proper return code on success/failure . I have tested this script on ReadWrite dir and ReadOnly dir. Veerendra Chandrappa <vechandr@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/fs/linktest/linktest.pl

--=-6JWFAzNkpgjXPoh3gfjy--

