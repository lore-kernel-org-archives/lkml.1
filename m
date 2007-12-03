Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXLCL34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXLCL34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXLCL3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:29:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52864 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbXLCL3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:29:44 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for NOVEMBER
	2007
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       kexec@lists.infradead.org, redhat-lspp@redhat.com
Content-Type: multipart/mixed; boundary="=-ZRx1x+99VaVn3d5g8rlX"
Organization: IBM
Date: Mon, 03 Dec 2007 16:59:30 +0530
Message-Id: <1196681370.4417.28.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZRx1x+99VaVn3d5g8rlX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
NOVEMBER 2007. The latest version of the test-suite contains 3000+
tests for the Linux OS and can be found at http://ltp.sourceforge.net/.
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

* Several Network Test Cases has been updated to be run on different
subnet configuration,
* Updated lot of Test Cases to enable them run on NFS,
* Addition of posix_fadvise, fadvise64, madvise03, sendfile64 &
sendfile04 Test Cases to LTP
* Existing code in LTP-Kdump has been enhanced to test dump on Network
and different partitions, added IA64 support to KDUMP and lots of
changes in KDUMP scripts for error correction and improvement,
* Option to generate more parsible output in HTML format has been added,
* Option to automatically mail back LTP reports has been added,
* OpenHPI 2.10.1 has been integrated to LTP,
* Updated several Test Cases for suiting to proper GPLv2 License,


Note(s) from the Maintainer:
LTP has seen heightened activity in the month of Nov 2007. Thanks for
your efforts and contributions. Steps taken to improve LTP
infrastructure in various dimensions has seen efforts becoming fruitful.
We have added HTML output and auto-mail back option this month. We will
continue to work on XML output in coming days and also evaluate and
finally integrate auto build of kernel and test to LTP in future. New
test cases will continue to get added from community and soon we will
start to investigate all existing test cases for their overall
effectiveness in functionality testing. Your support to improve LTP is
extremely essential and i am expecting more support from you on this.


We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the Change Log Attached (NOVEMBER 2007):

Happy testing, 
Regards-- 
Subrata,


--=-ZRx1x+99VaVn3d5g8rlX
Content-Disposition: attachment; filename=Nov-2007-ChangeLog.txt
Content-Type: text/plain; name=Nov-2007-ChangeLog.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

1)  Log Message: lcov: fix for problem resulting in lcov aborting with "ERROR: reading string"
File(s) Affected:
/cvsroot/ltp/utils/analysis/lcov/bin

2) Log Message: Update to OpenHPI 2.10.1 (see www.openhpi.org for more info)
File(s) Affected:
ltp/testcases/open_hpi_testsuite

3) Log Message: This patch by Jeff Mahoney <jeffm@suse.com> changes the test to use the read-only end of the pipe with PROT_READ permissions, which passes the FMODE_READ check on the file descriptor and returns -ENODEV.
File(s) Affected:
ltp/testcases/open_posix_testsuite/conformance/interfaces/mmap/23-1.c

4) Log Message: Yi Yang <yang.y.yi@gmail.com> fixed some anomalies for ext2/ext3 and creat system call
File(s) Affected:
ltp/testcases/kernel/fs/doio/growfiles.c
ltp/testcases/kernel/syscalls/creat/creat05.c

