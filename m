Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbYB2NP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbYB2NP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYB2NPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:15:18 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55261 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYB2NPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:15:13 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for FEBRUARY
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       SE Linux <selinux@tycho.nsa.gov>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-1Gn8eIB3S4GaF1lj4XlC"
Organization: IBM
Date: Fri, 29 Feb 2008 18:45:04 +0530
Message-Id: <1204290904.4764.25.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Gn8eIB3S4GaF1lj4XlC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
FEBRUARY 2008. The latest version of the test-suite contains 3000+ tests
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

* Addition of CPU CONTROLLER Test Cases,
* Addition of few MSGCTL Test Cases,
* Several Rounds of RT Linux Test Cases Cleanup,
* SE-LINUX Test Cases Cleanups,
* Initiation to Make LTP Test Cases Concurrency-Safe,
* Updates for LCOV, PID & SYSVIPC NAMESPACES, HUGETLB, NUMA, SCHEDULER,
FILECAPS, LTP LIBRARY, DISKTESTS, PCLLIB, FALLOCATE, BALLISTA, TIMERS,
DOIO, MEM, and scores of other Test cases.


Note(s) from the Maintainer:

You all might have noted the exponential increase in mail traffic.Thanks
for all the right noise.We saw an interesting development, in terms of
making LTP concurrency-safe. I feel that is a major development. We
repeated our enthusiasm for RT Test Cases, last time i remember we did
for LTP-KDUMP. We also saw CPU Controller Test Cases Added and will see
more such test cases getting added regularly in future. The Time has
come for us to think of contributing more test cases and other effective
ways of increasing Kernel Code Coverage.


We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (FEBRUARY 2008):

Happy testing, 
Regards-- 
Subrata,

--=-1Gn8eIB3S4GaF1lj4XlC
Content-Disposition: attachment; filename=Feb-2008_Changelog.txt
Content-Type: text/plain; name=Feb-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1)  Log Message: lcov: adding support for gzipped html based on patch by dn=
ozay@vmware.com
File(s) Modified:
ltp/utils/analysis/lcov/lcovrc
ltp/utils/analysis/lcov/man/genhtml.1
ltp/utils/analysis/lcov/man/lcovrc.5
ltp/utils/analysis/lcov/bin/genhtml

2) Log Message: Fix for Don=C2=B4t call Domain type on test create, by, "Se=
rge E. Hallyn" <serue@us.ibm.com>
File(s) Modified:
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch
ltp/testscripts/test_selinux.sh

3) Log Message: Some code cleanup in PID & SYSVIPC namespace testcases, by,=
 "Rishikesh K. Rajak" <risrajak@linux.vnet.ibm.com>
Modified File(s):
ltp/testcases/kernel/containers/pidns/pidns01.c
ltp/testcases/kernel/containers/pidns/pidns02.c
ltp/testcases/kernel/containers/pidns/pidns03.c
ltp/testcases/kernel/containers/sysvipc/shmnstest.c

4) Log Message: Some Cleanups and running hugetlb independantly
Modified File(s):
ltp/testcases/kernel/mem/hugetlb/hugemmap/hugemmap02.c
ltp/testcases/kernel/mem/hugetlb/hugemmap/hugemmap04.c
Added File(s):
ltp/runtest/hugetlb

5) Log Message: Give Execute Permission to numa01.sh, by, Pradeep K Suriset=
ty <pradeepkumars@in.ibm.com>
Modified File(s):
ltp/testcases/kernel/numa/Makefile

6) Log Message: Let tests send sigchld to unconfined_t.  Without this, the =
selinux testsuite on Fedora 8 hangs at selinux_task_create.sh, by, "Serge E=
. Hallyn" <serue@us.ibm.com>
Modified File(s):
ltp/testcases/kernel/security/selinux-testsuite/misc/sbin_deprecated.patch

7) Log Message: str_echo function expects a file descriptor & not an addres=
s, by, Craig Meier <crmeier@ghs.com>
Modified File(s):
ltp/testcases/kernel/sched/clisrv/pthserv.c

