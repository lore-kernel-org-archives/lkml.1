Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZJFNx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZJFNx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZJFNx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:53:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59361 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZJFNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:53:53 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for SEPTEMBER
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miao Xie <miaox@cn.fujitsu.com>, Shan Wei <shanwei@cn.fujitsu.com>,
       Kiran Prakash <kiran@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Cyril Hrubis <chrubis@suse.cz>,
       Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>,
       Hushan Jia <hjia@redhat.com>,
       Zhang Xiliang <zhangxiliang@cn.fujitsu.com>,
       Naresh Kamboju <naresh.kernel@gmail.com>,
       Suzuki K P <suzuki@in.ibm.com>, JACKY MALCLES <Jacky.Malcles@bull.net>,
       Liu Bo <liubo-fnst@cn.fujitsu.com>,
       Nobuhiro Lin <nobuhiro@andestech.com>,
       Shi Weihua <shiwh@cn.fujitsu.com>,
       Sharyathi Nagesh <sharyath@in.ibm.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       Matthieu Fertr <Matthieu.Fertre@kerlabs.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Jiri Palecek <jpalecek@web.de>,
       Andrew Vagin <avagin@gmail.com>
Content-Type: multipart/mixed; boundary="=-3gOVKS1U1KPLpJuL9RkP"
Organization: IBM
Date: Tue, 06 Oct 2009 19:22:23 +0530
Message-Id: <1254837145.4915.22.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3gOVKS1U1KPLpJuL9RkP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

The Linux Test Project test suite has been released for the month of
SEPTEMBER 2009. Please see ltp/INSTALL file carefully, as, there has
been multiple changes for building/installing the test suite.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
SEPTEMBER 2009 Highlights:
======================== 
     1. rt-migrate-test addition, 
     2. Addition of 38 scenarios for CGROUP functional tests and Stress
        tests, 
     3. Addition of testcase for p9auth kernel module, 
     4. Major fixes to LCOV to work with 2.6.32 kernel,
------------------------------

==============================
SEPTEMBER 2009 LTP Contributors:
============================== 
     1. Miao Xie, 
     2. Shan Wei, 
     3. Kiran Prakash, 
     4. Steven Rostedt, 
     5. Cyril Hrubis, 
     6. Seiichi Ikarashi, 
     7. Hushan Jia, 
     8. Zhang Xiliang, 
     9. Naresh Kamboju, 
    10. Suzuki K P, 
    11. JACKY MALCLES, 
    12. Liu Bo, 
    13. Nobuhiro Lin, 
    14. Shi Weihua, 
    15. Sharyathi Nagesh, 
    16. Geert Uytterhoeven, 
    17. Peter Oberparleiter, 
    18. Matthieu Fertr, 
    19. Serge E. Hallyn, 
    20. Jiri Palecek, 
    21. Andrew Vagin,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
September continued to be the month when we received many new tests. And
we are looking to see the exclusive EXT4 tests to come in October 2009
release. People from the community showed extreme enthusiasm to clean
the recently ported tests from Crackerjack. This shows how LTP community
uses the System call tests so heavily.

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

--=-3gOVKS1U1KPLpJuL9RkP
Content-Disposition: attachment; filename=September-2009_Changelog.txt
Content-Type: text/plain; name=September-2009_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
controller: fix the bug of missing compilation for controller cases: When d=
oing "./configure && make", I found the controller cases couldn't be compil=
ed. Because the config.mk file included into testcases/kernel/Makefile lost=
 the definition of LTP_CHECK_CGROUPSTATS_HEADER, so ltp never enters the co=
ntroller directory to do "make". And config.mk file is created by config.mk=
.in file in fact. In config.mk.in, LTP_CHECK_CGROUPSTATS_HEADER is lost, it=
 leads to the wrong config.mk. Add LTP_CHECK_CGROUPSTATS_HEADER in config.m=
k.in to fix the problem. Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>, Si=
gned-off-by: Shan Wei <shanwei@cn.fujitsu.com>.

Modified File(s):
ltp/config.mk.in

2) Log Message:
Patch to change the format of Steve Rostedt's rt-migrate-test testcase: Thi=
s patch converts the testcase rt-migrate-test.c to the coding format used b=
y the other realtime testcases in LTP, by making use of the librttest and l=
ibstats infrastructure. Signed-off-by: Kiran Prakash <kiran@linux.vnet.ibm.=
com>, Acked-by: Darren Hart <dvhltc@us.ibm.com>, Acked-by: Sripathi Kodi <s=
ripathik@in.ibm.com>. Originally-contributed-by: Steven Rostedt <rostedt@go=
odmis.org>,

Modified Files:
ltp/testcases/realtime/func/Makefile
ltp/testcases/realtime/profiles/default
Added Files:
ltp/testcases/realtime/func/rt-migrate/Makefile
ltp/testcases/realtime/func/rt-migrate/rt-migrate.c
ltp/testcases/realtime/func/rt-migrate/run_auto.sh

