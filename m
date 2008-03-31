Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYCaMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYCaMfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYCaMf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:35:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52798 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYCaMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:35:25 -0400
Subject: [ANNOUNCE] The Linux Test Project has been Released for MARCH 2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       ltp-announce <ltp-announce@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-Ozc50YT/RqRWYJ3K2HxL"
Organization: IBM
Date: Mon, 31 Mar 2008 18:04:43 +0530
Message-Id: <1206966883.5556.38.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ozc50YT/RqRWYJ3K2HxL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Dear All,

The Linux Test Project test suite has been released for the month of
MARCH 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


Release Highlights:

* Addition of TI-RPC test cases,
* Continuing work for Concurrency-safe & NFS fixes,
* Major Enhancements/Cleanups to LTP-RT Tree,
* Major Fixes to Test Cases behavior on CELL for NFS issues,


Note(s) from the Maintainer:

Continuing with our endeavor to bring you new test cases for reaching
many unexplored areas of Kernel, we will continue to add new test cases
in future, notably amongst them being the SHAREDSUBTREE, RELAYFS,
LTP-POUNDER Enhancements for netdump, diskdump & lkcdm test scripts, as,
well as, kdump on Xen hypervisor and guests, more tests for utilities,
like makedumpfile, mkdumprd, kexec etc. We will also continue to work
with kerlabs.com to make all LTP Test Cases concurrency safe by this
year end.
I would also request test engineers across Linux Distros to kindly
consider integrating the enhancements/fixes they might have done to
their local LTP suit to the Global LTP Project.


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

Please also see the Change Log Attached (MARCH 2008):

Happy testing, 
Regards-- 
Subrata,

--=-Ozc50YT/RqRWYJ3K2HxL
Content-Disposition: attachment; filename=March-2008_Changelog.txt
Content-Type: text/plain; name=March-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: 8bit

1) Log Message:
Fix the following NFS warning:
ioctl01     0  WARN  :  tst_rmdir(): rmobj(/tmp/iocfNl8Bi) failed: remove(/tmp/iocfNl8Bi) failed; errno=39: Directory not empty,
by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ioctl/ioctl01.c

2) Log Message:
Whitespaces cleanup and added -i argument for iterations, by, Gilles Carry <gilles.carry@bull.net>

Modified File(s):
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load.c
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c

3) Log Message:
Test does:
..
pid1 = fork();
if (pid1 == 0) {
        /* child */
        kill(-pid1, SIGKILL);
...
which is wrong, since pid1 is zero.
By, Anton Gladkov <agladkov@parallels.com>

Modified File(s):
ltp/testcases/kernel/syscalls/kill/kill06.c

4) Log Message:
Provide it with CHILD_STACK_SIZE, by, Anton Gladkov <agladkov@parallels.com>

Modified File(s):
ltp/testcases/kernel/syscalls/clone/clone06.c

5) Log Message:
Fix 'reading beyond file size' testcase in diotest4. Something goes wrong if we are allowed to read, or, we are not allowed to read, but we've got unexpected errno, by, Anton Gladkov <agladkov@parallels.com>

Modified File(s):
ltp/testcases/kernel/io/direct_io/diotest4.c

6) Log Message:
Initial Set of TI-RPC test Cases addition to LTP, by, Aurélien Charbon <aurelien.charbon@ext.bull.net>

Modified File(s):
ltp/doc/testcases/network.txt ltp/runtest/rpc
ltp/runtest/stress.part3
ltp/testcases/kernel/include/linux_syscall_numbers.h
ltp/testcases/network/rpc/Makefile
ltp/testcases/network/rpc/README

Removed File(s):
ltp/testcases/network/rpc/rpc01/Makefile
ltp/testcases/network/rpc/rpc01/rpc01
ltp/testcases/network/rpc/rpc01/rpc1.c
ltp/testcases/network/rpc/rpc01/rpc_server.c
ltp/testcases/network/rpc/rpc01/datafiles/file.1
ltp/testcases/network/rpc/rpc01/datafiles/file.2
ltp/testcases/network/rpc/rpcinfo/Makefile
ltp/testcases/network/rpc/rpcinfo/rpcinfo01
ltp/testcases/network/rpc/rup/Makefile
ltp/testcases/network/rpc/rup/rup01
ltp/testcases/network/rpc/rusers/Makefile
ltp/testcases/network/rpc/rusers/rusers01