5) Log Message: Removing Propreitary and Confidential Information to Suit to GPLv2 License
File(s) Affected:
testcases/kernel/ipc/ipc_stress/message_queue_test_01.c
testcases/kernel/ipc/ipc_stress/message_queue_test_02_ctl.c
testcases/kernel/ipc/ipc_stress/message_queue_test_02_get.c
testcases/kernel/ipc/ipc_stress/message_queue_test_02_rcv.c
testcases/kernel/ipc/ipc_stress/message_queue_test_02_snd.c
testcases/kernel/ipc/ipc_stress/message_queue_test_04.c
testcases/kernel/ipc/ipc_stress/message_queue_test_05.c
testcases/kernel/ipc/ipc_stress/pipe_test_01.c
testcases/kernel/ipc/ipc_stress/pipe_test_02.c
testcases/kernel/ipc/ipc_stress/semaphore_test_01.c
testcases/kernel/ipc/ipc_stress/semaphore_test_02.c
testcases/kernel/ipc/ipc_stress/semaphore_test_03.c
testcases/kernel/ipc/ipc_stress/shmem_test_01.c
testcases/kernel/ipc/ipc_stress/shmem_test_02.c
testcases/kernel/ipc/ipc_stress/shmem_test_03.c
testcases/kernel/ipc/ipc_stress/shmem_test_04.c
testcases/kernel/ipc/ipc_stress/shmem_test_05.c
testcases/kernel/ipc/ipc_stress/shmem_test_06.c
testcases/kernel/ipc/ipc_stress/shmem_test_07.c
testcases/kernel/ipc/ipc_stress/signal_test_01.c
testcases/kernel/ipc/ipc_stress/signal_test_02.c
testcases/kernel/ipc/ipc_stress/signal_test_03.c
testcases/kernel/ipc/ipc_stress/signal_test_04.c
testcases/kernel/ipc/ipc_stress/signal_test_05.c
testcases/kernel/ipc/ipc_stress/signal_test_06.c
testcases/kernel/ipc/ipc_stress/signal_test_07.c
testcases/kernel/sched/clisrv/pthserv.c
testcases/kernel/sched/clisrv/readline.c
testcases/kernel/sched/clisrv/writen.c
testcases/kernel/sched/sched_stress/sched_driver.c
testcases/kernel/sched/sched_stress/sched.c
testcases/kernel/sched/sched_stress/sched.h
testcases/kernel/sched/sched_stress/sched_tc0.c
testcases/kernel/sched/sched_stress/sched_tc1.c
testcases/kernel/sched/sched_stress/sched_tc2.c
testcases/kernel/sched/sched_stress/sched_tc3.c
testcases/kernel/sched/sched_stress/sched_tc4.c
testcases/kernel/sched/sched_stress/sched_tc5.c
testcases/kernel/sched/sched_stress/sched_tc6.c

6) Log Message: Make the test working on busybox system, where 'df' command
doesn't support -P option, neither accept a directory as input,
Submitted by Carmelo AMOROSO <carmelo.amoroso@st.com>
File(s) Affected:
ltp/testcases/kernel/fs/doio/rwtest.sh

7) Log Message:
This patch allows network stress tests to be run on different subnet
configuration by using some macros for IP addresses configuration.
It doesn't affect default values.
Submitted by Carmelo AMOROSO <carmelo.amoroso@st.com>
File(s) Affected:
ltp/testcases/network/stress/broken_ip/broken_ip4-checksum
ltp/testcases/network/stress/broken_ip/broken_ip4-dstaddr
ltp/testcases/network/stress/broken_ip/broken_ip4-fragment
ltp/testcases/network/stress/broken_ip/broken_ip4-ihl
ltp/testcases/network/stress/broken_ip/broken_ip4-protcol
ltp/testcases/network/stress/broken_ip/broken_ip4-totlen
ltp/testcases/network/stress/broken_ip/broken_ip4-version
ltp/testcases/network/stress/dns/dns4-stress
ltp/testcases/network/stress/ftp/ftp4-download-stress
ltp/testcases/network/stress/ftp/ftp4-upload-stress
ltp/testcases/network/stress/http/http4-stress
ltp/testcases/network/stress/icmp/uni-basic/icmp4-uni-basic01
ltp/testcases/network/stress/interface/if4-addr-change
ltp/testcases/network/stress/interface/if4-alias-adddel
ltp/testcases/network/stress/interface/if4-alias-addlarge
ltp/testcases/network/stress/interface/if4-mtu-change
ltp/testcases/network/stress/interface/if4-route-adddel
ltp/testcases/network/stress/interface/if4-route-addlarge
ltp/testcases/network/stress/interface/if4-updown
ltp/testcases/network/stress/multicast/grp-operation/mcast4-grpope01
ltp/testcases/network/stress/multicast/grp-operation/mcast4-grpope02
ltp/testcases/network/stress/multicast/grp-operation/mcast4-grpope03
ltp/testcases/network/stress/multicast/grp-operation/mcast4-grpope04
ltp/testcases/network/stress/multicast/packet-flood/mcast4-pktfld01
ltp/testcases/network/stress/multicast/packet-flood/mcast4-pktfld02
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld01
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld02
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld03
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld04
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld05
ltp/testcases/network/stress/multicast/query-flood/mcast4-queryfld06
ltp/testcases/network/stress/route/route4-change-dst
ltp/testcases/network/stress/route/route4-change-gw
ltp/testcases/network/stress/route/route4-change-if
ltp/testcases/network/stress/route/route4-ifdown
ltp/testcases/network/stress/route/route4-redirect
ltp/testcases/network/stress/route/route4-rmmod
ltp/testcases/network/stress/ssh/ssh4-stress
ltp/testcases/network/stress/tcp/multi-diffport/tcp4-multi-diffport01
ltp/testcases/network/stress/tcp/multi-sameport/tcp4-multi-sameport01
ltp/testcases/network/stress/tcp/uni-basic/tcp4-uni-basic01
ltp/testcases/network/stress/udp/multi-diffport/udp4-multi-diffport01
ltp/testcases/network/stress/udp/uni-basic/udp4-uni-basic01
testscripts/networkstress.sh