8) Log Message: Build Error Fix by checking for installation of setcap or x=
attr headers, by, "Serge E. Hallyn" <serue@us.ibm.com>
Modified File(s):
ltp/testcases/kernel/security/filecaps/Makefile
ltp/testcases/kernel/security/filecaps/checkforlibcap.sh
Added Files:
ltp/testcases/kernel/security/filecaps/check_xattr.c

9) Log Message: mark test_exit as noreturn #1891129 by Marcus Meissner, by,=
 Mike Frysinger <vapier@users.sourceforge.net>
Modified File(s):
ltp/ltp/include/test.h
Added File(s):
ltp/ltp/include/compiler.h

10)Log Message: Disktest application update to version 1.4.2, by, Brent Yar=
dley <yardleyb@us.ibm.com>
Modified File(s):
ltp/testcases/kernel/io/disktest/Getopt.c
ltp/testcases/kernel/io/disktest/Getopt.h
ltp/testcases/kernel/io/disktest/Makefile
ltp/testcases/kernel/io/disktest/Makefile.aix
ltp/testcases/kernel/io/disktest/Makefile.linux
ltp/testcases/kernel/io/disktest/Makefile.windows
ltp/testcases/kernel/io/disktest/README
ltp/testcases/kernel/io/disktest/childmain.c
ltp/testcases/kernel/io/disktest/childmain.h
ltp/testcases/kernel/io/disktest/defs.h
ltp/testcases/kernel/io/disktest/dump.c
ltp/testcases/kernel/io/disktest/dump.h
ltp/testcases/kernel/io/disktest/globals.c
ltp/testcases/kernel/io/disktest/globals.h
ltp/testcases/kernel/io/disktest/io.c
ltp/testcases/kernel/io/disktest/io.h
ltp/testcases/kernel/io/disktest/main.c
ltp/testcases/kernel/io/disktest/main.h
ltp/testcases/kernel/io/disktest/parse.c
ltp/testcases/kernel/io/disktest/parse.h
ltp/testcases/kernel/io/disktest/sfunc.c
ltp/testcases/kernel/io/disktest/sfunc.h
ltp/testcases/kernel/io/disktest/stats.c
ltp/testcases/kernel/io/disktest/stats.h
ltp/testcases/kernel/io/disktest/threading.c
ltp/testcases/kernel/io/disktest/threading.h
ltp/testcases/kernel/io/disktest/timer.c
ltp/testcases/kernel/io/disktest/timer.h
ltp/testcases/kernel/io/disktest/usage.c
ltp/testcases/kernel/io/disktest/usage.h
ltp/testcases/kernel/io/disktest/man1/disktest.1
Added File(s):
ltp/testcases/kernel/io/disktest/CHANGELOG
ltp/testcases/kernel/io/disktest/disktest.spec
ltp/testcases/kernel/io/disktest/signals.c
ltp/testcases/kernel/io/disktest/signals.h
ltp/testcases/kernel/io/disktest/man1/disktest_manual.html

11) Log Message: Pid Namespace were getting segmentation fault while runnin=
g on -mm kernel. After debugging by container development team they found t=
he exact root cause. The Page_Size was reset, by, "Rishikesh K. Rajak" <ris=
rajak@linux.vnet.ibm.com>
Modified File(s):
ltp/testcases/kernel/containers/libclone/libclone.c

12) Log Message: Based on the discussion at LKML (http://lkml.org/lkml/2007=
/11/29/325), Ricardo Salveti de Araujo <rsalveti@linux.vnet.ibm.com> remove=
d the test case that verifies if the pgoff is "valid"
Modified File(s):
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages02.c

13) Log Message: The problem was the position of the parenthesis, which mad=
e "fd" receive the result of the < (lower than) operation, instead of the a=
ctual return value from open. This implicates a lot of trouble in any subse=
quent reference to fd, used in write and mmap. Because of this, mmap was re=
turning an error number (ENODEV), instead of a valid memory address, which =
created the mprotect trouble. Fix by Jose Otavio Rizzatti Ferreira <josefer=
r@br.ibm.com>
Modified File(s):
ltp/testcases/kernel/syscalls/mprotect/mprotect02.c

