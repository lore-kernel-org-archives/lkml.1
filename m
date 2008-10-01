Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYJAPoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYJAPoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYJAPn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:43:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48717 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYJAPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:43:54 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for SEPTEMBER
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Veerendra Chandrappa <vechandr@in.ibm.com>,
       Daniel Gollub <dgollub@suse.de>, Roy Lee <roylee17@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Matt Helsley <matthltc@us.ibm.com>,
       Mitsuru Chinen <mitch@linux.vnet.ibm.com>,
       Jin Bing Guo <guojb@cn.ibm.com>, Masatake YAMATO <yamato@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Chirag <chirag@linux.vnet.ibm.com>,
       Helge Deller <deller@gmx.de>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Rishikesh K Rajak <risrajak@in.ibm.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Nate Straz <nstraz@redhat.com>, Elder Costa <elder.costa@terra.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Moore <paul.moore@hp.com>,
       crackerjack-devel <crackerjack-devel@lists.sourceforge.net>
Content-Type: multipart/mixed; boundary="=-fGvlmlosqwnqlmK/KiV4"
Organization: IBM
Date: Wed, 01 Oct 2008 21:12:56 +0530
Message-Id: <1222875778.7129.5.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fGvlmlosqwnqlmK/KiV4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
SEPTEMBER 2008. The latest version of the test-suite contains 3000+
tests for the Linux OS and can be found at
https://sourceforge.net/projects/ltp/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


SEPTEMBER 2008 Highlights:
* Addition of getegid16(), switch(), signalfd() & getgid16() syscall
tests,
* Addition of Network Namepace tests,
* Addition of existing admin_tools & ioctl() tests to default LTP run,
* Cleanup for CONTAINERS tests,
* Fixes to some Network scripts,
* Memory Leak fixes for some tests,
* RT tests cleanup,
* Some fixes to OPEN_POSIX_TESTSUITE,
* Fixes for <dirent.h> & <page.h> compatibility,
* Inclusion of Audit test suite along with LTP release (See
http://marc.info/?l=ltp-list&m=122003481717739&w=2),



SEPTEMBER 2008 LTP Contributors:
* Masatake YAMATO,
* Veerendra Chandrappa,
* Daniel Gollub,
* Roy Lee,
* Paul Mackerras,
* Matt Helsley,
* Mitsuru Chinen,
* Jin Bing Guo,
* Michael Kerrisk,
* Li Zefan,
* Chirag,
* Helge Deller,
* Serge E. Hallyn,
* Rishikesh K Rajak,
* Robert Schwebel,
* Nate Straz,
* Elder Costa,


Note(s) from the Maintainer:

We saw lot of cleanups in this month with few new tests being added. I
would complete my promise about the remaining OLS 2008 fallout
discussions for LTP, soon. We will also discuss about the recently
concluded CRACKERJACK Developers Summit & the Linux Plumbers conference,
and what they mean for LTP´s future.


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

Please also see the Change Log Attached (SEPTEMBER 2008) for detailed
changes.

Happy testing, 
Regards-- 
Subrata,

--=-fGvlmlosqwnqlmK/KiV4
Content-Disposition: attachment; filename=September-2008_Changelog.txt
Content-Type: text/plain; name=September-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 8bit

1) Log Message:
Fix build error for libclone.c. Signed-off-by: Veerendra Chandrappa <vechandr@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/libclone/libclone.h

2) Log Message:
Set executable flag for netpipe.sh without chmod.sh which just performs an santiy check if the user is root to run chmod 755, which doesn't require root priviliges. Signed-off-by: Daniel Gollub <dgollub@suse.de>. 

Modified File(s):
ltp/tools/netpipe-2.4/Makefile

3) Log Messsage:
sync_pipe_close() returns an uninitialized value when it is passed an already closed pipe. Signed-off-by: Roy Lee <roylee17@gmail.com>. 

Modified File(s):
ltp/lib/libtestsuite.c

4) Log Message:
I extended getegid testcase to test getegid16, too. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/getegid/Makefile
ltp/testcases/kernel/syscalls/getegid/getegid01.c