3) Log Message:
Formatting and ftest cleanup: This is first part of testcases/kernel/fs/fte=
st/ cleanup. It fixes printf like formatting in pidns20.c and growfiles.c a=
s well as huge number of bugs and code formatting issues in ftest01.c ftest=
02.c and ftest03.c. Signed-off-by: Cyril Hrubis <chrubis@suse.cz>.=20

Modified Files:
ltp/testcases/kernel/containers/pidns/pidns20.c
ltp/testcases/kernel/fs/doio/growfiles.c
ltp/testcases/kernel/fs/ftest/ftest01.c
ltp/testcases/kernel/fs/ftest/ftest02.c
ltp/testcases/kernel/fs/ftest/ftest03.c

4) Log Message:
Fix UNRESOLVED failures of pthread tests in open_posix_testsuite: I report =
a couple of "UNRESOLVED" failures of open_posix_testsuite in ltp and send a=
 patch for them. I got following failures while executing open_posix_testsu=
ite: Both of them have wrong steps of its test preparation:
  1. register signal handlers (just do sem_post()) for SIGUSR1/SIGUSR2.
  2. block those signals
  3. prepare something (sem_init()) for these signal handlers
  4. send signals to itself from sub-threads.
They have a window of not-yet-prepared-for-signals between step 1 and 2. I =
think above "UNRESOLVED" failures (sem_post() before sem_init()) are the re=
sult of getting a signal during this window. I don't know who sent a signal=
 to them but I guess neighboring tests are suspects, because number of test=
s run concurrently in open_posix_testsuite.  The fix shall be just delaying=
 step 1 to between step 2 and 4, so I wrote such a patch for both pthread_s=
etschedparam and pthread_detach. I have confirmed that this UNRESOLVED fail=
ure disappeared with this patch applied. Signed-off-by: Seiichi Ikarashi <s=
.ikarashi@jp.fujitsu.com>.

Modified Files:
ltp/testcases/open_posix_testsuite/conformance/interfaces/pthread_detach/4-=
3.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/pthread_setschedp=
aram/5-1.c

5) Log Message:
Network: Fix iproute test case error: When I run network test case testcase=
s/network/iproute/ip_tests.sh, some errors shown:=20
ip01        0  TINFO  :  Test #1: changing mtu size of eth0:1 device.
/mnt/ltp/ltp-full-20090731/testcases/bin/ip_tests.sh: line 198: [: -eq: una=
ry operator expected.
The output of=20
ifconfig eth0:1 | grep -i MTU | sed "s/^.*MTU://"
is like:
1500  Metric:1
so should print field 1 instead of field 5. Signed-off-by: Hushan Jia<hjia@=
redhat.com>.

Modified Files:
ltp/testcases/network/iproute/ip_tests.sh

6) Log Message:
mbind01: Fix the bug of result output: I tested ltp mbind case and found th=
e result is error as follows:
mbind01     0  TINFO  :  (case00) START
EXPECT: return value(ret)=3D0 errno=3D0 (Success)
RESULT: return value(ret)=3D0 errno=3D0 (Success)
mbind01     0  TINFO  :  (case00) END =3D> OK
mbind01     0  TINFO  :  (case01) START
EXPECT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
RESULT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
mbind01     0  TINFO  :  (case01) END =3D> NG
mbind01     0  TINFO  :  (case02) START
EXPECT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
RESULT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
mbind01     0  TINFO  :  (case02) END =3D> NG
mbind01     0  TINFO  :  (case03) START
EXPECT: return value(ret)=3D0 errno=3D0 (Success)
RESULT: return value(ret)=3D0 errno=3D0 (Success)
mbind01     0  TINFO  :  (case03) END =3D> OK
mbind01     0  TINFO  :  (case04) START
EXPECT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
RESULT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
mbind01     0  TINFO  :  (case04) END =3D> NG
mbind01     0  TINFO  :  (case05) START
EXPECT: return value(ret)=3D0 errno=3D0 (Success)
RESULT: return value(ret)=3D0 errno=3D0 (Success)
mbind01     0  TINFO  :  (case05) END =3D> OK
mbind01     0  TINFO  :  (case06) START
EXPECT: return value(ret)=3D0 errno=3D0 (Success), r/w check=3DOK
RESULT: return value(ret)=3D0 errno=3D0 (Success), r/w check=3DNG
mbind01     0  TINFO  :  (case06) END =3D> OK
mbind01     0  TINFO  :  (case07) START
EXPECT: return value(ret)=3D0 errno=3D0 (Success)
RESULT: return value(ret)=3D0 errno=3D0 (Success)
mbind01     0  TINFO  :  (case07) END =3D> OK
mbind01     0  TINFO  :  (case08) START
EXPECT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
RESULT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
mbind01     0  TINFO  :  (case08) END =3D> NG
mbind01     0  TINFO  :  (case09) START
EXPECT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
RESULT: return value(ret)=3D-1 errno=3D22 (Invalid argument)
mbind01     0  TINFO  :  (case09) END =3D> NG
mbind01     0  TINFO  :  (case10) START
mbind01     1  TFAIL  :  get_mempolicy failed - errno =3D 14 : Bad address