14) Log Message: Patrick Kirsch <pkirsch@suse.de> personally thinks, it wou=
ld be better to print out the "actual" return code from sysconf call instea=
d of the errno, which may lead to confusion, because the actual return code=
 from the failing sysconf is probably not 0 (as errno is defined in previou=
s context).
Modified File(s):
ltp/testcases/kernel/syscalls/sysconf/sysconf01.c

15) Log Message: Do not store cache files, by, Mike Frysinger <vapier@users=
.sourceforge.net>
Deleted File(s):
ltp/testcases/realtime/autom4te.cache/traces.0
ltp/testcases/realtime/autom4te.cache/traces.1
ltp/testcases/realtime/autom4te.cache/requests
ltp/testcases/realtime/autom4te.cache/output.1
ltp/testcases/realtime/autom4te.cache/output.0

16) Log Message: Remove compiled files, by, Mike Frysinger <vapier@users.so=
urceforge.net>
Modified File(s):
ltp/testcases/kernel/syscalls/pcllib/libtool
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/config.h
ltp/testcases/kernel/syscalls/pcllib/config.log
ltp/testcases/kernel/syscalls/pcllib/config.status

17) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/test/.deps/cobench.Po
ltp/testcases/kernel/syscalls/pcllib/test/.deps/cothread.Po

18) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/man/Makefile

19) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/pcl/.deps/pcl_version.Plo
ltp/testcases/kernel/syscalls/pcllib/pcl/.deps/pcl.Plo

20) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/autom4te.cache/traces.0
ltp/testcases/kernel/syscalls/pcllib/autom4te.cache/traces.1
ltp/testcases/kernel/syscalls/pcllib/autom4te.cache/requests
ltp/testcases/kernel/syscalls/pcllib/autom4te.cache/output.1
ltp/testcases/kernel/syscalls/pcllib/autom4te.cache/output.0

21) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/include/Makefile

22) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/test/Makefile

23) Log Message: punt compiled files, by, Mike Frysinger <vapier@users.sour=
ceforge.net>
Deleted File(s):
ltp/testcases/kernel/syscalls/pcllib/pcl/Makefile

24) Log Message: This will address the problem until distros update with la=
test glibc which has fallocate implementation. This is not extensively test=
ed and built with some assumption like
     o we are testing on x86* and ppc* archs
     o on 64 bit machine we will always see 64 bit kernel running
by, Nagesh Sharyathi <sharyathi@in.ibm.com>
Modified File(s):
ltp/testcases/kernel/syscalls/fallocate/fallocate01.c
ltp/testcases/kernel/syscalls/fallocate/fallocate02.c
ltp/testcases/kernel/syscalls/fallocate/fallocate03.c

25) Log Message:=20
Since msgmni now scales to the memory size, it may reach big values.=20
To avoid forking 2*msgmni processes and create msgmni msg queues, do not ta=
ke
msgmni from procfs anymore.
Just define it as 16 (which is the MSGMNI constant value in linux/msg.h)

Also fixed the Makefiles in ipc/lib and ipc/msgctl: there was no dependency
on the lib/ipc*.h header files.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/lib/Makefile
ltp/testcases/kernel/syscalls/ipc/lib/ipcmsg.h
ltp/testcases/kernel/syscalls/ipc/msgctl/Makefile
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl08.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl09.c

26) Log Message:
Here is a second round of cleanup and fixes for the realtime testcases.

1) Make sched_jitter use the create_fifo_thread() library function instead =
of an open coded solution,
2) Prio-wake calls rt_init() twice, remove the second call,
3) Make sbrk_mutex less verbose by default. One can still use the -v option=
 to get the whole output,
4) It's better to calculate the histogram before saving it. This was introd=
uced in an earlier commit of mine fixing the quantile calculation, 5) Fix r=
untime displaying of the min and max latencies (when used with -v3). While =
at it, remove an uneeded avg variable,
6) Various tests still have a hardcoded value for the quantile nines. Use a=
 value automatically calculated from the number of iterations,