5) Log Message:
This can only be tested on a POWER6 machine.  A program to test it is attached. --Paul Mackerras.
Thanks for sharing the test case with LTP. I have ported it to bare minimum LTP requirement and ran it on various architectures and kernel versions to test out the behaviour of the test on these machines. Yamato, When you find time, kindly add more specific stuff that we have specially for the LTP syscall tests, things like running in a loop, running concurrently, etc. And here goes the Patch. Paul, you can propose more modification to this if you wish to:
Signed-off-by: Paul Mackerras <paulus@samba.org>,
Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified Files:
ltp/runtest/syscalls

Added Files:
ltp/testcases/kernel/syscalls/switch/Makefile
ltp/testcases/kernel/syscalls/switch/switch01.c

6) Log Message:
I have seen that in some of my systems, utimensat fails to build because of some definitions missing in system headers. Do, you think we can apply the following patch: Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>. 

Modified File(s):
ltp/testcases/kernel/syscalls/utimensat/utimensat01.c

7) Log Message:
Looks OK as far as I can see, except that I wonder why you check for being root: since there is no restriction by the kernel on which processes can use this system call.  A process can't do anything to any other process using this system call, so there's no reason to restrict it. Also you might like to call it "endian_switch()" rather than just "switch()". Paul Mackerras <paulus@samba.org>.

Modified File(s):
ltp/testcases/kernel/syscalls/switch/switch01.c

8) Log Message:
The following two scripts cannot execute correctly on my box, which doesn’t equip gawk but awk (busybox). This patch makes them, as well as other scripts( see the patch), to not explicitly using gawk but awk. roylee@andestech.com. 

Modified File(s):
ltp/testcases/commands/cron/cron_allow01
ltp/testcases/commands/cron/cron_deny01
ltp/testcases/commands/cron/cron_neg_tests.sh
ltp/testcases/kernel/ipc/ipc_stress/cleanup
ltp/testcases/kernel/ipc/ipc_stress/run_semaphore_test_01.sh
ltp/testcases/open_hpi_testsuite/clients/hpionIBMblade.c

9) Log Message:
This patch does the following:
1. These test cases failed with "open returned unexpected errno 2" because the child process falls through to execute redundant cleanup(),
2. Added code to use the tst_tmpdir()/tst_rmdir() APIs.
Signed-Off-By: <roylee@andestech.com>

Modified File(s):
ltp/testcases/kernel/syscalls/setfsuid/setfsuid04.c
ltp/testcases/kernel/syscalls/setresuid/setresuid04.c
ltp/testcases/kernel/syscalls/setreuid/setreuid07.c

10) Log Message:
Remove redundant bits from the container test script. Keep the nicer/self-consistent info. Add proper dependencies on check_for_unshare rather than shoehorning it in as a MAKE command in *only* the 'all' target. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-by: Serge Hallyn <serue@us.ibm.com>,

Modified File(s):
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/container_test.sh

11) Log Message:
Make these rules a tiny bit more generic using the automatic $@ variable. This means anyone copying this line is less likely to make copy/paste errors. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-By: Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/Makefile

12) Log Message:
When it comes to this program, why should we care what the arch is? Shouldn't the SYS_ and __NR numbers alone tell us if unshare() is relevant here? Also, suppose both SYS_unshare and __NR_unshare aren't defined and we're running on an i386 box. This means we'll trigger the block: 
        #elif __i386__
                int do_check(void) { return kernel_is_too_old(); }
Which is totally wrong. Fix these up by ignoring the arch and boiling it all down to a corrected check for the proper define(s). See sys/syscall.h for details on SYS_ vs. __NR_. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-by: Serge Hallyn <serue@us.ibm.com>,

Modified File(s):
ltp/testcases/kernel/containers/check_for_unshare.c

13) Log Message:
Now that we have proper dependencies on check_for_unshare we take explicit tests for unshare out of the top-level make file and distribute to each subdir Makefile as ifeq...endif sections which control which targets to build. While it doesn't avoid descending into subdirs it's easier to read and check the make code when most of the build rules don't have shell flow control. Even better if we could change the contents of SUBDIRS based on the results of running check_for_unshare. Also note the use of := and not =. info Make is our friend. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-by: Serge Hallyn <serue@us.ibm.com>, 

