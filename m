Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXKBSTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXKBSTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXKBSSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:18:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35793 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbXKBSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:18:53 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for OCTOBER
	2007
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       ltp-announce <ltp-announce@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-cNJigG+Q3ilcvyMXowUf"
Organization: IBM
Date: Fri, 02 Nov 2007 23:48:33 +0530
Message-Id: <1194027513.5893.23.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cNJigG+Q3ilcvyMXowUf
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
OCTOBER 2007. The latest version of the test-suite contains 3000+
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

* Integration of remap_file_pages [remap_file_page01 &
remap_file_pages02] syscall test case to LTP,
* OPEN_POSIX_TESTSUITE updation,
* Enhancing LTP Infrastructure for Better/more stress generation
options,
* Fix for executing lot of Test Cases for running on NFS,
* Changes in lots of MACROS to higher Kernel compatibilities,
* Making lcov 1.6 compatible with gcov/gcc 4.1.0

Note(s) from the Maintainer:
We had couple of discussions regarding the new formats to make the LTP
output more meaningful. Hope we can see both the XML and HTML version of
LTP output in coming months. We are also stressing on improving the LTP
infrastructure itself, to make testing more meaningful and effective. We
have started with integrating the various existing stress generation
capability to LTP runall. We can expect more such improvements in those
areas. LTP-KDUMP will also see more automation and support for community
Distros like OpenSuse and Ubuntu in future.


We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
(for New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
(for New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
(for New Feature Request(s))

Please also see the ChangeLog Attached (OCTOBER 2007):

Happy testing, 
Regards-- 
Subrata,

--=-cNJigG+Q3ilcvyMXowUf
Content-Disposition: attachment; filename=Oct-2007_Changelog.txt
Content-Type: text/plain; name=Oct-2007_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

1)  Log Message: 
lcov: workaround for gcc 4.1.0 .gcno file oddness by Peter Oberparleiter (oberpapr@users.sourceforge.net)
scott.heavner@philips.com wrote:
I'm trying to use lcov 1.6 with gcov/gcc 4.1.0. The geninfo parser was
aborting on a small number of .gcno files. I've patched my local copy so
that geninfo prints out the offset of the error and skips the remainder of
the problem file

File(s) Affected:
ltp/utils/analysis/lcov/bin/geninfo

2) Log Message: Carmelo (carmelo.amoroso@st.com) fixed OPEN_MAX macro issue, from kernel 2.6.23 onwards
File(s) Affected:
ltp-full-20070930/testcases/kernel/syscalls/fork/fork09.c
ltp-full-20070930/testcases/kernel/ipc/ipc_stress/pipe_test_02.c

3) Log Message: Ported this to LTP Format
File(s) Affected:
ltp/runtest/syscalls
File(s) Added:
ltp/testcases/kernel/syscalls/remap_file_pages/Makefile
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages01.c

4) Log Message: Open Posix Test suite updation by Patrick Kirsch <pkirsch@suse.de>
File(s) Affected:
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_close/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_close/2-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_close/3-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_getvalue/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_getvalue/2-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_getvalue/4-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_getvalue/5-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_open/1-4.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/1-2.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/2-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/4-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/5-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/6-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_unlink/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_unlink/2-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_unlink/4-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/1-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/1-2.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/11-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/12-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/3-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/5-1.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_wait/7-1.c

5) Log Message: Olof Johansson <olof@lixom.net> corrected the message when there are no entries in /etc/group for 'nobody' and 'bin'
File(s) Affected:
ltp/testcases/kernel/syscalls/creat/creat08.c

6) Log Message: Andi Kleen <ak@novell.com> changed the way IN_MOVE_SELF works with old kernel
File(s) Affected:
ltp/testcases/kernel/syscalls/inotify/inotify02.c

7) Log Message: Ricardo (rsalveti@linux.vnet.ibm.com) added another testcase for remap_file_pages() syscall for better error checking
File(s) Affected:
ltp/runtest/syscalls
File(s) Added:
ltp/testcases/kernel/syscalls/remap_file_pages/remap_file_pages02.c

8) Log Message: 
Better Ways to Integrate "ltp/tools/genload/stress" with  "ltp/runltp" by
Ricardo and Subrata,
This is the second version of Subrata's patch, this is intended to
fully exploit all the features provided by "ltp/tools/genload/stress".

New option:
 -D Run LTP under additional background Load on Secondary Storage

Options that have a different interface:
 -i Run LTP under additional background Load on IO Bus
 -m Run LTP under additional background Load on Main memory

Remember that this change will break the script interface.
File(s) Affected:
ltp/runltp

9) Log Message: Breno Leitao (leitao@linux.vnet.ibm.com) fixed these for running on NFS mounted systems
File(s) Affected:
ltp/testcases/kernel/syscalls/chdir/chdir01.c
ltp/testcases/kernel/syscalls/creat/creat03.c
ltp/testcases/kernel/syscalls/creat/creat05.c
ltp/testcases/kernel/syscalls/dup2/dup202.c
ltp/testcases/kernel/syscalls/dup2/dup203.c
ltp/testcases/kernel/syscalls/execve/execve04.c
ltp/testcases/kernel/syscalls/flock/flock01.c
ltp/testcases/kernel/syscalls/flock/flock02.c
ltp/testcases/kernel/syscalls/flock/flock03.c
ltp/testcases/kernel/syscalls/flock/flock04.c
ltp/testcases/kernel/syscalls/flock/flock05.c
ltp/testcases/kernel/syscalls/flock/flock06.c
ltp/testcases/kernel/syscalls/fork/fork07.c
ltp/testcases/kernel/syscalls/mprotect/mprotect02.c
ltp/testcases/kernel/syscalls/mprotect/mprotect03.c
ltp/testcases/kernel/syscalls/open/open04.c
ltp/testcases/kernel/syscalls/open/open05.c
ltp/testcases/kernel/syscalls/read/read04.c
ltp/testcases/kernel/syscalls/readv/readv01.c
ltp/testcases/kernel/syscalls/readv/readv02.c
ltp/testcases/kernel/syscalls/recvmsg/Makefile
ltp/testcases/kernel/syscalls/recvmsg/recvmsg01.c
ltp/testcases/kernel/syscalls/rmdir/rmdir02.c
ltp/testcases/kernel/syscalls/write/write03.c
ltp/testcases/kernel/syscalls/write/write05.c
ltp/testcases/kernel/syscalls/writev/writev01.c
ltp/testcases/kernel/syscalls/writev/writev02.c
ltp/testcases/kernel/syscalls/writev/writev03.c
ltp/testcases/kernel/syscalls/writev/writev04.c
ltp/testcases/kernel/syscalls/writev/writev05.c

--=-cNJigG+Q3ilcvyMXowUf--