7) The log10() call used for automatic quantile nines calculation returns a=
 double result. Cast it to an int. The exp10() call used in stats_quantiles=
_calc() for checking purposes returns a double result which is compared aga=
inst a long. Cast it to a long. This allows the following comparison: data-=
>size < (long)exp10(quantiles->nines) to really be false when quantiles->ni=
nes has been calculated as log10(data->size).
More generally, it seems that (at least with gcc 4.1.1):
        long i =3D 10000;
        double f =3D exp10(log10(i))

        yields (i < f) being true due to rounding,
8) Add latency tracing capability to pthread_kill_latency as is already don=
e on a few other latency tests (gtod_latency, sched_latency, ...),=20
9) The '::' optional argument specifier for getopt used by the '-v' option =
is a GNU extension, is not portable and does not work. For example it's not=
 even described in the Debian getopt(3) manpage. Make the '-v' option requi=
re a non optional argument,
10)The print buffer is only ever flushed when it is full. Add flushing when=
 the test terminates vi atexit(),
11)The 'period missed' check of the thread first loop should not depend on =
the thread starting time. This is especially visible on 'slow' platforms wh=
ere one cannot run the test if thread creation takes a long time. Fix it by=
 removing this dependency. All delays are now calculated relative to when t=
he thread starts,

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Tim Chavez <tinytim@us.ibm.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>
Acked-by: Chirag <chirag@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/gtod_latency/gtod_latency.c
ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
ltp/testcases/realtime/func/pi-tests/sbrk_mutex.c
ltp/testcases/realtime/func/pi_perf/pi_perf.c
ltp/testcases/realtime/func/prio-wake/prio-wake.c
ltp/testcases/realtime/func/pthread_kill_latency/pthread_kill_latency.c
ltp/testcases/realtime/func/sched_jitter/sched_jitter.c
ltp/testcases/realtime/func/sched_latency/sched_latency.c
ltp/testcases/realtime/lib/librttest.c
ltp/testcases/realtime/lib/libstats.c

27) Log Message: lcov: fixed problem with pre gcc-3.3 versions.
read_gcov_headers does not return valid results for pre gcc-3.3 versions. D=
ue to an unnecessary check, parsing of gcov files was aborted. Fix by remov=
ing check, by, Peter Oberparleiter <oberpapr@users.sourceforge.net>
Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo

28) Log Message: lcov: fix error when trying to use genhtml -b
genhtml fails when the data file contains an entry which is not found in th=
e base file, by, Peter Oberparleiter <oberpapr@users.sourceforge.net>
Modified File(s):
ltp/utils/analysis/lcov/bin/genhtml

29) Log Messaage: run_auto.sh file for realtime/func/pthread_kill_latency/t=
estcase got missed out in first release of realtime tests. This patch adds =
run_auto.sh for testcase which is required to run this particular test thro=
ugh top-level run script, by, sudhanshu <sudh@linux.vnet.ibm.com>
Added File(s):
ltp/testcases/realtime/func/pthread_kill_latency/run_auto.sh

30) Log Message: Since msgmni now scales to the memory size, it may reach b=
ig values. To avoid forking 2*msgmni processes and create msgmni msg queues=
, take the min between the procfs value and MSGMNI (as found in linux/msg.h=
).
Also integrated the following in libipc.a:
  . get_max_msgqueues()
  . get_used_msgqueues()
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Modified File(s):
ltp/testcases/kernel/syscalls/ipc/lib/ipcmsg.h
ltp/testcases/kernel/syscalls/ipc/lib/libipc.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl08.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl09.c
ltp/testcases/kernel/syscalls/ipc/msgget/Makefile
ltp/testcases/kernel/syscalls/ipc/msgget/msgget03.c
Added File(s):
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl10.c
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl11.c

31) Log Message: waitpid06.c uses a flag to detect whether something went w=
rong during the test. The issue is that this flag is not initialized, and I=
 get random failure reports. Other tests might suffer from the same bug, bu=