In case01,case02,case04,case08,case09, the expect is same with the result. =
So these cases should be OK instead of NG. In sourse code, TEST_RETURN shou=
ld get value by "ret".By the way, the "switch/case RESULT_OK" missed "break=
". Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/mbind/mbind01.c

7) Log Message:
mbind01: Fix the bug of mind case06: I tested ltp mbind case and found the =
case06 failed. In mbind manual, it says "If the nodemask and maxnode argume=
nts specify the empty set, then the memory is allocated on the node of the =
CPU that triggered the allocation." In case06, when tc->policy is MPOL_PREF=
ERRED and tc->from_node is NONE, the getnodemask which is get by get_mempol=
icy() refer to the node of the CPU that triggered the allocation. But the n=
odemask is zero.(It is not used by mbind(), mbind() used "NULL".). So in th=
is case, the cmp_ok should only compare the policy. Signed-off-by: Zhang Xi=
liang <zhangxiliang@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/mbind/mbind01.c

8) Log Message:
mbind01: Fix the bug of mind case10: I tested ltp mbind01 case and found th=
e case10 failed. In case10, the expect errno is EFAULT. In mbind manual, it=
 says "EFAULT Part or all of the memory range specified by nodemask and max=
node points outside your accessible address space.". So the case should use=
 invalid "nodemask" instead of invalid "p" to test. Signed-off-by: Zhang Xi=
liang <zhangxiliang@cn.fujitsu.com>.

Modified Files:
ltp/testcases/kernel/syscalls/mbind/mbind01.c

9) Log Message:
LTP-LDFLAGS-enable: To make use of full testsuite of open_posix_testsuite w=
e need to enable LDFLAGS. It is file used by the Makefile to link to what y=
ou specify in it. e.g. if you want to link with lpthread. By using these Fl=
ags can build up to 1888 test case with out the flags can build up to 486. =
However, the Best practice is to use posix test suite with the LDFLAGS. I h=
ave attached patch and below, please review the same.
/************************************************************/
Before patch: With out LDFLAGS:
                ***************************
                 CONFORMANCE TEST RESULTS
                ***************************
                * TOTAL:   486
                * PASSED:  449
                * FAILED:  12
                * UNRESOLVED:  7
                * UNSUPPORTED:  10
                * UNTESTED:  4
                * INTERRUPTED:  0
                * HUNG:  0
                * SEGV:  0
                * OTHERS:  4
                ***************************
After patch: With LDFLAGS:
                ***************************
                 CONFORMANCE TEST RESULTS
                ***************************
                * TOTAL:   1888
                * PASSED:  1731
                * FAILED:  26
                * UNRESOLVED:  14
                * UNSUPPORTED:  22
                * UNTESTED:  94
                * INTERRUPTED:  0
                * HUNG:  1
                * SEGV:  0
                * OTHERS:  0
                ***************************
/************************************************************/
Signed-off-by: Naresh Kamboju <naresh.kernel@gmail.com>.

Modified Files:
ltp/testcases/open_posix_testsuite/LDFLAGS

10) Log Message:
Add autoconf tests for taskstats members not present on older kernels: this=
 is cleaned version of previously posted patch. Signed-off-by: Cyril Hrubis=
 <chrubis@suse.cz>.=20

Modified Files:
ltp/testcases/kernel/controllers/cgroup/getdelays.c

11) Log Message:
gen_fork() event should wait until the child exits. Otherwise the child wou=
ld see INIT as the parent and end up in collecting wrong information to com=
pare with. Signed-off-by: Suzuki K P <suzuki@in.ibm.com>, Acked-by: Li Zefa=
n <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/connectors/pec/event_generator.c

12) Log Message:
runltp can not run acl_test01 by default, we need a mounted partition with =
ACL options. To have acl_test01 started by runltp (or manually) without any=
 acl aware partition,  if you agree I suggest the following patch: a kind o=
f new setup and at the same time the activation of a non root user. Signed-=
off-by: JACKY MALCLES <Jacky.Malcles@bull.net>.

Modified Files:
ltp/testcases/kernel/fs/acls/acl_test01

13) Log Message:
cpuctl of controllers: fix the bug of while loop: When running the ltp tool=
 by "./runltp -f controllers", I found "while" loop cannot stop in followin=
g files of cpuctl test. File list:
cpuctl_def_task01.c
cpuctl_def_task02.c
cpuctl_def_task03.c
cpuctl_def_task04.c
cpuctl_test01.c
cpuctl_test02.c
cpuctl_test03.c
cpuctl_test04.c

Key code:
timer_expired=3D0;
while(!timer_expired)
        f=3Dsqrt(f*f);

Reason:
During the compilation of these files, gcc's O2 mechanism causes the change=
 of variable "timer_expired" to be omitted, hence the loop, "while(!timer_e=
xpired) f=3Dsqrt(f*f);" cannot get out from itself. Change the type of "tim=
er_expired" from "int" to "volatile int" to fix this bug. By the way, it is=
 necessary to modify the file, ltp-full-xxxxxxxx/testcases/kernel/controlle=