Modified File(s):
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/libclone/Makefile
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/utsname/Makefile

14) Log Message:
Now that they are in it's best to drop the noltp junk leftover from the LTP port of the container tests. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-by: Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/libclone/Makefile
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/pidns/pidns01.c
ltp/testcases/kernel/containers/pidns/pidns02.c
ltp/testcases/kernel/containers/pidns/pidns03.c
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/sysvipc/shmnstest.c
ltp/testcases/kernel/containers/utsname/Makefile
ltp/testcases/kernel/containers/utsname/utstest.c

15) Log Message:
Use non-recursive assignment. This means, for example, that:
SRCS := $(wildcard *.c)
will call the wildcard function, substitute the output, and assign it to SRCS. Recursive assignment (plain =) would use the output and continue performing substitutions until no further substitutions could be made. Signed-off-by: Matt Helsley <matthltc@us.ibm.com>, Acked-by: Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/libclone/Makefile
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/utsname/Makefile

16) Log Message:
The operator for string unequivalent check is not '-ne' but '!='. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/ipv6/finger6/finger601

17) Log Message:
The state of finger service is not got correctly as an option for netstat is lacked. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/ipv6/finger6/finger601

18) Log Message:
Although ping6 doesn't have -R option, it is specified. It should be removed. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/ipv6/ping6/ping601

19) Log Message:
Fix the build error for some systax error. Also fix some warnings. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/switch/switch01.c

20) Log Message:
Part of these tests are pretty much enough to invoke an oom-killer. Let the test do the functional testing part, and, we can do stress testing with hackbench seperately. Si
gned-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/runtest/sched

21) Log Message:
Fix memory leak in time-schedule.

Modified File(s):
ltp/testcases/kernel/sched/tool/time-schedule.c

22) Log Message:
Fix memory leak in trace_sched.

Modified File(s):
ltp/testcases/kernel/sched/tool/trace_sched.c

23) Log Message:
Fix memory leak in message_queue_test_01.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/message_queue_test_01.c

24) Log Message:
Fix memory leak in semaphore_test_02.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/semaphore_test_02.c

25) Log Message:
I worked on 2 test cases for foogid16 system calls; and I will do 5 more. All these test cases have the same macro. So I'd like to introduce compat_gid.h; and put the macro to the file. Could you add compat_gid.h to testcases/kernel/syscalls/utils/ and apply patches for existing test cases? Here after I'd like to use the compat_gid.h in newly ported test cases. Signed-off-by: Masatake YAMATO <yamato@redhat.com>,

Modified Files:
ltp/testcases/kernel/syscalls/setgid/Makefile
ltp/testcases/kernel/syscalls/setgid/compat_16.h
ltp/testcases/kernel/syscalls/setgid/setgid02.c
ltp/testcases/kernel/syscalls/setgid/setgid03.c
ltp/testcases/kernel/syscalls/setgroups/Makefile
ltp/testcases/kernel/syscalls/setgroups/compat_16.h
ltp/testcases/kernel/syscalls/setgroups/setgroups02.c
ltp/testcases/kernel/syscalls/setgroups/setgroups03.c

Added Files:
ltp/testcases/kernel/syscalls/utils/compat_gid.h

26) Log Message:
Add $(CFLAGS). From: Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/containers/Makefile

27) Log Message:
Paul <paulus@samba.org> wanted the name to be endian_switch. Michael Kerrisk <mtk.manpages@googlemail.com> seconded his suggestion. 

Modified File(s):
ltp/testcases/kernel/syscalls/switch/switch01.c

28) Log Message:
Don't warn that TCID, TST_TOTAL and TST_COUNT is not set when using tst_kvercmp. And. Check /proc/net/connector to see if process event connector is supported or not. Also merged some cleanups done by Matt Helsley. Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/runltp
ltp/testcases/kernel/Makefile
ltp/testcases/kernel/connectors/Makefile
ltp/testcases/kernel/connectors/connector_test.sh
ltp/testcases/kernel/connectors/pec/run_pec_test
ltp/tools/apicmds/ltpapicmd.c