Added File(s):
ltp/testcases/network/rpc/basic_tests/Makefile
ltp/testcases/network/rpc/basic_tests/README
ltp/testcases/network/rpc/basic_tests/rpc01/Makefile
ltp/testcases/network/rpc/basic_tests/rpc01/rpc01
ltp/testcases/network/rpc/basic_tests/rpc01/rpc1.c
ltp/testcases/network/rpc/basic_tests/rpc01/rpc_server.c
ltp/testcases/network/rpc/basic_tests/rpc01/datafiles/file.1
ltp/testcases/network/rpc/basic_tests/rpc01/datafiles/file.2
ltp/testcases/network/rpc/basic_tests/rpcinfo/Makefile
ltp/testcases/network/rpc/basic_tests/rpcinfo/rpcinfo01
ltp/testcases/network/rpc/basic_tests/rup/Makefile
ltp/testcases/network/rpc/basic_tests/rup/rup01
ltp/testcases/network/rpc/basic_tests/rusers/Makefile
ltp/testcases/network/rpc/basic_tests/rusers/rusers01
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/Makefile
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/Makefile.clnt
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/Makefile.svc
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/README
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/configure.auto
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/configure.interactive
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/configure~
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/install
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/install.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_addrmanagmt_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_addrmanagmt_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_addrmanagmt_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_auth_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_broadc_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_createdestroy_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_createdestroy_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_createdestroy_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_createdestroy_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_createdestroy_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_err_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_regunreg_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_stdcall_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_tirpc_ts_run.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_ts_run.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/rpc_ts_wizard.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/run_rpc_tirpc_tests.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_addrmanagmt_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_addrmanagmt_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_auth_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_mt_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_bottomlevel_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_err_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_err_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_mt_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_expertlevel_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_mt_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_interlevel_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_mt_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_simple_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_basic_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_complex_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_dataint_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_limits_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_mt_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_performance_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_scalability_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tirpc_toplevel_stress_lib.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/Makefile.hdr
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/categories
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/install.ftr
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/install.hdr
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/rpc_ts_run.ftr
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/inc/rpc_ts_run.hdr
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_get_myaddress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_getmaps.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_getport.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_rmtcall.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_rmtcall.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_rmtcall.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_set.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_addrmanagmt_pmap_unset.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_auth_auth_destroy.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_auth_authnone_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_auth_authunix_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_auth_authunix_create_default.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_broadc_clnt_broadcast.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnt_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnt_create.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnt_destroy.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnt_destroy.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntraw_create.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntraw_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntraw_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnttcp_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnttcp_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnttcp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clnttcp_create.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntudp_bufcreate.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntudp_bufcreate.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntudp_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntudp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_clntudp_create.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svc_destroy.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svc_destroy.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcfd_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcfd_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcraw_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcraw_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svctcp_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svctcp_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svctcp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svctcp_create.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcudp_bufcreate.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcudp_bufcreate.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcudp_create.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcudp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_createdestroy_svcudp_create.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_pcreateerror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_perrno.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_perror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_spcreateerror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_sperrno.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_clnt_sperror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_auth.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_noproc.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_noprog.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_progvers.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_systemerr.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_err_svcerr_weakauth.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_regunreg_registerrpc.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_regunreg_svc_register.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_regunreg_svc_unregister.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_regunreg_xprt_register.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_regunreg_xprt_unregister.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_callrpc.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_callrpc.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_callrpc.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_callrpc.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_callrpc.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_control.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_control.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_freeres.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_clnt_geterr.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_svc_freeargs.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_svc_getargs.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_svc_getargs.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_svc_getcaller.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/rpc_stdcall_svc_sendreply.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_addrmanagmt_rpcb_getaddr.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_addrmanagmt_rpcb_getaddr.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_addrmanagmt_rpcb_getmaps.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_auth_authdes_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_auth_authdes_seccreate.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_auth_authnone_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_auth_authsys_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_auth_authsys_create_default.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_dg_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_dg_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_vc_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_clnt_vc_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_svc_dg_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_svc_dg_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_svc_vc_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_bottomlevel_svc_vc_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_clnt_pcreateerror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_clnt_perrno.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_clnt_perrno.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_clnt_perror.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_clnt_perror.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_svcerr_noproc.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_svcerr_noprog.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_svcerr_progvers.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_svcerr_systemerr.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_err_svcerr_weakauth.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_tli_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_clnt_tli_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_rmtcall.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_set.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_rpcb_unset.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_reg.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_reg.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_reg.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_tli_create.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_tli_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_unreg.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_unreg.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_expertlevel_svc_unreg.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_control.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_control.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_tp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_tp_create_timed.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_clnt_tp_create_timed.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_interlevel_svc_tp_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_broadcast_exp.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.basic.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_reg.basic.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_reg.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_simple_rpc_reg.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.complex.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.dataint.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.mt.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.performance.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.scalability.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_call.stress.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_create_timed.limits.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_create_timed.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_clnt_destroy.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_svc_create.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/scripts/tirpc_toplevel_svc_destroy.sh
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/cleaner.c.src
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_get_myaddress/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_get_myaddress/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_getmaps/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_getmaps/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_getport/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_getport/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_rmtcall/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_rmtcall/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_rmtcall/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_rmtcall/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_set/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_set/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_unset/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_addrmanagmt_pmap_unset/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_auth_destroy/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_auth_destroy/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authnone_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authnone_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authunix_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authunix_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authunix_create_default/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_auth_authunix_create_default/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_broadc_clnt_broadcast/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_create/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_destroy/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_destroy/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnt_destroy/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntraw_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntraw_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntraw_create/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntraw_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnttcp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnttcp_create/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnttcp_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnttcp_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clnttcp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_bufcreate/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_bufcreate/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_bufcreate/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_create/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_clntudp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svc_destroy/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svc_destroy/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svc_destroy/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcfd_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcfd_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcfd_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcraw_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcraw_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcraw_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svctcp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svctcp_create/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svctcp_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svctcp_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svctcp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_bufcreate/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_bufcreate/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_bufcreate/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_create/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_create/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_createdestroy_svcudp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_pcreateerror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_pcreateerror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_perrno/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_perrno/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_perror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_perror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_spcreateerror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_spcreateerror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_sperrno/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_sperrno/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_sperror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_clnt_sperror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_auth/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_auth/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_noproc/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_noproc/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_noprog/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_noprog/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_progvers/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_progvers/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_systemerr/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_systemerr/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_weakauth/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_err_svcerr_weakauth/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_registerrpc/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_registerrpc/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_svc_register/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_svc_register/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_svc_unregister/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_svc_unregister/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_xprt_register/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_xprt_register/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_xprt_unregister/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_regunreg_xprt_unregister/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_callrpc/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_control/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_control/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_control/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_freeres/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_freeres/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_geterr/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_clnt_geterr/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_freeargs/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_freeargs/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_freeargs/svc.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getargs/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getargs/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getargs/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getargs/client.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getcaller/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_getcaller/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_sendreply/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_sendreply/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/rpc/rpc_stdcall_svc_sendreply/client.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_addrmanagmt_rpcb_getaddr/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_addrmanagmt_rpcb_getaddr/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_addrmanagmt_rpcb_getaddr/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_addrmanagmt_rpcb_getmaps/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_addrmanagmt_rpcb_getmaps/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authdes_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authdes_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authdes_seccreate/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authdes_seccreate/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authnone_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authnone_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authsys_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authsys_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authsys_create_default/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_auth_authsys_create_default/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_dg_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_dg_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_dg_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_vc_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_vc_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_clnt_vc_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_dg_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_dg_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_dg_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_vc_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_vc_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_bottomlevel_svc_vc_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_pcreateerror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_pcreateerror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perrno/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perrno/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perrno/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perror/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perror/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_clnt_perror/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_noproc/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_noproc/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_noprog/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_noprog/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_progvers/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_progvers/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_systemerr/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_systemerr/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_weakauth/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_err_svcerr_weakauth/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_tli_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_tli_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_clnt_tli_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_rmtcall/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_set/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_set/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_unset/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_rpcb_unset/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_reg/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_reg/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_reg/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_reg/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_tli_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_tli_create/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_tli_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_unreg/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_unreg/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_unreg/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_expertlevel_svc_unreg/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_control/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_control/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_control/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_tp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_tp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_tp_create_timed/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_tp_create_timed/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_clnt_tp_create_timed/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_svc_tp_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_interlevel_svc_tp_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_broadcast_exp/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_reg/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_reg/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_reg/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_simple_rpc_reg/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/2-stress.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/4-mt.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/5-scalability.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/6-dataint.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/7-performance.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/8-complex.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_call/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_create_timed/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_create_timed/3-limits.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_create_timed/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_destroy/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_clnt_destroy/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_svc_create/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_svc_create/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_svc_destroy/1-basic.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_suite/tirpc/tirpc_toplevel_svc_destroy/assertions.xml
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_svc_1/rpc_svc_1.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/rpc_svc_2/rpc_svc_2.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_1/tirpc_svc_1.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_11/tirpc_svc_11.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_2/tirpc_svc_2.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_3/tirpc_svc_3.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_4/tirpc_svc_4.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_5/tirpc_svc_5.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_6/tirpc_svc_6.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_7/tirpc_svc_7.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_8/tirpc_svc_8.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tests_pack/tirpc_svc_9/tirpc_svc_9.c
ltp/testcases/network/rpc/rpc-tirpc-full-test-suite/tsLogParser/rpc_ts.mod.php