rs/libcontrollers/ libcontrollers.h for compilation. Signed-off-by: Miao Xi=
e <miaox@cn.fujitsu.com>, Signed-off-by: Liu Bo <liubo-fnst@cn.fujitsu.com>=
,

Modified Files:
ltp/testcases/kernel/controllers/cpuctl/cpuctl_def_task01.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_def_task02.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_def_task03.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_def_task04.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test01.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test02.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test03.c
ltp/testcases/kernel/controllers/cpuctl/cpuctl_test04.c
ltp/testcases/kernel/controllers/libcontrollers/libcontrollers.h

14) Log Message:
After trying to find old enough glibc (2.2.2 and older) in any distribution=
 I've given up modifying the test to compile with non glibc epoll library. =
So when glibc epoll headers are not found the test is disabled entirely and=
 dummy version of the test is compiled. Patch that also fixes some minor pr=
oblems is attached. Signed-off-by: Cyril Hrubis <chrubis@suse.cz>.

Modified Files:
ltp/configure.ac
ltp/testcases/kernel/syscalls/epoll/Makefile
ltp/testcases/kernel/syscalls/epoll/epoll-ltp.c

15) Log Message:
network: Fix ip_tests error 2: Repost the ip tests patch:
1. Test #4: ip tools now print nud state as follows: REACHABLE, STALE, FAIL=
ED, etc,
2. Test #3, #4, #5: If delete entry succefully, grep will return 1, indicat=
ing test PASS, so return code RC should be set to 0,
Signed-off-by: Hushan Jia <hjia@redhat.com>,

Modified Files:
ltp/testcases/network/iproute/ip_tests.sh

16) Log Message:
network: fix multicast testcases Makefile: Repost the multicast Makefile pa=
tch: The Makefile of testcases/network/multicast/mc_commo and mc_member do =
not link binary file and config files to ../../../bin dirs. This patch add =
the links. Signed-off-by: Hushan Jia<hjia@redhat.com>,

Modified Files:
ltp/testcases/network/multicast/mc_commo/Makefile
ltp/testcases/network/multicast/mc_member/Makefile

17) Log Message:
pselect01: Fixed the checking logic to also consider some variation: Someti=
mes we may get failed results that the measured time is 1 second longer tha=
n expected. As fixed by Craig Meier earlier, the sleeps may last slightly m=
ore than total_sec. Also considering the time() overhead, we should expect =
the sleeps to last between total_sec and (total_sec+1) seconds. Signed-off-=
by: Nobuhiro Lin <nobuhiro@andestech.com>,

Modified Files:
ltp/testcases/kernel/syscalls/pselect/pselect01.c

18) Log Message:
Add new testcases for memcgroup: My workmate Li Zefan (lizf@cn.fujitsu.com)=
 has created some testcases for cgroup's subsystem "memory" in the last yea=
r. And, He catched some kernel bugs through these testcases. So we think yo=
u glad to push them into LTP. There are total 40 testcases that have been a=
dded. These testcases contain the basis operation test, part functionality =
test and stress test of memcgroup. How to run this test: # runltp -f contro=
llers.
Result:
memcgroup_function_test    1  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test    2  TPASS  :  rss=3D0/0, cache=3D4096/4096
memcgroup_function_test    3  TPASS  :  rss=3D0/0, cache=3D4096/4096
memcgroup_function_test    4  TPASS  :  rss=3D4096/4096, cache=3D8192/8192
memcgroup_function_test    5  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test    6  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test    6  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test    7  TPASS  :  rss=3D0/0, cache=3D4096/4096
memcgroup_function_test    7  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test    8  TPASS  :  rss=3D0/0, cache=3D4096/4096
memcgroup_function_test    8  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test    9  TPASS  :  rss=3D4096/4096, cache=3D8192/8192
memcgroup_function_test    9  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test   10  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test   10  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test   11  TPASS  :  failcnt=3D6
memcgroup_function_test   12  TPASS  :  failcnt=3D6
memcgroup_function_test   13  TPASS  :  failcnt=3D6
memcgroup_function_test   14  TPASS  :  process 5793 is killed
memcgroup_function_test   15  TPASS  :  process 5803 is killed
memcgroup_function_test   16  TPASS  :  process 5813 is killed
memcgroup_function_test   17  TPASS  :  process 5824 is killed
memcgroup_function_test   18  TPASS  :  process 5835 is killed
memcgroup_function_test   19  TPASS  :  process 5845 is killed
memcgroup_function_test   20  TPASS  :  process 5854 is killed
memcgroup_function_test   21  TPASS  :  process 5863 is killed
memcgroup_function_test   22  TPASS  :  input=3D4095, limit_in_bytes=3D4096
memcgroup_function_test   23  TPASS  :  input=3D4097, limit_in_bytes=3D8192
memcgroup_function_test   24  TPASS  :  input=3D1, limit_in_bytes=3D4096
memcgroup_function_test   25  TPASS  :  return value is 0
memcgroup_function_test   26  TPASS  :  return value is 1
memcgroup_function_test   27  TPASS  :  return value is 1
memcgroup_function_test   28  TPASS  :  return value is 1
memcgroup_function_test   29  TPASS  :  force memory succeeded
memcgroup_function_test   30  TPASS  :  force memory failed as expected
memcgroup_function_test   31  TPASS  :  return value is 0
memcgroup_function_test   32  TPASS  :  return value is 0
memcgroup_function_test   33  TPASS  :  return value is 0
memcgroup_function_test   34  TPASS  :  return value is 0
memcgroup_function_test   35  TPASS  :  return value is 1
memcgroup_function_test   36  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test   36  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test   37  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test   37  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_function_test   38  TPASS  :  rss=3D4096/4096, cache=3D0/0
memcgroup_function_test   38  TPASS  :  rss=3D0/0, cache=3D0/0
memcgroup_stress_test      1  TPASS  :  stress test 1 passed
memcgroup_stress_test      2  TPASS  :  stress test 2 passed
INFO: ltp-pan reported all tests PASS,
Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>,