t I did not observe it yet. The enclosed patch fixes this in a trivial way =
for waitpid06. Surprisingly, with my debian package I never got the error, =
but when I compiled myself, by, Louis Rilling <Louis.Rilling@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid06.c

32) Log Message:
There are numerous cleanups, fixes and features went into our locally maint=
ained version of realtime tests, since its intergration in LTP december las=
t year. This patch merges those changes into LTP tree. The patch majorly co=
ntains :
- All features, cleanups and fixes done by IBM realtime team over last two
  month or so.
- Change in copyrights( year, symbil and limiting columns to 80 chars)
- Other few cleanups to ltp-realtime tests.
Signed-off-by : Sudhanshu Singh < sudh@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/GNUmakefile.am
ltp/testcases/realtime/run.sh
ltp/testcases/realtime/func/async_handler/async_handler.c
ltp/testcases/realtime/func/async_handler/async_handler_jk.c
ltp/testcases/realtime/func/async_handler/async_handler_tsc.c
ltp/testcases/realtime/func/gtod_latency/gtod_infinite.c
ltp/testcases/realtime/func/gtod_latency/gtod_latency.c
ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c
ltp/testcases/realtime/func/matrix_mult/matrix_mult.c
ltp/testcases/realtime/func/measurement/preempt_timing.c
ltp/testcases/realtime/func/measurement/rdtsc-latency.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c
ltp/testcases/realtime/func/pi-tests/parse-testpi1.py
ltp/testcases/realtime/func/pi-tests/parse-testpi2.py
ltp/testcases/realtime/func/pi-tests/run_auto.sh
ltp/testcases/realtime/func/pi-tests/sbrk_mutex.c
ltp/testcases/realtime/func/pi-tests/test-skeleton.c
ltp/testcases/realtime/func/pi-tests/testpi-0.c
ltp/testcases/realtime/func/pi-tests/testpi-1.c
ltp/testcases/realtime/func/pi-tests/testpi-2.c
ltp/testcases/realtime/func/pi-tests/testpi-4.c
ltp/testcases/realtime/func/pi-tests/testpi-5.c
ltp/testcases/realtime/func/pi-tests/testpi-6.c
ltp/testcases/realtime/func/pi-tests/testpi-7.c
ltp/testcases/realtime/func/pi_perf/pi_perf.c
ltp/testcases/realtime/func/prio-preempt/prio-preempt.c
ltp/testcases/realtime/func/prio-wake/prio-wake.c
ltp/testcases/realtime/func/pthread_kill_latency/pthread_kill_latency.c
ltp/testcases/realtime/func/sched_football/parse-football.py
ltp/testcases/realtime/func/sched_football/sched_football.c
ltp/testcases/realtime/func/sched_jitter/sched_jitter.c
ltp/testcases/realtime/func/sched_latency/sched_latency.c
ltp/testcases/realtime/func/thread_clock/tc-2.c
ltp/testcases/realtime/include/libjvmsim.h
ltp/testcases/realtime/include/librttest.h
ltp/testcases/realtime/include/libstats.h
ltp/testcases/realtime/include/list.h
ltp/testcases/realtime/lib/libjvmsim.c
ltp/testcases/realtime/lib/librttest.c
ltp/testcases/realtime/lib/libstats.c
ltp/testcases/realtime/perf/latency/pthread_cond_latency.c
ltp/testcases/realtime/perf/latency/pthread_cond_many.c
ltp/testcases/realtime/scripts/__init__.py
ltp/testcases/realtime/scripts/setenv.sh
ltp/testcases/realtime/stress/pi-tests/lookup_pi_state.c
ltp/testcases/realtime/stress/pi-tests/testpi-3.c
ltp/testscripts/test_realtime.sh

33) Log Message: waitpid07.c uses a flag to detect whether something went w=
rong during the test. The issue is that this flag is not initialized, and I=
 get random failure reports, by, Louis Rilling <Louis.Rilling@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid07.c

34) Log Message:
waitpid tests: Fix failure detection flag initialization.
On a similar pattern as waitpid06 and waitpid07, waitpid08-13 use a failure=
 detection flag (called 'fail' instead of 'flag'). However except in waitpi=