7) Log Message:
The idea of the patch is "to make things that should be extern, extern". The means to do this are: 
1. Explicitly declaring variables extern in some places.
2. Defining _USC_LIB_ where appropriate.

My understanding of _USC_LIB_ define is that it exists so the usctest.h header can be included in a lib or non-test source file where you want to use extern declarations of TEST_RETURN, TEST_ERRNO etc. to avoid having a copy of the variable in your library and a copy of the variable in your test. I've added -D_USC_LIB_ to the CFLAGS of library code where necessary, by, Will Newton <will.newton@gmail.com>

Modified File(s):
ltp/testcases/kernel/mem/hugetlb/lib/Makefile
ltp/testcases/kernel/syscalls/ipc/lib/Makefile
ltp/testcases/kernel/syscalls/ipc/lib/ipcmsg.h
ltp/testcases/kernel/syscalls/ipc/lib/ipcsem.h
ltp/testcases/kernel/syscalls/kill/kill05.c
ltp/testcases/kernel/syscalls/kill/kill07.c
ltp/testcases/kernel/syscalls/lib/Makefile
ltp/testcases/kernel/syscalls/nftw/lib.c
ltp/testcases/network/sctp/testlib/Makefile

8) Log Message:
Add 2 scripts for detecting features used by some tests, namely:
- support for pthread_mutexattr_setprotocol(..., PTHREAD_PRIO_INHERIT)
- support for pthread_mutexattr_setrobust_np()
Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Added Files:
ltp/testcases/realtime/scripts/check_pi.sh
ltp/testcases/realtime/scripts/check_robust.sh