Modified Files:
ltp/runtest/controllers
ltp/testcases/kernel/controllers/memcg/Makefile
ltp/testcases/kernel/controllers/memcg/README
Added Files:
ltp/testcases/kernel/controllers/memcg/functional/Makefile
ltp/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
ltp/testcases/kernel/controllers/memcg/functional/memcg_getpagesize.c
ltp/testcases/kernel/controllers/memcg/functional/memcg_process.c
ltp/testcases/kernel/controllers/memcg/regression/Makefile
ltp/testcases/kernel/controllers/memcg/regression/memcg_regression_test.sh
ltp/testcases/kernel/controllers/memcg/regression/memcg_test_1.c
ltp/testcases/kernel/controllers/memcg/regression/memcg_test_2.c
ltp/testcases/kernel/controllers/memcg/regression/memcg_test_4.c
ltp/testcases/kernel/controllers/memcg/regression/memcg_test_4.sh
ltp/testcases/kernel/controllers/memcg/stress/Makefile
ltp/testcases/kernel/controllers/memcg/stress/memcg_process_stress.c
ltp/testcases/kernel/controllers/memcg/stress/memcg_stress_test.sh
Removed Files:
ltp/testcases/kernel/controllers/memcg/memcg_regression_test.sh
ltp/testcases/kernel/controllers/memcg/memcg_test_1.c
ltp/testcases/kernel/controllers/memcg/memcg_test_2.c
ltp/testcases/kernel/controllers/memcg/memcg_test_4.c
ltp/testcases/kernel/controllers/memcg/memcg_test_4.sh

19) Log Message:
fix the bug of macro in getdelays.c: When running cgroup test, I found a bu=
g of macro in getdelays.c, which refers to the spelling mistake. And this l=
eads to testcase_eight's abnormal delay. Relative macro:
        HAVE_LINUX_CGROUPSTATS_H
Change macro HAVE_LINUX_CGROUPSTAT_H to HAVE_LINUX_CGROUPSTATS_H to fix the=
 bug. Signed-off-by:Liu Bo <liubo-fnst@cn.fujitsu.com>,

Modified Files:
ltp/testcases/kernel/controllers/cgroup/getdelays.c

20) Log Message:
I propose two patches (two patterns of fix) for an issue of open_posix_test=
suite. I hope either one of them (or more better one someone will write) is=
 committed. You need to do three steps below in order to run execute.sh of =
open_posix_testsuite:
 1) make build-tests
 2) cc -O2 -o t0 t0.c
 3) ./execute.sh
I think it's better to include step 2 into step 1 or 3 for convenience. So =
I wrote two different patches for these cases. Signed-off-by: Seiichi Ikara=
shi <s.ikarashi@jp.fujitsu.com>,

Modified Files:
ltp/testcases/open_posix_testsuite/Makefile

21) Log Message:
Issue observed with chmod05, fchmod05 test  cases: This Patch fixes bug in =
the test cases chmod05.c and fchmod05.c. The test case uses 2 UserIds nobod=
y and bin. The issue is observed when one of the UserId is the supplementar=
y group Ids of the rooti (either nobody or bin). In that case the Posix sta=
ndard mentions that S_IGSID bit should not be cleared by the systemcall, ch=
mod() or fchmod(), which causes the test to fail. This patch fixes the issu=
e by specifically clearing the supplementary group ID of the process. The m=
ain intention of the test case is to test if S_IGSID bit is cleared in case=
 the non privilage user tries to set file modes. Hence felt clearing the su=
pplementary group Ids is the best way to fix the issue. At the same time I =
am reverting the earlier patch submitted by Wei Yongjun <yjwei@cn.fujitsu.c=
om>. Signed-off-by: Sharyathi Nagesh <sharyath@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/chmod/chmod05.c
ltp/testcases/kernel/syscalls/fchmod/fchmod05.c

22) Log Message:
quotactl01: Fix tst_resm() format causing crash: When the quotactl syscall =
fails, quotactl01 crashes with a segmentation fault due to an incorrect pri=
ntf()-style format. Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@s=
onycom.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/quotactl/quotactl01.c