d09, this flag may be used uninitialized, which causes the test to randomly=
 report failure. This patch ensures that the flag is reset at the beginning=
 of each loop.
Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid08.c
ltp/testcases/kernel/syscalls/waitpid/waitpid10.c
ltp/testcases/kernel/syscalls/waitpid/waitpid11.c
ltp/testcases/kernel/syscalls/waitpid/waitpid12.c
ltp/testcases/kernel/syscalls/waitpid/waitpid13.c

35) Log Message:
waitpid03/04: Fix condition numbers displayed when reporting errors.
The condition numbers displayed while reporting errors in waitpid03 and wai=
tpid04 are used initialized and are not consistently updated, which may lea=
d to useless reports.
Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid03.c
ltp/testcases/kernel/syscalls/waitpid/waitpid04.c

36) Log Message:
waitpid02-05: remove unused defines related to failure handling. Signed-off=
-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid02.c
ltp/testcases/kernel/syscalls/waitpid/waitpid03.c
ltp/testcases/kernel/syscalls/waitpid/waitpid04.c
ltp/testcases/kernel/syscalls/waitpid/waitpid05.c

37) Log Message: Adding option to build TIMER test cases as well, by, Subra=
ta Modak <subrata@linux.vnet.ibm.com>
Modified File(s):
ltp/testcases/kernel/Makefile

38) Log Message: Removing these files as they get automatically generated d=
uring build, by, Max Stirling <vicky.irobot@gmail.com>
Deleted File(s):
ltp/testcases/ballista/ballista/MakefileHost
ltp/testcases/ballista/ballista/MakefileTarget

39) Log Message: Many tests cannot be executed concurrently. I have a few p=
atches to make it possible to execute some tests in parallel/concurrency, t=
o check SMP safeness, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/sendfile/sendfile02.c
ltp/testcases/kernel/syscalls/sendfile/sendfile04.c

40) Log Message: Fix NFS issues in tst_rmdir (directory non empty) due to a=
n unmapped file, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages02.c

41) Log Message: Fix a concurrency issue due to the (false) sharing of file=
 /dev/shm/cache. This patch just create a different file for each process a=
nd unlink the file before exiting, by, Renaud Lottiaux <Renaud.Lottiaux@ker=
labs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c

42) Log Message: The variable dfOpts (in #324) is seting to NULL even if th=
e df is not a symbolic link.(It has to be "-P" itself to get the output por=
table).And so the "df $dfOpts $dir" (line #326) command is not giving a res=
ult expected by the succeeding statements. I have tested this patch both in=
 lvm and fdisk partitions and found its working fine, by, Sudeesh John <sud=
eeshjohn@in.ibm.com>
Modified File(s):
ltp/testcases/kernel/fs/doio/rwtest.sh

43) Log Message:
CLOCK_PROCESS_CPUTIME_ID and CLOCK_THREAD_CPUTIME_ID are also supported bes=
ides CLOCK_REALTIME and CLOCK_MONOTONIC. That's the cause of the failure of=
 clock_gettime03, timer_create02 and timer_create04. Another cause is that =
struct sigevent evp is assigned with invalid values when option is 1. That'=
s the cause of the failure of timer_create02 and timer_create03. CLOCK_REAL=
TIME_HR and CLOCK_MONOTONIC_HR have been removed in the later kernel versio=
ns, hence the failures in the test. I am still trying to find out if any ke=
rnel versions used to support these. CLOCK_PROCESS_CPUTIME_ID and CLOCK_THR=
EAD_CPUTIME_ID are supported from 2.6.12 kernel version onwards and the tes=
t case needs to be modified for this change. Also in timer_create02.c, setu=
p_test() case1 needs to be modified so as to make evp NULL instead of its m=
embers. Since the testcase behaves differently for different kernel version=
s, a version check needs to be added for making it pass across versions. I'=
m removing the HR clocks from the tests along with other changes, by, Anoop=
 V. Chakkalakkal <anoop.vijayan@in.ibm.com>

Modified File(s):
ltp/testcases/kernel/timers/clock_gettime/clock_gettime03.c
ltp/testcases/kernel/timers/clock_settime/clock_settime03.c
ltp/testcases/kernel/timers/include/common_timers.h
ltp/testcases/kernel/timers/timer_create/timer_create02.c
ltp/testcases/kernel/timers/timer_create/timer_create03.c
ltp/testcases/kernel/timers/timer_create/timer_create04.c

44) Mog Message:
This patch -try- to cleanup the mem03 test and fix a concurrency problem. M=
ainly, the test creates and removes files in the current directory. Since t=
he tst_tmpdir() function was not used, several instances of the test was cr=
eating and removing files from each others !, by, Renaud Lottiaux <Renaud.L=
ottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/memmap/mem03.c