9) Log Message:
Add Makefiles to all the realtime testcases without any autotools dependencies. Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Added Files:
ltp/testcases/realtime/Makefile
ltp/testcases/realtime/config.mk
ltp/testcases/realtime/func/Makefile
ltp/testcases/realtime/func/async_handler/Makefile
ltp/testcases/realtime/func/gtod_latency/Makefile
ltp/testcases/realtime/func/hrtimer-prio/Makefile
ltp/testcases/realtime/func/matrix_mult/Makefile
ltp/testcases/realtime/func/measurement/Makefile
ltp/testcases/realtime/func/periodic_cpu_load/Makefile
ltp/testcases/realtime/func/pi-tests/Makefile
ltp/testcases/realtime/func/pi_perf/Makefile
ltp/testcases/realtime/func/prio-preempt/Makefile
ltp/testcases/realtime/func/prio-wake/Makefile
ltp/testcases/realtime/func/pthread_kill_latency/Makefile
ltp/testcases/realtime/func/sched_football/Makefile
ltp/testcases/realtime/func/sched_jitter/Makefile
ltp/testcases/realtime/func/sched_latency/Makefile
ltp/testcases/realtime/func/thread_clock/Makefile
ltp/testcases/realtime/lib/Makefile
ltp/testcases/realtime/perf/Makefile
ltp/testcases/realtime/perf/latency/Makefile
ltp/testcases/realtime/stress/Makefile
ltp/testcases/realtime/stress/pi-tests/Makefile