29) Log Message:
Fix memory leak in semaphore_test_03.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/semaphore_test_03.c

30) Log Message:
I think TST_NEWER_64_SYSCALL is better than TST_NEWER_64 because newer_64.mk is local to testcases/kernel/syscalls. This rule is applicable to compat_16.mk. Signed-off-by: Roy Lee <roylee17@gmail.com>. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/utils/compat_16.mk
ltp/testcases/kernel/syscalls/utils/newer_64.mk

31) Log Message:
Addition of signalfd() syscall test case(s) to LTP. Signed-Off-By: Masatake YAMATO <yamato@redhat.com>.

Added Files:
ltp/testcases/kernel/syscalls/signalfd/Makefile
ltp/testcases/kernel/syscalls/signalfd/signalfd01.c
ltp/testcases/kernel/syscalls/utils/cond.mk

32) Log Message:
This patch removes outdated (or irrelevant) parts of the  existing documentation and updates its. Also incorporated are suggestions made by Darren.  Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/realtime/README
ltp/testcases/realtime/doc/HOWTO_ADD_TESTS

33) Log Message:
This patch fixes a few minor issues in run.sh
1. Adds list option to the usage() command.
2. Remove java from "all" tests to be run.
3. It fix the output of usage (./run.sh or ./run.sh -h)

Tested: Running "./run.sh -t func", "./run.sh -t all" , "./run.sh",  "./run.sh -h". Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/config.mk
ltp/testcases/realtime/run.sh

34) Log Message:
This patch ensures that the python scripts support utf encoding. Prior to the patch, the python scripts would exit with this error:
File "parse-testpi1.py", line 3
SyntaxError: Non-ASCII character '\xc2' in file parse-testpi1.py on line 3, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details
This patch fixes it. Tested: Running all the python scripts. Signed-Off-By:Chirag <chirag@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/realtime/func/pi-tests/parse-testpi1.py
ltp/testcases/realtime/func/pi-tests/parse-testpi2.py
ltp/testcases/realtime/func/sched_football/parse-football.py
ltp/testcases/realtime/scripts/parser.py

35) Log Message:
This patch fixes the getcpu patch for parisc (and probably other platforms as well). The check for "__GLIBC__ >= 2 && __GLIBC_MINOR__ >= 6" is wrong. It breaks as soon as a glibc 3.0 would be published. Replace it with __GLIBC_PREREQ(2,6). Tested on parisc and i386. Signed-off-by: Helge Deller <deller@gmx.de>.

Modified File(s):
ltp/testcases/kernel/syscalls/getcpu/getcpu01.c

36) Log Message:
Garrett, thank you for input. I think my patch works as you wrote. My patch tries sys/signalfd.h then linux/signalfd.h. So I can say my patch tries "whatever's the newest standard"(glibc header file) then "deprecated version"(no glibc header but kernel header file). It is important point. Thank you. CROSS_CFLAGS should be considered when checking the existance of header file. I update the last patch. It does
  1. If sys/signalfd.h is not available, use syscall to invoke signalfd.
  2. CFLAGS is considered when checking the existance of signalfd.h.
  3. Checking the existance of signalfd.h in addition to checking sys/signalfd.h and linux/signalfd.h.     
Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/signalfd/Makefile
ltp/testcases/kernel/syscalls/signalfd/signalfd01.c
ltp/testcases/kernel/syscalls/utils/cond.mk

37) Log Message:
When I built and installed the latest LTP cases, some errors broke the install process. And the system didn't support "unshare". The patches modified these files. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>. Based on a cursory glance and memory of Matt's patches, this looks good. "Serge E. Hallyn" <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/containers/pidns/Makefile
ltp/testcases/kernel/containers/sysvipc/Makefile
ltp/testcases/kernel/containers/utsname/Makefile