23) Log Message:
quotactl01: Replace hardcoded 258 by __NR_set_tid_address: The call signatu=
re seems to match the set_tid_address() syscall. Also remove the comment ab=
out calling quotactl, as it's obviously bogus. Signed-off-by: Geert Uytterh=
oeven <Geert.Uytterhoeven@sonycom.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/quotactl/quotactl01.c

24) Log Message:
Spelling fixes: inclue -> include: Signed-off-by: Geert Uytterhoeven <Geert=
.Uytterhoeven@sonycom.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/utimensat/utimensat_tests.sh

25) Log Message:
Numa-testcases: Return TCONF if NUMA is not available: Currently the test j=
ust fails if NUMA is not available. Signed-off-by: Geert Uytterhoeven <Geer=
t.Uytterhoeven@sonycom.com>.

Modified File(s):
ltp/testcases/kernel/numa/numa01.sh

26) Log Message:
smt_smp: Return TCONF if SMT/SMP is not supported: Currently the tests just=
 fails if SMT/SMP is not supported. Signed-off-by: Geert Uytterhoeven <Geer=
t.Uytterhoeven@sonycom.com>.

Modified File(s):
ltp/testcases/kernel/sched/hyperthreading/ht_affinity/smt_smp_affinity.sh
ltp/testcases/kernel/sched/hyperthreading/ht_enabled/smt_smp_enabled.sh

27) Log Message:
Filecaps: Return TCONF if file capabilities are not supported: Currently th=
e test just fails if file capabilities are not supported. Signed-off-by: Ge=
ert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>.

Modified File(s):
ltp/testcases/kernel/security/filecaps/filecapstest.sh

28) Log Message:
The following patch avoids that all kill07 test instances running concurren=
tly work with the same SHM object. Signed-off-by: Matthieu Fertr <Matthieu.=
Fertre@kerlabs.com>.

Modified Files:
ltp/testcases/kernel/syscalls/kill/kill07.c

29) Log Message:
ftest cleanup II: this is ftest cleanup part II. Most of the functions that=
 were copy & pasted again and again in every file are now in libftest libra=
ry. Also ftest04, ftest05, ftest06, ftest07 and ftest08 are cleaned. Signed=
-off-by: Cyril Hrubis <chrubis@suse.cz>.

Modified Files:
ltp/include/compiler.h
ltp/testcases/kernel/fs/ftest/Makefile
ltp/testcases/kernel/fs/ftest/ftest01.c
ltp/testcases/kernel/fs/ftest/ftest02.c
ltp/testcases/kernel/fs/ftest/ftest03.c
ltp/testcases/kernel/fs/ftest/ftest04.c
ltp/testcases/kernel/fs/ftest/ftest05.c
ltp/testcases/kernel/fs/ftest/ftest06.c
ltp/testcases/kernel/fs/ftest/ftest07.c
ltp/testcases/kernel/fs/ftest/ftest08.c
Added Files:
ltp/testcases/kernel/fs/ftest/libftest.c
ltp/testcases/kernel/fs/ftest/libftest.h

30) Log Message:
lcov: remove default for gcov_dir so that auto-sensing works. Fix problem w=
ith lcov not finding kernel coverage data at /sys/kernel/debug/gcov because=
 the default system-wide lcovrc file contained a specification for the gcov=
 directory which prevented auto-detection from working.

Modified File(s):
ltp/utils/analysis/lcov/lcovrc

31) Log Message:
Create testcase for p9auth kernel module: The p9auth module is a driver in =
the staging/ directory, which implements kernel functionality supporting pl=
an 9-style setuid. Programs can be completely unprivileged, authorize thems=
elves to a privileged server, and obtain a token which they can use to auth=
orize a single setuid to a single specified new uid. This testcase runs thr=
ee tests:
1. make sure we can't setuid without a hash (this is actually short-cut in =
the kernel code so it might be worthwhile having a separate test for having=
 a hash, but an invalid one),
2. make sure we can setuid when there is a valid hash,
3. make sure we cannot setuid if there is a valid hash, but our original ui=
d isn't the one specified in the token.
Changelog:
Sep 21: Comment README, add runp9auth.sh to the patch, and add the openssl =
check to checkp9auth.sh. Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>.=
=20

Modified Files:
ltp/README
ltp/testcases/kernel/security/Makefile
Added Files:
ltp/runtest/p9auth
ltp/testcases/kernel/security/p9auth/Makefile
ltp/testcases/kernel/security/p9auth/checkp9auth.sh
ltp/testcases/kernel/security/p9auth/p9priv.sh
ltp/testcases/kernel/security/p9auth/p9unpriv.sh
ltp/testcases/kernel/security/p9auth/runp9auth.sh
ltp/testcases/kernel/security/p9auth/unhex.c

32) Log Message:
To test consolidation resets when interfaces are set to 0: CPU consolidatio=
n testcase modified to test when sched_mc &(/) sched_smt is set to Zero pro=
cesses dont consolidate to single package or CPU. Signed-off-by: poornima n=
ayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/cpu_consolidation.py