10) Log Message:
Remove autotools stuff:
- autogen.sh
- configure.ac
- configure
- aclocal.m4
- config/*
- all the GNUmakefile.am
- all the GNUmakefile.in

Also adapt testscripts/test_realtime.sh to the new build system. Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Modified Files:
ltp/testscripts/test_realtime.sh
Removed Files:
ltp/testcases/realtime/GNUmakefile.am
ltp/testcases/realtime/GNUmakefile.in
ltp/testcases/realtime/aclocal.m4
ltp/testcases/realtime/autogen.sh
ltp/testcases/realtime/configure
ltp/testcases/realtime/configure.ac
ltp/testcases/realtime/config/GNUmakefile.am
ltp/testcases/realtime/config/GNUmakefile.in
ltp/testcases/realtime/config/autoconf/compile
ltp/testcases/realtime/config/autoconf/config.guess
ltp/testcases/realtime/config/autoconf/config.sub
ltp/testcases/realtime/config/autoconf/depcomp
ltp/testcases/realtime/config/autoconf/install-sh
ltp/testcases/realtime/config/autoconf/missing
ltp/testcases/realtime/func/GNUmakefile.am
ltp/testcases/realtime/func/GNUmakefile.in
ltp/testcases/realtime/func/async_handler/GNUmakefile.am
ltp/testcases/realtime/func/async_handler/GNUmakefile.in
ltp/testcases/realtime/func/gtod_latency/GNUmakefile.am
ltp/testcases/realtime/func/gtod_latency/GNUmakefile.in
ltp/testcases/realtime/func/hrtimer-prio/GNUmakefile.am
ltp/testcases/realtime/func/hrtimer-prio/GNUmakefile.in
ltp/testcases/realtime/func/matrix_mult/GNUmakefile.am
ltp/testcases/realtime/func/matrix_mult/GNUmakefile.in
ltp/testcases/realtime/func/measurement/GNUmakefile.am
ltp/testcases/realtime/func/measurement/GNUmakefile.in
ltp/testcases/realtime/func/periodic_cpu_load/GNUmakefile.am
ltp/testcases/realtime/func/periodic_cpu_load/GNUmakefile.in
ltp/testcases/realtime/func/pi-tests/GNUmakefile.am
ltp/testcases/realtime/func/pi-tests/GNUmakefile.in
ltp/testcases/realtime/func/pi_perf/GNUmakefile.am
ltp/testcases/realtime/func/pi_perf/GNUmakefile.in
ltp/testcases/realtime/func/prio-preempt/GNUmakefile.am
ltp/testcases/realtime/func/prio-preempt/GNUmakefile.in
ltp/testcases/realtime/func/prio-wake/GNUmakefile.am
ltp/testcases/realtime/func/prio-wake/GNUmakefile.in
ltp/testcases/realtime/func/pthread_kill_latency/GNUmakefile.am
ltp/testcases/realtime/func/pthread_kill_latency/GNUmakefile.in
ltp/testcases/realtime/func/sched_football/GNUmakefile.am
ltp/testcases/realtime/func/sched_football/GNUmakefile.in
ltp/testcases/realtime/func/sched_jitter/GNUmakefile.am
ltp/testcases/realtime/func/sched_jitter/GNUmakefile.in
ltp/testcases/realtime/func/sched_latency/GNUmakefile.am
ltp/testcases/realtime/func/sched_latency/GNUmakefile.in
ltp/testcases/realtime/func/thread_clock/GNUmakefile.am
ltp/testcases/realtime/func/thread_clock/GNUmakefile.in
ltp/testcases/realtime/include/GNUmakefile.am
ltp/testcases/realtime/include/GNUmakefile.in
ltp/testcases/realtime/lib/GNUmakefile.am
ltp/testcases/realtime/lib/GNUmakefile.in
ltp/testcases/realtime/perf/GNUmakefile.am
ltp/testcases/realtime/perf/GNUmakefile.in
ltp/testcases/realtime/perf/latency/GNUmakefile.am
ltp/testcases/realtime/perf/latency/GNUmakefile.in
ltp/testcases/realtime/stress/GNUmakefile.am
ltp/testcases/realtime/stress/GNUmakefile.in

11) Log Message:
Forgot to remove include/rttests_config.h.in in the previous patch. Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Removed Files:
ltp/testcases/realtime/include/rttests_config.h.in

12) Log Message:
Fix by Michael Olbrich <m.olbrich@pengutronix.de>, as, Sebastien´s Patch [[PATCH 3/3] [Realtime] Remove autotools specific stuff] applied on 24/03/2008 breaks this script.

Modified File(s):
ltp/testcases/realtime/run.sh

13) Log Message:
Usually the cross compiler is set from the toplevel directory by setting the CROSS_COMPILER variable. This makefile tries to overwrite it, but wrong. It is also possible to push in CFLAGS from the toplevel by using CROSS_CFLAGS. We should use these here as well. Finally, LDFLAGS are set here but not used by the makefiles. Moving the posix libs to LDLIBS makes it build. Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>

Modified File(s):
ltp/testcases/realtime/config.mk

14) Log Message:
This patch updates the matrix_mult testcase to closely follow the JVM in the concurrent case. So in the concurrent case we have 'numcpus-1' concurrent threads that are handed out work by the main thread and once we run out of concurrent threads, the main thread does the work itself. Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/matrix_mult/matrix_mult.c

15) Log Message:
mmap1.c:524: warning: format '%ld' expects type 'long int', but argument 3 has type 'double'
which actually prints as:
WARNING: bad argument. Using default 1125899906842624

Fix disktest printf format warnings (on Linux; no idea about Windows):
childmain.c:443: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
childmain.c:443: warning: format '%X' expects type 'unsigned int', but argument 5 has type 'size_t'
childmain.c:445: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
childmain.c:448: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
childmain.c:451: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Modified File(s):
ltp/testcases/kernel/io/disktest/childmain.h
ltp/testcases/kernel/mem/mtest06/mmap1.c

16) Log Message:
All the syslog test cases in ltp-full-20080131 are failing for RHEL4U5 on x3850 M2 architecture. The syslogtst is failing because when only 1 argument is passed to syslogtst the condition in the test case fails to deal with it. I have tested the failed tests cases after applying the patch on the same architecture(x3850M2) and found its passing. Signed-off-by : Vinay Sridhar <vinaysridhar@in.ibm.com>

Modified File(s):
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

17) Log Message:
The filename arguments in some output messages are wrong. Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Modified File(s):
ltp/testcases/kernel/syscalls/inotify/inotify02.c

18) Log Message:
Fixes a minor issue with pi_perf testcase (testcases/realtime/func/). The wait_dat is intended to measure the amount of time it took for the high priority thread to actually obtain the lock from the time it was released by the low priority thread. The patch fixes this computation to measure it more accurately. The PASS/FAIL computation is unaffected. Signed-off-by: Ankita Garg <ankita@in.ibm.com>, Acked-by: Sripathi Kodi <sripathik@in.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/pi_perf/pi_perf.c

19) Log Message:
The vmsplice01 testcase in LTP failed when run over machines with NFS mount. However after I examined the test case I found that the testcase performs vmsplice() and splice() system calls and it was only splice() that caused the failure. After discussing with Subrata, we had decided that the fact that vmsplice() succeeds must be displayed before checking if the testcase is running over NFS and exiting. Hence I have prepared a patch with the above details taken care of. Signed-off-by : Vinay Sridhar <vinaysridhar@in.ibm.com>

Modified File(s):
ltp/testcases/kernel/syscalls/vmsplice/vmsplice01.c

20) Log Message:
faccessat01 and fchmodat01 did not test the AT_FDCWD tests, but assigned fds[5]. I made them work, patch attached. btw, readlinkat01 is also buggy, but I have not yet come around to fixing it. By, Marcus Meissner <marcusmeissner@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/syscalls/faccessat/faccessat01.c
ltp/testcases/kernel/syscalls/fchmodat/fchmodat01.c

21) Log Messsage:
Some newer glibcs do not like sprintf() printing a string into itself and loop. By, Marcus Meissner <marcusmeissner@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/syscalls/nftw/lib.c
ltp/testcases/kernel/syscalls/nftw/lib64.c

22) Log Message:
some more "variable is used uninitialized" warnings fixed with this patch, by, Marcus Meissner <marcusmeissner@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/fs/doio/doio.c
ltp/testcases/kernel/syscalls/sysctl/sysctl05.c
ltp/testcases/open_posix_testsuite/conformance/interfaces/pthread_cond_wait/4-1.c

23) Log Message:
This patch fixes some compiler warnings spit out by newer GCCs and fortify source (mostly some initialisations and return value checking), by, Marcus Meissner <marcusmeissner@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/fs/doio/doio.c
ltp/testcases/kernel/fs/doio/iogen.c

24) Log Message:
Various waitpid tests print the PID of the wrong array. fork_kid_pid[j] is accessed just past the end of the fork_kid_pid array, so it is better to use wait_kid_pid[i] instead, by, Marcus Meissner <marcusmeissner@users.sourceforge.net>

Modified File(s):
ltp/testcases/kernel/syscalls/waitpid/waitpid06.c
ltp/testcases/kernel/syscalls/waitpid/waitpid07.c
ltp/testcases/kernel/syscalls/waitpid/waitpid08.c
ltp/testcases/kernel/syscalls/waitpid/waitpid11.c
ltp/testcases/kernel/syscalls/waitpid/waitpid12.c
ltp/testcases/kernel/syscalls/waitpid/waitpid13.c

25) Log Message:
When I was compiling ltp-full-20080229/kernel/module/, error occured. The error like this: ...
scripts/Makefile.build:46: *** CFLAGS was changed in"ltp-full-20080229/testcases/kernel/module/delete_module/Makefile".Fix it to use EXTRA_CFLAGS. Stop.
The reason is: When we build an External module, we should use EXTRA_CFLAGS, not CFLAGS. In detail please refer to Documentation/kbuild/modules.txt. In addition,there are some trashy "include" such as:
"#include <asm/atomic.h>" in delete_module01.c
"#include <linux/config.h>" in dummy_del_mod.c
The following patch solves these problems:
Signed-off-by: Wang Fang <wangf@cn.fujitsu.com>

Modified File(s):
ltp/testcases/kernel/module/delete_module/Makefile
ltp/testcases/kernel/module/delete_module/delete_module01.c
ltp/testcases/kernel/module/delete_module/delete_module02.c
ltp/testcases/kernel/module/delete_module/delete_module03.c
ltp/testcases/kernel/module/delete_module/dummy_del_mod.c
ltp/testcases/kernel/module/delete_module/dummy_del_mod_dep.c

26) Log Message:
The ltp-full-20080229/testcases/kernel/module/delete_module/Makefile will do this:
   @set -e; for i in $(MODULES); do ln -f $$i /tmp/$$i ; done
If the ltp directory and /tmp are not in the same device, an error occurs:
   ln: creating hard link `/tmp/xxx' => `xxx': Invalid cross-device link I suffer from this.
The patch as follows:
Signed-off-by: Wang Fang <wangf@cn.fujitsu.com>

Modified File(s):
ltp/testcases/kernel/module/delete_module/Makefile

27) Log Message:
The memsize is specified by the user in Mb, but it is converted to Kb in the script, so we should convert it to Mb in the output. The following patch solves this problem: igned-off-by: Wang Fang <wangf@cn.fujitsu.com>

Modified File(s):
ltp/testscripts/ltpstress.sh

28) Log Message:
The 9th testcase of inotify02 failed due to event coalescence. We fix this by moving the IN_DELETE test in between of the 2 IN_MOVE_SELF events. Also add the test for event coalescence. Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

File(s) Modified:
ltp/testcases/kernel/syscalls/inotify/README
ltp/testcases/kernel/syscalls/inotify/inotify02.c

29) Log Message:
I ran the latest LTP(ltp-20080131) on SLES10SP1 and found a failure on the syslog testcases because of getting SIGSEGV at line 79 of testcases/kernel/syscalls/syslog/syslogtst.c.  it is caused by accessing to the second argument when only one argument is provided for syslogtst, by, jburke@redhat.com & a-tsuji@bk.jp.nec.com

Modified File(s):
ltp/testcases/kernel/syscalls/syslog/syslogtst.c

30) Log Message:
A few POSIX fixes from Dustin Kirkland in [1908313]

Modified File(s):
ltp/IDcheck.sh
ltp/runltp
ltp/runltplite.sh

31) Log Message:
cleanup build system a bit

Removed File(s):
gotlibcap.c nolibcap.c

32) Log Message:
When CREATE is not set there is no default, so it is possible to run into the test(1) statement in line 116 with an undefined CREATE, which lets test break. Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>

Modified File(s):
ltp/IDcheck.sh 

33) Log Message:
Update file capabilities tests to work on 64-bit kernels.  It switches from manually setting file xattrs to making use of libcap, by,  Serge E. Hallyn <serue@us.ibm.com>

Modified Files:
ltp/testcases/kernel/security/filecaps/Makefile
ltp/testcases/kernel/security/filecaps/verify_caps_exec.c
Added Files:
ltp/testcases/kernel/security/filecaps/makenumcapsh.c

34) Log Message:
1. Minor fixes:
        Added -i to have the number of iterations configurable. However, this number cannot be less than 100 else a calloc fails in init_stat* function, causing sigsegv afterward. The patch also adds the return code checking for these init_stat functions. Added -m args is to have the PASS/FAIL criteria configurable. 
2. Bug fix: disk write access deadlock
        High prio busy thread hogged cpus forbidding kjournald and pdflush daemons to release filesystem locks. This caused timer_thread to hang waiting for the lock.
Signed-off-by: Gilles Carry <gilles.carry@bull.net>

Modified Files:
ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c
ltp/testcases/realtime/func/thread_clock/tc-2.c

35) Log Message:
1. Whitespaces cleanup
2. Error checks when initializing stat containers
Signed-off-by: Gilles Carry <gilles.carry@bull.net>

Modified Files:
ltp/testcases/realtime/func/matrix_mult/matrix_mult.c

36) Log Message:
In a lot of cases, we do not really care about the samples and histogram files and their associated gnuplot command files or do not want to save them for example on embedded platforms with limited or no storage. This patch disables generating those files by default and introduce a new parameter to the tests, namely '-s', for when we really want to. Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>

Modified Files:
ltp/testcases/realtime/include/libstats.h
ltp/testcases/realtime/lib/librttest.c
ltp/testcases/realtime/lib/libstats.c

37) Log Message:
1) This patch fixes a concurrency issue in shmctl02. Same issue as in shmat02,
2) Fix return value check from shmat. In case of error, this wrong check was leading to a seg-fault. Same problem as in kill05,
3) Fixes a concurrency issue in shmget02. Same issue as in shmat02 : second key can conflict with the key from another process, 
4) Fix a NFS warning when running rename14 concurrently. In this case, due to the large number of running processes and scheduler decisions, the father task can exit before its sons. Thus, leading to the removal of a file still opened by a son... NFS don't like that, 
Signed-off-by: Renaud Loittiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl02.c
ltp/testcases/kernel/syscalls/ipc/shmdt/shmdt01.c
ltp/testcases/kernel/syscalls/ipc/shmget/shmget02.c
ltp/testcases/kernel/syscalls/rename/rename14.c

38) Log Message:
Fixing a concurrency issue in semctl07.c. This test was using a key hard coded in the source code, leading to conflicts with other instances of the same test. This patch also add a cleanup of the semid in case of failure during the test, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com> 

Modified Files:
ltp/testcases/kernel/syscalls/ipc/semctl/semctl07.c


39) Log Message:
Fixing a concurrency issue in semop02.c. The now, well known issue due to a second key badly created, by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/semop/semop02.c

40) Log Message:
Fixes a concurrency issue in semctl01. This test was using usleep to synchronize tasks. On a heavily loaded system, this synchronization is not enough to ensure execution correctness. This patch is a bit more intrusive than my previous ones.
Patch content :
* Define 2 new functions in kernel/syscalls/lib/libtestsuite.c, used to
* synchronize a father and a son using pipes.
    - create_sync_pipes: create a pair of pipes used for the synchronization,
    - wait_son_startup: function used in the father to wait for its son to start ts execution,
    - notify_startup: function used in the son to notify it has started its execution,
* Add a kernel/syscalls/lib/libtestsuite.h file to cleanly export newly
* defines functions,
* Fix the semctl01test. The idea used to synchronize : 
   - For each task created, the father waits for the son to start its execution using the newly define functions,
   - After the last son has been created, the father do a sleep(1) to give time to the sons to execute the semop function,
The final sleep does not guaranty the sons will have time to do the semop. On a REALLY heavily loaded system, this will still fail... The only solution I see to be sure the son is really blocked on the semop before the father continue its execution it to use the wchan info from /proc/<pid>/wchan file..., by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/semctl/Makefile
ltp/testcases/kernel/syscalls/ipc/semctl/semctl01.c
ltp/testcases/kernel/syscalls/lib/libtestsuite.c

41) Log Message:
Fixing some NFS issue(s),  by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/fchownat/fchownat01.c

42) Log Message:
Fix directory remove issue on NFS. On NFS unlinking AND closing all files in a directory is mandaroty before unlinking this directory. This also fix a write in a invalid array entry. fds[5] does not exist since we only defines 5 tests., by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/fchmodat/fchmodat01.c

Added Files:
ltp/testcases/kernel/syscalls/lib/libtestsuite.h

43) Log Message:
Fix directory remove issue on NFS. On NFS unlinking AND closing all files in a directory is mandaroty before unlinking this directory. This also fix a write in a invalid array entry. fds[5] does not exist since we only defines 5 tests., by, Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified Files:
ltp/testcases/kernel/syscalls/faccessat/faccessat01.c

44) Log Message:
LTP is failing to compile with GCC 3.3.3 due to Makefile's inconsistency. SLES9.X distros are affected by this problem.  This patch fixes how /lib/ipcmsg.h header file is referenced. It works fine with GCC 3.4.X, however, compiling headers doesn't make any sense to me. Signed-off-by: Rafael Folco <rfolco@linux.vnet.ibm.com>

Modified Files:
ltp/testcases/kernel/syscalls/ipc/msgctl/Makefile
ltp/testcases/kernel/syscalls/ipc/msgget/Makefile

45) Log Message:
Fixes the hardcoded file descriptor in the second testcase within dup203.c. Instead of assuming file descriptor 10 is closed, the fix explicitly opens and closes a file descriptor before using it as the second argument of dup2(). We saw issues on some environments where dup2(10,10) was being called, which this fixes, by, Henry Wei <hyei@mvista.com>

Modified Files:
ltp/testcases/kernel/syscalls/dup2/dup203.c

46) Log Message:
We have seen that prio_preempt testcase that is part of realtime tests occasionally hangs. This can be easily recreated on a 8-cpu system, but can be recreated on a 4-cpu system as well when run for a number of iterations. The problem occurs because the first worker thread sometimes fails to call cond_wait on the condvar through which the master thread signals it to start. Since the first thread needs to start the chain of signalling from then on, all other threads just sit in a cond_wait without ever being woken up. The fix is to have a barrier to ensure that the first worker thread doesn't miss the cond_signal. I have tested this patch by running 10s of thousands of iterations of the testcase. Without the patch I can recreate the problem fairly easily, by, Sripathi Kodi <sripathik@in.ibm.com>

Modified Files:
ltp/testcases/realtime/func/prio-preempt/prio-preempt.c

47) Log Message:
Fixing Build Failures on Fedora Machine, by, psuriset@linux.vnet.ibm.com

Modified Files:
ltp/testcases/kernel/numa/test.sh


--=-Ozc50YT/RqRWYJ3K2HxL--