38) Log Message:
I got this failure because of the typo in the testcase.
# ./hugemmap01 -H/huge
hugemmap01    1  FAIL  :  open() on /huge/1602mmapfile Failed, errno=2 : No such file or directory

This failure needs to be /huge directory present inside the / directory. I don't think mkdir /huge is a good idea so i modified as : Signed-off By: Rishikesh K Rajak <risrajak@in.ibm.com>.

Modified File(s):
ltp/runtest/hugetlb

39) Log Message:
Here is some small correction in memory map stress testcases. Result before
applying patch:

# ./mmapstress01 -h
./mmapstress01: invalid option -- h
usage: ./mmapstress01 -p nprocs [-t minutes -f filesize -S sparseoffset -r -o -m -l -d]
mmapstress01    1  FAIL  :  Test failed

Result after applying patch:

# ./mmapstress01 -h
./mmapstress01: invalid option -- h
usage: ./mmapstress01 -p nprocs [-t minutes -f filesize -S sparseoffset -r -o -m -l -d]

Signed-off By: Rishikesh K Rajak <risrajak@in.ibm.com>

Modified File(s):
ltp/testcases/kernel/mem/mmapstress/mmapstress01.c

40) Log Message:
The Makefile in the mqueues- and semaphores directory of the open_posix_testsuite try incorrectly to overwrite the compiler and have no clue about the fact that there could be a cross compilation scenario, so it tries to search libs in /usr/lib. This results in the following command line:

make[2]: Entering directory `<somewhere>/ltp-full-20080831/testcases/open_posix_testsuite/stress/mqueues' 
gcc -Wall -O2 -g -I -L/usr/lib -lpthread -I../../include multi_send_rev_1.c -o multi_send_rev_1.test -lmqueue

which is obviously wrong for cross compilation. With this change the right compiler and the right libs from the toolchain are being used. Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>.

Modified File(s):
ltp/testcases/open_posix_testsuite/stress/mqueues/Makefile
ltp/testcases/open_posix_testsuite/stress/semaphores/Makefile


41) Log Message:
The Makefile in the mqueues directory of the open_posix_testsuite wants to link the mq_open testcase against libmqueue. POSIX.1-2001 states: 
"Link with -lrt".
So this is definitely wrong, and we do what the standard recommends. Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>.

Modified File(s):
ltp/testcases/open_posix_testsuite/stress/mqueues/Makefile

42) Log Message:
The semaphores tests of the open_posix_testsuite want to link again libposix1b, but I don't have any idea why it tries to do so. However, it results in:

gcc -Wall -O2 -g -I -L/usr/lib -I../../include multi_con_pro.c -o multi_con_pro.test -lposix1b -lpthread
/usr/bin/ld: cannot find -lposix1b

This patch removes the bogus library. Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>.

Modified File(s):
ltp/testcases/open_posix_testsuite/stress/semaphores/Makefile

43) Log Message:
To make POSIX namespace clear, glibc-2.8 requires people to define _GNU_SOURCE when they use Advanced Socket APIs. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/lib6/Makefile

44) Log Message:
The definitions, ICMP6_RR_PCOUSE_DECRVLTIME and ICMP6_RR_PCOUSE_DECRPLTIME are wrong. According to RFC3542, they should be ICMP6_RR_PCOUSE_FLAGS_DECRVLTIME, ICMP6_RR_PCOUSE_FLAGS_DECRPLTIME. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/lib6/asapi_03.c

45) Log Message:
"man 3 cmsg" says "Ancillary data should only be accessed using the CMSG macros and never directly." Indeed, when we handles cmsghdr mamber directly, this test falls into the infinite loop on a x86_64 environment. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/lib6/asapi_06.c

46) Log Message:
When we compile the test codes with -Wall option, lots of warning appear. It is better to remove them for the future debbuging. Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/lib6/asapi_04.c
ltp/testcases/network/lib6/asapi_05.c
ltp/testcases/network/lib6/asapi_06.c
ltp/testcases/network/lib6/asapi_07.c
ltp/testcases/network/lib6/getaddrinfo_01.c
ltp/testcases/network/lib6/in6_01.c
ltp/testcases/network/lib6/in6_02.c
ltp/testcases/network/lib6/runcc.c

47) Log Message:
Sorry, I took a mistake. Could you apply following patch? Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/utils/cond.mk

48) Log Message:
Addition of getgid16() test cases. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/testcases/kernel/syscalls/getgid/Makefile
ltp/testcases/kernel/syscalls/getgid/getgid01.c
ltp/testcases/kernel/syscalls/getgid/getgid02.c
ltp/testcases/kernel/syscalls/getgid/getgid03.c

Added Files:
ltp/testcases/kernel/syscalls/getgid/compat_16.h

49) Log Message:
In testcases/kernel/ipc/ipc_stress/cleanup file,  it uses the command "ipcrm " to delete the ipc resources. But usage is deprecated and noneffective in some cases. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/cleanup

50) Log Message:
Segmentation fault error: When I ran runtest/math with runltp, the float cases worked well. But they would drop into segmentation fault when they were called directly in command line. The reason is to input "NULL" to strlen() which caused Segmentation fault. The patch also fixed a large number of  memory leaks in math/float cases.Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/misc/math/float/main.c
ltp/testcases/misc/math/float/thread_code.c

51) Log Message:
Fix memory leaks in mem02. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.  

Modified File(s):
ltp/testcases/kernel/mem/mem/mem02.c

52) Log Message:
Fix memory leaks in pipeio. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/ipc/pipeio/pipeio.c

53) Log Message:
Fix memory leaks in mallocstress. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/mem/mtest07/mallocstress.c

54) Log Message:
Fix the error in freeing memory on confstr01. In confstr01.c,  it's wrong that it reset the buffer contents to NULL before freeing the memory allocated. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/confstr/confstr01.c

55) Log Message:
Addition of Initial Set of Network Name Space test cases. Signed-Off-By: Veerendra <veeren@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/containers/Makefile
ltp/testcases/kernel/containers/README
ltp/testcases/kernel/containers/check_for_unshare.c
ltp/testcases/kernel/containers/container_test.sh
ltp/testcases/kernel/containers/libclone/Makefile
ltp/testcases/kernel/containers/libclone/libclone.h

Added Files:
ltp/testcases/kernel/containers/libclone/libnetns.c
ltp/testcases/kernel/containers/netns/Makefile
ltp/testcases/kernel/containers/netns/ch_ftp.sh
ltp/testcases/kernel/containers/netns/check_netns_enabled.c
ltp/testcases/kernel/containers/netns/child.sh
ltp/testcases/kernel/containers/netns/child_1.sh
ltp/testcases/kernel/containers/netns/child_2.sh
ltp/testcases/kernel/containers/netns/child_propagate.sh
ltp/testcases/kernel/containers/netns/childipv6.sh
ltp/testcases/kernel/containers/netns/childns.sh
ltp/testcases/kernel/containers/netns/container_ftp.pl
ltp/testcases/kernel/containers/netns/crtchild.c
ltp/testcases/kernel/containers/netns/crtchild_delchild.c
ltp/testcases/kernel/containers/netns/delchild.sh
ltp/testcases/kernel/containers/netns/initialize.sh
ltp/testcases/kernel/containers/netns/par_chld_ftp.c
ltp/testcases/kernel/containers/netns/par_chld_ipv6.c
ltp/testcases/kernel/containers/netns/par_ftp.sh
ltp/testcases/kernel/containers/netns/parent.sh
ltp/testcases/kernel/containers/netns/parent_1.sh
ltp/testcases/kernel/containers/netns/parent_2.sh
ltp/testcases/kernel/containers/netns/parent_share.sh
ltp/testcases/kernel/containers/netns/parent_view.sh
ltp/testcases/kernel/containers/netns/parentns.sh
ltp/testcases/kernel/containers/netns/paripv6.sh
ltp/testcases/kernel/containers/netns/rename_net.sh
ltp/testcases/kernel/containers/netns/runnetnstest.sh
ltp/testcases/kernel/containers/netns/sysfsview.c
ltp/testcases/kernel/containers/netns/two_children_ns.c

56) Log Message:
The attached patch moves getgid02.c to getegid02.c. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/getegid/Makefile
ltp/testcases/kernel/syscalls/getegid/getegid01.c

Added Files:
ltp/testcases/kernel/syscalls/getegid/compat_16.h
ltp/testcases/kernel/syscalls/getegid/getegid02.c

Removed Files:
ltp/testcases/kernel/syscalls/getgid/getgid02.c

57) Log Message:
Added Default LTP run, Ballista & Open Posix Suite run to runalltests.sh. More such tests are to follow. Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/runalltests.sh

58) Log Message:
I am not sure why runtest/admin_tools was kept outside the perview of LTP default run. I found no issues in running it as normally as other LTP tests. Please let me know if some of you have some problem running it as default. Also included are some changes for running fs_acls tests. Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/runltp
ltp/testcases/kernel/fs/acls/Makefile
ltp/testcases/kernel/fs/acls/acl_test01

59) Log Message:
-t test-arguments       Where test-argument can be a space separated sequence of:
                        func            all functional tests will be run
                        stress          all stress tests will be run
                        perf            all perf tests will be run
                        all             all tests will be run
                        list            all available tests will be listed
                        clean           all logs deleted, make clean performed
                        test_name       only test_name subdir will be run (e.g: func/pi-tests)
-p profile              Use profile instead of default (see doc/AUTOMATED_RUN)
-h                      help
Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/run.sh

60) Log Message:
Daniel Gollub <dgollub@suse.de> wrote: With 2.6.27-rc* linux/dirent.h got removed Kbuild headers_install targe and dirent struct got removed. Instead use #include <dirent.h> instead of #include <linux/dirent.h>. Garrett Cooper <yanegomi@gmail.com> wrote: It appears that asm/page.h isn't packaged with kernel.org sources anymore as of 2.6.25, according to some folks on #fedora-devel. I was just wondering a) if that's the case, b) whether or not those affected test compiles have been identified and removed / modified? If both questions are true and no one has pointed out this issue before now, I've found all of the items which don't follow this behavior: According to the folks in #fedora-devel (airlied, jwb), we shouldn't be using asm/page.h directly, but instead should be accessing everything in page.h via sysconf(2), like so:
                PAGE_SIZE => sysconf(_SC_PAGE_SIZE)
This method is POSIX compatible as per: http://www.opengroup.org/onlinepubs/009695399/functions/sysconf.html.
Yes, it is. There are numerous test cases in LTP which use:
       struct dirent, 
by including /usr/include/dirent.h. The interesting part is, this guy (/usr/include/dirent.h) in turn includes /usr/include/bits/dirent.h, where the definition of struct resides. Following is the patch which solves this issue along with page.h header file removal from 2.6.25 onwards, reported by Garret earlier. Signed-of-by: Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/io-throttle/iobw.c
ltp/testcases/kernel/module/create_module/create_module02.c
ltp/testcases/kernel/module/delete_module/delete_module02.c
ltp/testcases/kernel/module/query_module/query_module01.c
ltp/testcases/kernel/module/query_module/query_module02.c
ltp/testcases/kernel/module/query_module/query_module03.c
ltp/testcases/kernel/syscalls/getdents/getdents01.c
ltp/testcases/kernel/syscalls/getdents/getdents02.c
ltp/testcases/kernel/syscalls/getdents/getdents03.c
ltp/testcases/kernel/syscalls/getdents/getdents04.c
ltp/tools/top-LTP/proc/devname.c

61) Log Message:

Modified Files:
ltp/runtest/ltplite
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/ioctl/Makefile
ltp/testcases/kernel/syscalls/ioctl/ioctl01.c
ltp/testcases/kernel/syscalls/ioctl/ioctl02.c

Added Files:
ltp/testcases/kernel/syscalls/ioctl/test_ioctl

62) Log Message:
This patch introduces new check_header defined in utils/cond.mk to Makefile for eventfd test cases. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/eventfd/Makefile

63) Log Message:
This patch introduces new check_header defined in utils/cond.mk to Makefile for inotify test cases. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/Makefile

64) Log Message:
Added runtest/syscalls entry for signalfd. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/runtest/syscalls

65) Log Message:
This patch introduces new check_header defined in utils/cond.mk to Makefile for modify_ldt test cases. Signed-off-by: Masatake YAMATO <yamato@redhat.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/modify_ldt/Makefile

66) Log Message:
Simplify genload Makefile. It turns out most of these options aren't needed to build stress. Signed-off-by: Nate Straz <nstraz@redhat.com>.

Modified File(s):
ltp/tools/genload/Makefile

67) Log Message:
In io_cancel01 , io_destroy01, io_getevents01, io_setup01, io_submit01, if the libaio-devel package didn't been installed on the system, some errors would be occured. To fix it, the each Makefile would be modified. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/io_cancel/Makefile
ltp/testcases/kernel/syscalls/io_destroy/Makefile
ltp/testcases/kernel/syscalls/io_getevents/Makefile
ltp/testcases/kernel/syscalls/io_setup/Makefile
ltp/testcases/kernel/syscalls/io_submit/Makefile

68) Log Message:
When the libcap-2.11 or newer didn't been installed on the sysytem, the filecaps testcase would return a message instead of an error. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/filecaps/filecapstest.sh

69) Log Message:
On ppc64, the modify_ldt cases would not been compiled. So it should be return the message:"System doesn't support execution of the test" instead of an error message. In addition, the Fix_runtest_syscalls.patch also resolved the switch01 running error. Signed-off-by: Jin Bing Guo <guojb@cn.ibm.com>.

Modified Files:
ltp/runtest/syscalls
ltp/testcases/kernel/syscalls/modify_ldt/Makefile

Added Files:
ltp/testcases/kernel/syscalls/modify_ldt/run-modify_ldt01.sh
ltp/testcases/kernel/syscalls/modify_ldt/run-modify_ldt02.sh

70) Log Message:
IDCheck.sh fails to detect the group nobody does not exist and exits with 0 status. This patch fixes this behavior. I have added a small cosmetic change to indicate No is the default response to the question asked by the script. Signed-Off-By: Elder Costa <elder.costa@terra.com.br>.

Modified File(s):
ltp/IDcheck.sh

71) Log Message:
The following patch is for script testcases/kernel/ipc/ipc_stress/run_semaphore_test_01.sh. It fixes a test error (line 72) and a bash specific test extension. (lines 72 and 102) that fail to run under Ubuntu (and probably Debian) as /bin/sh points to dash instead of bash (as in Redhat/Fedora). This script would also benefit of a reformatting as it lacks indentation but I wanted to keep the patch simple and I am not familiar with script format style of LTP. Signed-Off-by: Elder Costa <evcosta@dixtal.com.br>.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/run_semaphore_test_01.sh

72) Log Message:
The following patch fixes testcases/kernel/syscalls/creat/creat08.c just like the previous one for open10.c. Signed-Off-By: Elder Costa <elder.costa@terra.com.br>.

Modified File(s):
ltp/testcases/kernel/syscalls/creat/creat08.c

73) Log Message:
The following patch is for testcases/kernel/syscalls/open/open10.c. Ubuntu (and I believe, Debian) does not have a nobody group and the program fails to run. I added some lines instead to test for "nogroup" instead which I believe is Debian's equivalent and must do what the program is intended to. Signed-Off-By: Elder Costa <evcosta@dixtal.com.br>.

Modified File(s):
ltp/testcases/kernel/syscalls/open/open10.c

74) Log Message:
Trivial patch to remove an unused local var. Signed-off-by: Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/filecaps/verify_caps_exec.c

75) Log Message:
I needed the following patch in order for file capabilities to correctly install.  If there is a better way to do this, that's fine with me, but CC was undefined and this was the easiest way to get past this. Signed-off-by:  Serge Hallyn <serue@us.ibm.com>.

Modified File(s):
ltp/testcases/kernel/security/filecaps/checkforlibcap.sh

--=-fGvlmlosqwnqlmK/KiV4--