33) Log Message:
To fix issue in get_sched_values: get_sched_values was returning 1 & 0 inst=
ead of max sched_mc & max sched_smt. This patch fixes the issue in the firs=
t version of this file. Signed-off-by: poornima nayak <mpnayak@linux.vnet.i=
bm.com>.

Modified Files:
ltp/testcases/kernel/power_management/get_sched_values.c

34) Log Message:
To incorporate changes in reusable function: ILB testcase uses trigger work=
load to pin a task to CPU. This patch is to incorporate the changes in the =
prototype of function testcase invokes to trigger workload. Signed-off-by: =
poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/ilb_test.py

35) Log Message:
To include Additional 5 new test cases: Additional 5 new testcases to test =
cpu consolidation resets when sched_smt &(/) sched_mc is reset to zero. Sig=
ned-off-by: poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/runpwtests.sh

36) Log Message:
Modified library functions based on review comments. Signed-off-by: Poornim=
a Nayak <mpnayak@linux.vnet.ibm.com>.=20

Modified Files:
ltp/testcases/kernel/power_management/pm_include.sh

37) Log Message:
Modified python functions based on requirement for new testcase: Fixed some=
 issues that affect verification code of new test scenarios. Signed-off-by:=
 poornima nayak <mpnayak@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/power_management/lib/sched_mc.py

38) Log Message:
lcov: fix problem with CONFIG_MODVERSIONS, Make geninfo work with Linux 2.6=
.31 and CONFIG_MODVERSIONS, Signed-off-by: Peter Oberparleiter <oberpapr@us=
ers.sourceforge.net>,

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo

39) Log Message:
network: fix nfs testcases Makefile error: The nfslock01 and nfsstress test=
cases' Makefile does not link excutables to testcase/bin directory, and nfs=
lock01 does not build nfs_flock_dgen excutables, which will cause test fail=
. This patch add the links and build the nfs_flock_dgen. Signed-off-by: Hus=
han Jia <hjia@redhat.com>.

ltp/testcases/network/nfs/nfslock01/Makefile
ltp/testcases/network/nfs/nfsstress/Makefile

40) Log Message:
Add a count parameter to create_sig_proc: there were complaints about some =
tests (ppoll01) hanging sometimes. I've created this patch to address the i=
ssue. This should allow testing inherently racy conditions, such as a sysca=
ll returning EINTR upon signal handler execution. The problem here is that =
the signal could actually arrive before the syscall gets executed, which re=
sults in the test waiting for it forever. The solution is adding a paramete=
r that would allow to specify how much signals a particular test expects - =
a racy test would ask for a large number of signals sent, so it will get on=
e even if some were missed. Tests, which test behavior, which is not racy (=
eg. pselect()) should only request a single signal. Note that you need to m=
anually kill the child process delivering the signals when you don't need t=
hem, if you ordered more signals than you actually handle. Also, this patch=
 resets signal handling in child process created in create_sig_proc. This s=
hould avoid the child calling the parent's signal handlers and interfering =
with parent's cleanup process. Signed-off-by: Jiri Palecek <jpalecek@web.de=
>.=20

ltp/testcases/kernel/syscalls/clock_nanosleep/clock_nanosleep01.c
ltp/testcases/kernel/syscalls/mq_timedreceive/mq_timedreceive01.c
ltp/testcases/kernel/syscalls/mq_timedsend/mq_timedsend01.c
ltp/testcases/kernel/syscalls/ppoll/ppoll01.c
ltp/testcases/kernel/syscalls/utils/common_j_h.c
ltp/testcases/kernel/syscalls/utils/include_j_h.h

41) Log Message:
Make sure some Crackerjack tests are running under root: The tests need to =
run under root to change their EUID. Signed-off-by: Jiri Palecek <jpalecek@=
web.de>.

ltp/testcases/kernel/syscalls/mq_unlink/mq_unlink01.c
ltp/testcases/kernel/syscalls/utimes/utimes01.c

42) Log Message:
Fix the logic of ppoll01 test: According to POSIX, a file descriptor is con=
sidered ready for writing when a call to write() would not block, even when=
 it returns an error (other than EAGAIN). Thus, a file descriptor opened fo=
r reading is ready for writing. This patch reflects that in the test. Signe=
d-off-by: Jiri Palecek <jpalecek@web.de>.

ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

43) Log Message:
Add a test for race-free operation of ppoll: Hello, after the previous patc=
h, this patch adds a test to test a use of ppoll() without races (ie. the i=
ntended use of ppoll). It blocks the signal, schedules a signal to be deliv=
ered and expects ppoll to return EINTR (and never lose the signal. Signed-o=
ff-by: Jiri Palecek <jpalecek@web.de>.

ltp/testcases/kernel/syscalls/ppoll/ppoll01.c

44) Log Message:
Use SIG_ERR to indicate tst_sig's default handler, to allow (and not clash =
with) SIG_DFL: SIG_DFL happens to be 0 as well as DEF_HANDLER - this means =
you cannot use SIG_DFL as tst_sig argument, eg. if you want to reset the si=
gnal handling in tests' children to normal. This patch changes DEF_HANDLER =
to be SIG_ERR, as this value cannot be normally used with tst_sig(), so the=
y cannot clash. Signed-off-by: Jiri Palecek <jpalecek@web.de>.