45) Log Message: The problem is that the kernel file is vmlinux* instead of=
 vmlinuz* on SLES, but file_test.sh always try to grep vmlinuz* under /boot=
/. Here is the patch and the test result with the patch, by, shenlinf <shen=
linf@cn.ibm.com>
Modified File(s):
ltp/testcases/commands/ade/file/file_test.sh

46) Log Message: Here is a patch fixing concurrency issue in mremap04. Just=
 use a shm key returned from the getipckey() function instead of a fixed ha=
rdcoded value, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>
Modified File(s):
ltp/testcases/kernel/syscalls/mremap/Makefile
ltp/testcases/kernel/syscalls/mremap/mremap04.c

47) Log Message:
LTP-kill05-bad-check-fix.patch:
  - Fix return value check from shmat. In case of error, this wrong check w=
as leading to a seg-fault.
LTP-kill05-shmid_delete-fix.patch:
 - Fix deletion of the memory segment. Due to the change of process UID dur=
ing the test, the segment was created by ROOT and deleted (or tried to be d=
eleted) by user "bin". This is of course not possible. And it is also impos=
sible to switch back uid to ROOT. Solution adopted : doing a fork in which =
the test is performed. The initial process staying with ROOT uid.
LTP-kill05-concurrency-fix.patch
 - Paranoia concurrency fix. I have not encounter any real issue, but it is=
 probably safer to be sure each process is using a different segment. -> us=
e tst_tmpdir, to make getipckey generating a different key for each running=
 process, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/kill/kill05.c

48) Log Message:
1) The pi-tests don't use the librttest infrastructure and simply duplicate=
 code. This patch ensures that those tests use librttest.
2) The thread-clock test doesn't use the librttest infrastructure. This pat=
ch ensures that it does.
3) Adds missing headers to the following files,
Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>,
Acked-By: Dinakar Guniguntala <dino@in.ibm.com>,
Acked-By: Sebastien Dugue <sebastien.dugue@bull.net>

Modified File(s):
ltp/testcases/realtime/func/pi-tests/parse-testpi1.py
ltp/testcases/realtime/func/pi-tests/parse-testpi2.py
ltp/testcases/realtime/func/pi-tests/sbrk_mutex.c
ltp/testcases/realtime/func/pi-tests/testpi-1.c
ltp/testcases/realtime/func/pi-tests/testpi-2.c
ltp/testcases/realtime/func/pi-tests/testpi-4.c
ltp/testcases/realtime/func/pi-tests/testpi-5.c
ltp/testcases/realtime/func/pi-tests/testpi-6.c
ltp/testcases/realtime/func/sched_football/parse-football.py
ltp/testcases/realtime/func/thread_clock/tc-2.c
ltp/testcases/realtime/scripts/parser.py


49) Log Message: Fixes a concurrency issue in shmat02. The second IPC key u=
sed in this test was generated doing a ++ on the first key. By doing this, =
it makes possible to get a conflict with a key generated by another process=
. To fix this, I just do a new call to getipckey() and check if the key is =
different from the previously generated one,
by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/shmat/shmat02.c

50) Log Message: Initial set of CPU CONTROLLER Test Cases. This patch creat=
es the framework for controllers testcases in LTP. This also creates the fi=
rst and second testcase for cpu controller and adds some documentation. Sig=
ned-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/kernel/Makefile
Added Files:
ltp/runtest/controllers
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/README
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/testplan.txt
ltp/testcases/kernel/controllers/cpuctl/Makefile
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_testplan.txt
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh
ltp/testcases/kernel/controllers/cpuctl/README

51) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the third testcase for cpu controller. Signed-off-by: Sudhir Kumar <skumar=
@linux.vnet.ibm.com>
Modified File(s):
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh

52) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the fourth testcase for cpu controller. Signed-off-by: Sudhir Kumar <skuma=
r@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh
Added Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c

53) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch chan=
ges the way parameters are passed from script to c file. Also does some cle=
anup. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh

54) Log Message: This patch adds the fourth and fifth testcases for cpu con=
troller (ie Nice value test and task migration test). Signed-off-by: Sudhir=
 Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh

55) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This test remov=
es the common shell functions from run scripts and puts them into a separat=
e file parameters.sh. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.co=
m>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/Makefile
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh
Added Files:
ltp/testcases/kernel/controllers/cpuctl/parameters.sh

56) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the sixth to eigth testcase for cpu controller. These are the stress test =
cases. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/Makefile
Added Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test03.c
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_stress_test.sh

57) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the ninth testcase (stress) for cpu controller. Signed-off-by: Sudhir Kuma=
r <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/parameters.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_stress_test.sh
Added Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c

58) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the tenth testcase(stress) for cpu controller. Signed-off-by: Sudhir Kumar=
 <skumar@linux.vnet.ibm.com>
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_stress_test.sh

59) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 a library for cpu controller testing. The library contains the common func=
tions used by all test cases. These functions will be further used in testc=
ases for memory controller also. In addition to the library code this patch=
 also contains the changes required to call and use library functions in te=
stcase 1(2). Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/Makefile
ltp/testcases/kernel/controllers/cpuctl/Makefile
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
Added Files:
ltp/testcases/kernel/controllers/libcontrollers/Makefile
ltp/testcases/kernel/controllers/libcontrollers/libcontrollers.c
ltp/testcases/kernel/controllers/libcontrollers/libcontrollers.h

60) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the library routines in cpu controller test case 3. Signed-off-by: Sudhir =
Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c

61) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the library routines in cpu controller test case 4th and 5th. It also does=
 minor cleanup. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c

62) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the library routines in cpu controller stress test cases 1,2 &3. It also d=
oes minor cleanup. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test03.c

63) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the library routines in cpu controller stress test cases 4 & 5. It also do=
es minor cleanup. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c

64) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch does=
 some cleanup. Signed-off-by: Sudhir Kumar <skumar@linux.vnet.ibm.com>
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test03.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c
ltp/testcases/kernel/controllers/cpuctl/parameters.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_stress_test.sh
ltp/testcases/kernel/controllers/cpuctl/run_cpuctl_test.sh

65) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the documentation for cpu controller test cases. Signed-off-by: Sudhir Kum=
ar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/testcases/kernel/controllers/README
ltp/testcases/kernel/controllers/testplan.txt
ltp/testcases/kernel/controllers/cpuctl/README
ltp/testcases/kernel/controllers/cpuctl/cpuctl_testplan.txt

66) Log Message: Initial Set of CPU CONTROLLERS Test Cases. This patch adds=
 the cpu controller test cases to the LTP default run list. Signed-off-by: =
Sudhir Kumar <skumar@linux.vnet.ibm.com>
Modified Files:
ltp/runltp

67) Log Message:
This patch fixes the testcases mismerge due to the patch "There are numerou=
s cleanups, fixes and features went into our ..." from Sudhanshu Singh. Tur=
ned out there was less damage than I thought. Hopefully, it should restore =
the fixes and cleanups which were reverted before the February Release.=20
Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Sudhanshu Singh < sudh@linux.vnet.ibm.com>
Cc: Chirag <chirag@linux.vnet.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/pi_perf/pi_perf.c
ltp/testcases/realtime/func/sched_football/sched_football.c
ltp/testcases/realtime/func/sched_latency/sched_latency.c

--=-1Gn8eIB3S4GaF1lj4XlC--