8) Log Message: Patch to check file permission first, and then skip write-only
files,and report them as INFO. Submitted by Cai Qian <qcai@redhat.com>
File(s) Affected:
ltp/testcases/kernel/fs/proc/proc01.c

9) Log Message:
Patch to skip read of all /proc/<pid> directories except /proc/self.
Therefore, it make sure that at least one /proc/<pid> has been read,
and also the directory will stay as long as the life time of the test.
Submitted by Cai Qian <qcai@redhat.com>
File(s) Affected:
ltp/testcases/kernel/fs/proc/proc01.c

10) Log Message: Create testfile in tmpdir to be consistent with other tests by Kumar Gala <galak@kernel.crashing.org>
File(s) Affected:
ltp/testcases/kernel/syscalls/splice/splice01.c
ltp/testcases/kernel/syscalls/tee/tee01.c

11) Log Message: Close the fd's we open when running on NFS to avoid warnings, submitted by Kumar Gala <galak@kernel.crashing.org>
File(s) Affected:
ltp/testcases/kernel/syscalls/creat/creat01.c
ltp/testcases/kernel/syscalls/open/open04.c
ltp/testcases/kernel/syscalls/writev/writev06.c

12) Log Message:Close fd's to make running on NFS work, submitted by Kumar Gala <galak@kernel.crashing.org>
File(s) Affected:
ltp/testcases/kernel/syscalls/creat/creat05.c

13) Log Message: Add a lib routine to tell us if we are running on NFS Submitted by Kumar Gala <galak@kernel.crashing.org>
File(s) Affected:
ltp/include/test.h
File(s) Added:
ltp/lib/tst_is_cwd_nfs.c

14) Log Message: Adds arm to the architectures where SHMBLA != PAGESIZE, submitted by Khem Raj <kraj@mvista.com>
File(s) Affected:
ltp/testcases/kernel/mem/shmt/shmt09.c

15) Log Message: New posix_fadvise and fadvise64 Testcases contributed by Masatake YAMATO <yamato@redhat.com>
File(s) Affected:
ltp/runtest/syscalls
New File(s) Addes:
ltp/testcases/kernel/syscalls/fadvise/Makefile
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise01.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise02.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise03.c
ltp/testcases/kernel/syscalls/fadvise/posix_fadvise04.c

16) Log Message:
Existing code in LTP Kdump has been enhanced to test dump on network and
different partitions. The attached patch supports following features
-Dump on EXT3 partition, partition referenced by partition name, Label and
UUID
-Dump on raw partition
-Dump on Network dump server
-Test dump filtering feature of Kdump
-Test Link Delay feature of Kdump
-Result analysis has been implemented  for local dumping and network
dumping.
-Result analysis has been implemented for filtering as well as link delay.
But the analysis part can be enahnced further
-'setup' file has been modified
      * To accept inputs from user or file
      * To automate configuration of bootloader file to reserve memory for
crashkernel
      * To test basic or exchausted list of LKDTM test
      * To accept user inputs for dumping on different partitions and for
network dumping
-'master' file has been modified
      *To invoke result analysis code of dumping in different destinations
      *to remove cronjob when execution is done, this is a bug fix
-'test' file has been modifed
      *To set kdump.conf file based on user input and trigger crash
-'Makefile' has been modified not to run 'setup'
-Added new files
      *kdump_propogate ->To add ssh public keys to network dump server
      *verify_dump ->To verify dump in different partitions and network