ltp/include/test.h

45) Log Message:
fsstress: delete tralling spaces: Signed-off-by: Andrew Vagin <avagin@gmail=
.com>:

ltp/testcases/kernel/fs/fsstress/fsstress.c

46) Log Message:
fsstress: use tabs instead of spaces for indentation: Signed-off-by: Andrew=
 Vagin <avagin@gmail.com>.

ltp/testcases/kernel/fs/fsstress/fsstress.c

47) Log Message:
fsstress: fix memory leaks:=20
=3D=3D11424=3D=3D 156 bytes in 1 blocks are definitely lost in loss record =
2 of 2
=3D=3D11424=3D=3D    at 0x4A0763E: malloc (vg_replace_malloc.c:207)
=3D=3D11424=3D=3D    by 0x402E4C: make_freq_table (fsstress.c:986)
=3D=3D11424=3D=3D    by 0x401C26: main (fsstress.c:410)
make_freq_table is executed on each iterations, but freq_table is not chang=
ed during test, so this patch moves it from the loop. Signed-off-by: Andrew=
 Vagin <avagin@gmail.com>.

ltp/testcases/kernel/fs/fsstress/fsstress.c

48) Log Message:
fsstress: fix memory leak in fread_d:=20
1. check result from operation open before set flags
2. close descriptor and free path if set flags failed
valgrind --leak-check=3Dfull --show-reachable=3Dyes ./fsstress -d /home/shp=
agin/git-archive/ltp/testcases/kernel/fs/fsstress/tmp -l 10 -n 100
=3D=3D23212=3D=3D 1,134 bytes in 108 blocks are definitely lost in loss rec=
ord 4 of 5
=3D=3D23212=3D=3D    at 0x4A0776F: realloc (vg_replace_malloc.c:429)
=3D=3D23212=3D=3D    by 0x401E6A: append_pathname (fsstress.c:528)
=3D=3D23212=3D=3D    by 0x4024E3: fent_to_name (fsstress.c:760)
=3D=3D23212=3D=3D    by 0x40284F: get_fname (fsstress.c:846)
=3D=3D23212=3D=3D    by 0x4041E0: dread_f (fsstress.c:1757)
=3D=3D23212=3D=3D    by 0x402368: doproc (fsstress.c:728)
=3D=3D23212=3D=3D    by 0x401CC1: main (fsstress.c:463)
Signed-off-by: Andrew Vagin <avagin@gmail.com>.

ltp/testcases/kernel/fs/fsstress/fsstress.c

49) Log Message:
fsstress: renew flist if clean up test directory: flist contain all files c=
reated by fsstress. If test clean up direcory on each interations that it s=
hould reinitilize flist. Signed-off-by: Andrew Vagin <avagin@gmail.com>.

ltp/testcases/kernel/fs/fsstress/fsstress.c

50) Log Message:
lcov: improve detection of gcov-kernel support

Modified File(s):
ltp/utils/analysis/lcov/bin/lcov
ltp/utils/analysis/lcov/man/lcovrc.5

51) Log Message:
memcg : fix various test failures: In memcg testcases,
1. use /dev/memcg consistently,
2. for testcase_25, since 2.6.31, writing -1 to memory.limit_in_bytes will =
reset to unlimit,
3. for testcase_35, writing to memory.force_empty for non-empty cgroup shou=
ld return failure,
Signed-off-by: Liu Bo <liubo-fnst@cn.fujitsu.com>,

Modified File(s):
ltp/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
ltp/testcases/kernel/controllers/memcg/stress/memcg_stress_test.sh

52) Log Message:
When this TC is ending it removes all directories/files under /tmp that may=
 be embarrassing so, if you agree I suggest that it only removes what has t=
o do with the TestCase; this is the purpose of the following patch. Signed-=
off-by: JACKY MALCLES <Jacky.Malcles@bull.net>.

ltp/testcases/kernel/fs/fs_di/fs_di

53) Log Message:
lcov: ignore incomplete function names in .bb files
- don't abort processing when an incomplete function name is encountered in=
 a .bb file (gcc 2.95.3 adds those)
- fix filename prefix detection
Peter Oberparleiter <oberpapr@users.sourceforge.net>,

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo
ltp/utils/analysis/lcov/bin/lcov

54) Log Message:
lcov: introduce new options --derive-func-data
When using a gcov version that does not provide function data, this option =
will attempt to guess the function coverage data for a function by looking =
at the number of times that the first line of that function was called. Pet=
er Oberparleiter <oberpapr@users.sourceforge.net>.

Modified File(s):
ltp/utils/analysis/lcov/bin/geninfo
ltp/utils/analysis/lcov/bin/lcov



--=-3gOVKS1U1KPLpJuL9RkP--