dumping
      *lkdtm.orig is replaced with lkdtm.base for basic testcases of lkdtm,
lkdtm.exha for exhausted list of lkdtm testcases.

Submitted by: Poornima Nayak <Poornima.Nayak@in.ibm.com>

File(s) Affected:
ltp/testcases/kdump/Makefile ltp/testcases/kdump/README
ltp/testcases/kdump/TEST_PLAN.txt ltp/testcases/kdump/master
ltp/testcases/kdump/setup ltp/testcases/kdump/test
File(s) Added:
ltp/testcases/kdump/kdump_propagate
ltp/testcases/kdump/verify_dump
ltp/testcases/kdump/testlists/lkdtm.base
ltp/testcases/kdump/testlists/lkdtm.exha
File(s) Removed:
ltp/testcases/kdump/testlists/lkdtm.orig

17) Log Message: Fix endless loop hit messages for kdump test case, by Cai Qian <qcai@redhat.com>
File(s) Affected:
ltp/testcases/kdump/rhtools/lkdtm_mod/lkdtm.c

18) Log Message: Fix for vmcore generation and vmcore verification are at different hours, by Cai Qian <qcai@redhat.com>
File(s) Affected:
ltp/testcases/kdump/master

19) Log Message: Changes that allows adp to run top on batch mode instead of interactively, submitted by Rafael Folco <rfolco@linux.vnet.ibm.com>
File(s) Affected:
ltp/testscripts/adp.sh

20) Log Message: Changes to prevent fcntl14 test case to crash on uclinux on blackfin board, submitted by Vivi <violetleigh@gmail.com>
File(s) Affected:
ltp/testcases/kernel/syscalls/fcntl/fcntl14.c

21) Log Message: New HTML format for LTP Output
File(s) Affected:
ltp/runltp
File(s) Added:
ltp/tools/genhtml.pl
ltp/tools/html_report_header.txt

22) Log Message: Add IA64 support to kdump test case, submitted by Cai Qian <qcai@redhat.com>
File(s) Affected:
ltp/testcases/kdump/setup

23) Log Message: Patch to fix summary script of LTP kdump (can't retrieve LOG correctly), submitted by Lin Feng Shen (shenlinf@cn.ibm.com)
File(s) Affected:
ltp/testcases/kdump/summary

24) Log Message: Fix for master script of LTP kdump (Which tries to copy /proc/config.gz though it's not available), submitted by Cijurajan Kollanoor (cijurajan@in.ibm.com)
File(s) Affected:
ltp/testcases/kdump/master

25) Log Message: Report TCONF for swapon/off test when run on tmpfs or nfs, submitted by Kumar Gala <galak@kernel.crashing.org>
File(s) Affected:
testcases/kernel/syscalls/swapoff/swapoff01.c
testcases/kernel/syscalls/swapoff/swapoff02.c
testcases/kernel/syscalls/swapon/swapon01.c
testcases/kernel/syscalls/swapon/swapon02.c
testcases/kernel/syscalls/swapon/swapon03.c

26) Log Message: This does testing for the missing functionalities of MADV_REMOVE, MADV_DONTFORK & MADV_DOFORK, submitted by Pavan, pnaregun@in.ibm.com
File(s) Added:
ltp/testcases/kernel/syscalls/madvise/madvise03.c

27) Log Message: Added an Option to mail-back LTP reports, by Subrata Modak <subrata@linux.vnet.ibm.com>
File(s) Affected:
ltp/runltp

28) Log Message: Added sendfile64 support and new testcase sendfile04.c in this regard, by Masatake YAMATO <yamato@redhat.com>
File(s) Affected:
runtest/syscalls
testcases/kernel/syscalls/sendfile/Makefile
testcases/kernel/syscalls/sendfile/sendfile02.c
testcases/kernel/syscalls/sendfile/sendfile03.c
File(s) Added:
ltp/testcases/kernel/syscalls/sendfile/sendfile04.c

29) Log Message: Proper Inputs for Memory Reservation for Crask Kernel on various architectures, by Poornima Nayak <Poornima.Nayak@in.ibm.com>
File(s) Affected:
ltp/testcases/kdump/setup


--=-ZRx1x+99VaVn3d5g8rlX--

