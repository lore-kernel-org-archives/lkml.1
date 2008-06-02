Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYFBNqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYFBNqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYFBNpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:45:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42116 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906AbYFBNpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:45:42 -0400
Subject: [LTP] [ANNOUNCE] The Linux Test Project has been Released for MAY
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, Avantika Mathur <mathur@us.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-pUv9mS0iECL1n2SLdqSE"
Organization: IBM
Date: Mon, 02 Jun 2008 19:15:17 +0530
Message-Id: <1212414317.4784.31.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pUv9mS0iECL1n2SLdqSE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear All,

The Linux Test Project test suite has been released for the month of
MAY 2008. The latest version of the test-suite contains 3000+ tests
for the Linux OS and can be found at
http://ltp.sourceforge.net/.
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.


MAY 2008 Highlights:

* Addition of FILESYSTEM BIND MOUNT tests,
* Addition of 2nd Set of Memory Controller Test Cases,
* Added Default Log File generation capability,
* Stable Release of LTP-DEVEL-2.0.0.0 RPM Packages for
i386,ia64,ppc64,x86_64 & s390x,
* FCNTL LOCKTESTS updates,
* Update to OpenHPI 2.10.2,
* Continuing work for Concurrency fixes,
* Cleanup/Updates to LTP Real Time test cases,


Note(s) from the Maintainer:

Continuing with our endeavor to improve kernel code coverage, we will
see some new test cases getting added to LTP in June 2008. But we would
probably need much much more test cases in LTP to compete the pace of
growing kernel. And this is becoming difficult with each passing day. We
need to address this through multiple efforts, namely:

1) Invest more time in writing new test cases,
2) Searching existing testcases available from various locations, that
can be a potential candidate to add to LTP under GPLv2,
3) Dig out unit test cases from developerś desktop and put it in LTP.

Much of these efforts will also depend on preventing the Linux Testing
community to fragment further, identify areas where all Linux testing
projects can collaborate and complement each otherś importance, and work
together for achieving the ultimate goal to make Linux better.

>From this release onwards, we will also announce the significant
contribution of this month, which happens to be the File System Bind
Mount tests from Matt Helsley & Avantika Mathur. Thank you. Equally
important has been huge contributions from others in terms of new test
cases and Patches to fix existing test cases.

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

Please also see the Change Log Attached (MAY 2008):

Happy testing, 
Regards-- 
Subrata,

--=-pUv9mS0iECL1n2SLdqSE
Content-Disposition: attachment; filename=May-2008_Changelog.txt
Content-Type: text/plain; name=May-2008_Changelog.txt; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1) Log Message:
Following patch makes ballista test suite compile with gcc-4.3, without thi=
s it completely fails because of C++ cleanups introduced with gcc-4.3. By C=
aglar Onur <caglar@pardus.org.tr>

Modified File(s):
ltp/testcases/ballista/ballista/ballista.cpp
ltp/testcases/ballista/ballista/ballistaUtil.cpp
ltp/testcases/ballista/ballista/callGen.cpp
ltp/testcases/ballista/ballista/callGen_standAlone.cpp
ltp/testcases/ballista/ballista/create_code.pl
ltp/testcases/ballista/ballista/create_code_standAlone.pl
ltp/testcases/ballista/ballista/executeTestCase.cpp
ltp/testcases/ballista/ballista/executeTestCase.fresh
ltp/testcases/ballista/ballista/genCode.cpp
ltp/testcases/ballista/ballista/genCodeCreator.cpp
ltp/testcases/ballista/ballista/line.cpp
ltp/testcases/ballista/ballista/line.h
ltp/testcases/ballista/ballista/match.cpp
ltp/testcases/ballista/ballista/parseArguments.cpp
ltp/testcases/ballista/ballista/replacer.cpp
ltp/testcases/ballista/ballista/selfHost.cpp
ltp/testcases/ballista/ballista/serverCommunication.cpp
ltp/testcases/ballista/ballista/testCaseIterator.cpp
ltp/testcases/ballista/ballista/testCaseIterator.h
ltp/testcases/ballista/ballista/compile/bparser.cpp
ltp/testcases/ballista/ballista/templates/bTypes.cpp

2) Log Message:
The fixed address passed to mmap() should be aligned to the value of SHMLBA=
 as defined in sys/shm.h. See Documentation/cachetlb.txt in the kernel for =
the explanation behind this. On most architectures this value is the page s=
ize, but not on all. Signed-off-by: Martin Habets <errandir_news@mph.eclips=
e.co.uk>

Modified File(s):
ltp/testcases/kernel/mem/shmt/shmt09.c
ltp/testcases/kernel/syscalls/mmap/mmap01.c

3) Log Message:
These test cases fail on the NFS environment due to NFS relates issue(s). H=
ence abondon these tests when NFS is detected. By, Sridhar Vinay <vinaysrid=
har@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/fcntl/fcntl14.c
ltp/testcases/kernel/syscalls/fcntl/fcntl23.c
ltp/testcases/kernel/syscalls/fcntl/fcntl24.c
ltp/testcases/kernel/syscalls/fcntl/fcntl25.c
ltp/testcases/kernel/syscalls/fcntl/fcntl26.c
ltp/testcases/kernel/syscalls/splice/splice01.c
ltp/testcases/kernel/syscalls/tee/tee01.c
ltp/testcases/kernel/syscalls/utime/utime01.c
ltp/testcases/kernel/syscalls/utime/utime02.c
ltp/testcases/kernel/syscalls/utime/utime03.c
ltp/testcases/network/nfs/nfs01/nfs01

4) Log Message:
Update to OpenHPI 2.10.1 (see www.openhpi.org for more info)

Modified Files:
ltp/testcases/open_hpi_testsuite/Makefile.am
ltp/testcases/open_hpi_testsuite/Makefile.in
ltp/testcases/open_hpi_testsuite/configure
ltp/testcases/open_hpi_testsuite/configure.ac
ltp/testcases/open_hpi_testsuite/openhpi.conf.example
ltp/testcases/open_hpi_testsuite/openhpi.spec.in
ltp/testcases/open_hpi_testsuite/clients/Makefile.in
ltp/testcases/open_hpi_testsuite/clients/hpiel.c
ltp/testcases/open_hpi_testsuite/clients/hpievents.c
ltp/testcases/open_hpi_testsuite/clients/hpipower.c
ltp/testcases/open_hpi_testsuite/cpp/Makefile.in
ltp/testcases/open_hpi_testsuite/cpp/t/Makefile.in
ltp/testcases/open_hpi_testsuite/docs/Makefile.am
ltp/testcases/open_hpi_testsuite/docs/Makefile.in
ltp/testcases/open_hpi_testsuite/docs/hld/Makefile.am
ltp/testcases/open_hpi_testsuite/docs/hld/Makefile.in
ltp/testcases/open_hpi_testsuite/docs/hld/appendix.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/authors.dtd
ltp/testcases/open_hpi_testsuite/docs/hld/bookinfo.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/introduction.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/legal.dtd
ltp/testcases/open_hpi_testsuite/docs/hld/obtaining.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/openhpi-manual.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/openhpi_highlevel.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/openhpi_structure.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/plugin_guide.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/plugin_usage.sgml
ltp/testcases/open_hpi_testsuite/docs/hld/revisions.dtd
ltp/testcases/open_hpi_testsuite/docs/hld/sahpi_breakdown.sgml
ltp/testcases/open_hpi_testsuite/docs/man/Makefile.in
ltp/testcases/open_hpi_testsuite/hpi_shell/Makefile.am
ltp/testcases/open_hpi_testsuite/hpi_shell/Makefile.in
ltp/testcases/open_hpi_testsuite/hpi_shell/commands.c
ltp/testcases/open_hpi_testsuite/hpi_shell/ctrl_inv.c
ltp/testcases/open_hpi_testsuite/hpi_shell/hpi_cmd.h
ltp/testcases/open_hpi_testsuite/hpi_shell/sensor.c
ltp/testcases/open_hpi_testsuite/hpi_shell/session.c
ltp/testcases/open_hpi_testsuite/hpi_ui_lib/Makefile.in
ltp/testcases/open_hpi_testsuite/hpi_ui_lib/service.c
ltp/testcases/open_hpi_testsuite/hpi_ui_lib/show.c
ltp/testcases/open_hpi_testsuite/marshal/Makefile.in
ltp/testcases/open_hpi_testsuite/marshal/connection.c
ltp/testcases/open_hpi_testsuite/marshal/marshal.c
ltp/testcases/open_hpi_testsuite/marshal/marshal_hpi_types.c
ltp/testcases/open_hpi_testsuite/marshal/marshal_hpi_types.h
ltp/testcases/open_hpi_testsuite/marshal/strmsock.cpp
ltp/testcases/open_hpi_testsuite/marshal/t/Makefile.am
ltp/testcases/open_hpi_testsuite/marshal/t/Makefile.in
ltp/testcases/open_hpi_testsuite/marshal/t/float_format.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_012.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_013.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_014.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_015.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_016.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_017.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_018.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_028.c
ltp/testcases/open_hpi_testsuite/openhpid/Makefile.am
ltp/testcases/open_hpi_testsuite/openhpid/Makefile.in
ltp/testcases/open_hpi_testsuite/openhpid/openhpiclient.cpp
ltp/testcases/open_hpi_testsuite/openhpid/openhpid.cpp
ltp/testcases/open_hpi_testsuite/plugins/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/ipmi/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/ipmi/t/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_discover.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_domain.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_log.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_mc_vendor.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_resource.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_sdr.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/ipmi_sensor_hotswap.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/thread.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/rtas/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/simulator/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/simulator/t/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/sysfs/Makefile.in
ltp/testcases/open_hpi_testsuite/plugins/watchdog/Makefile.in
ltp/testcases/open_hpi_testsuite/scripts/Makefile.in
ltp/testcases/open_hpi_testsuite/scripts/test/Makefile.in
ltp/testcases/open_hpi_testsuite/scripts/test/conformance_report.pl
ltp/testcases/open_hpi_testsuite/scripts/test/coverage_report.pl
ltp/testcases/open_hpi_testsuite/scripts/test/gcov2html.pl
ltp/testcases/open_hpi_testsuite/scripts/test/generate_index.pl
ltp/testcases/open_hpi_testsuite/scripts/test/gsum2html.pl
ltp/testcases/open_hpi_testsuite/scripts/test/testconformance.pl
ltp/testcases/open_hpi_testsuite/scripts/test/testcoverage.pl
ltp/testcases/open_hpi_testsuite/snmp/Makefile.in
ltp/testcases/open_hpi_testsuite/src/Makefile.in
ltp/testcases/open_hpi_testsuite/src/config.c
ltp/testcases/open_hpi_testsuite/src/event.c
ltp/testcases/open_hpi_testsuite/src/safhpi.c
ltp/testcases/open_hpi_testsuite/src/t/Makefile.in
ltp/testcases/open_hpi_testsuite/src/t/ohpi/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/sahpi_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/sahpi_enum_utils.h
ltp/testcases/open_hpi_testsuite/utils/sahpi_struct_utils.c
ltp/testcases/open_hpi_testsuite/utils/sahpi_struct_utils.h
ltp/testcases/open_hpi_testsuite/utils/uid_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/ann/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/el/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/epath/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/rpt/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/Makefile.in
ltp/testcases/open_hpi_testsuite/utils/t/uid/Makefile.in

Added Files:
ltp/testcases/open_hpi_testsuite/hpi_shell/dimi.c
ltp/testcases/open_hpi_testsuite/hpi_shell/fumi.c

Removed Files:
ltp/testcases/open_hpi_testsuite/openhpi.spec
ltp/testcases/open_hpi_testsuite/hpi_shell/hpi_cmd
ltp/testcases/open_hpi_testsuite/hpi_shell/openhpiclient.cpp
ltp/testcases/open_hpi_testsuite/hpi_shell/openhpiclient.h
ltp/testcases/open_hpi_testsuite/marshal/t/connection.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal.c
ltp/testcases/open_hpi_testsuite/marshal/t/marshal_hpi_types.c
ltp/testcases/open_hpi_testsuite/openhpid/alarm.c
ltp/testcases/open_hpi_testsuite/openhpid/config.c
ltp/testcases/open_hpi_testsuite/openhpid/domain.c
ltp/testcases/open_hpi_testsuite/openhpid/event.c
ltp/testcases/open_hpi_testsuite/openhpid/hotswap.c
ltp/testcases/open_hpi_testsuite/openhpid/init.c
ltp/testcases/open_hpi_testsuite/openhpid/lock.c
ltp/testcases/open_hpi_testsuite/openhpid/ohpi.c
ltp/testcases/open_hpi_testsuite/openhpid/openhpiclient.h
ltp/testcases/open_hpi_testsuite/openhpid/plugin.c
ltp/testcases/open_hpi_testsuite/openhpid/plugin_static.c
ltp/testcases/open_hpi_testsuite/openhpid/safhpi.c
ltp/testcases/open_hpi_testsuite/openhpid/session.c
ltp/testcases/open_hpi_testsuite/openhpid/threaded.c
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_addr.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_auth.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_cmd.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_con.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_con_lan.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_con_smi.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_log.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_msg.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_sensor_factors.c=
pp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/ipmi_utils.cpp
ltp/testcases/open_hpi_testsuite/plugins/ipmidirect/t/thread.cpp
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/el2event.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/el2event.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_annunciator.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_control.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_discover.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_discover_bc.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_discover_rsa.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_event.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_hotswap.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_inventory.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_power.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_reset.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_resources.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_resources_rsa.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_sel.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_sensor.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_session.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_time.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_utils.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_watchdog.c
ltp/testcases/open_hpi_testsuite/plugins/snmp_bc/t/snmp_bc_xml2event.c
ltp/testcases/open_hpi_testsuite/src/plugin_static.c
ltp/testcases/open_hpi_testsuite/utils/t/ann/announcement_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/el/el_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/epath_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpi_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpi_event_encode.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpi_event_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpi_struct_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpi_time_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/sahpiatca_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/epath/uid_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/epath_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/rpt_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpi_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpi_event_encode.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpi_event_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpi_struct_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpi_time_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/sahpiatca_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/rpt/uid_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/epath_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpi_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpi_event_encode.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpi_event_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpi_struct_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpi_time_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/sahpiatca_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/sahpi/uid_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/epath_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpi_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpi_event_encode.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpi_event_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpi_struct_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpi_time_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/sahpiatca_enum_utils.c
ltp/testcases/open_hpi_testsuite/utils/t/uid/uid_utils.c

5) Log Message:
Added missing break in parse args switch/case. (-s arg). Signed-off-by: Gil=
les Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ibm.=
com>

Modified Files:
ltp/testcases/realtime/lib/librttest.c

6) Log Message:
Modified periodic_cpu_load_single.c. Changed arg -c to -l (calculation per =
loop). In next patch, -c arg is to be used as pass/fail criteria globally f=
or all tests. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. Acked-by=
: Chirag <chirag@linux.vnet.ibm.com>

Modified Files:
ltp/testcases/realtime/func/periodic_cpu_load/periodic_cpu_load_single.c

7) Log Message:
Added -c arg into rt_init of librttest.c so all tests can use it. This arg =
sets the global variable (double) pass_criteria. librttest.h declares pass_=
criteria as external. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. =
Acked-by: Chirag <chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/include/librttest.h
ltp/testcases/realtime/lib/librttest.c

8) Log Message:
Modified prio-preempt.c to consider pass criteria (-c) arg. Signed-off-by: =
Gilles Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.i=
bm.com>.

Modified Files:
ltp/testcases/realtime/func/prio-preempt/prio-preempt.c

9) Log Message:
Modified pthread_kill_latency.c to consider pass criteria (-c) arg. Signed-=
off-by: Gilles Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linu=
x.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/pthread_kill_latency/pthread_kill_latency.c

10) Log Message:
Modified matrix_mult.c to consider pass criteria (-c) arg. Signed-off-by: G=
illes Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ib=
m.com>.

Modified Files:
ltp/testcases/realtime/func/matrix_mult/matrix_mult.c

11) Log Message:
Modified async_handler.c and async_handler_jk.c to consider pass criteria (=
-c) arg. Signed-off-by: Gilles Carry <gilles.carry@bull.net>. Acked-by: Chi=
rag <chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/async_handler/async_handler.c
ltp/testcases/realtime/func/async_handler/async_handler_jk.c

12) Log Message:
Modified pi_perf.c to consider pass criteria (-c) arg. Signed-off-by: Gille=
s Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ibm.co=
m>.

Modified Files:
ltp/testcases/realtime/func/pi_perf/pi_perf.c

13) Log Message:
Modified hrtimer-prio.c to consider pass criteria (-c) arg. Signed-off-by: =
Gilles Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.i=
bm.com>.

Modified Files:
ltp/testcases/realtime/func/hrtimer-prio/hrtimer-prio.c

14) Log Message:
Modified tc-2.c to consider pass criteria (-c) arg. Signed-off-by: Gilles C=
arry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/realtime/func/thread_clock/tc-2.c

15) Log Message:
Modified sched_latency.c to consider pass criteria (-c) arg. Signed-off-by:=
 Gilles Carry <gilles.carry@bull.net>. Acked-by: Chirag <chirag@linux.vnet.=
ibm.com>.

Modified Files:
ltp/testcases/realtime/func/sched_latency/sched_latency.c

16) Log Message:
It seems that hugeshmctl01 doesn't free some hugetlb pages when it fails. p=
s shows that there is still an instance of hugeshmctl01 left even if hugesh=
mctl01 is not running which may attach some hugetlb pages. The problem is d=
ue to the arbitrary usleep time in hugeshmctl01 which results in incorrect =
execution order. The intention of the sleep time is to ensure the children =
call shmat() and pause() before the parent checks shm status and calls stat=
_cleanup(). But there is no absolute assurance that this sleep always works=
. In the failure above, the last child process forked by the parent may not=
 run and call shmat() immediately after it's created. When the parent check=
s shm status, it finds only 3 child attaching the shm instead of 4, so it r=
eports the failure. And then it calls stat_cleanup() to send SIGUSR1 to all=
 children, but since the last child hasn't called pause() yet, SIGUSR1 is h=
andled before pause(). When the last child calls pause(), since there is no=
 further signal to wake it up, it sleeps forever. patch to ensure children =
can receive and handle SIGUSR1 from parent in pause(). The patch is not to =
change the arbitrary usleep time since any time is arbitrary though a large=
 time is more acceptable. The patch is to use sigprocmask() to block SIGUSR=
1 before children sleep for SIGUSR1 from parent, and then call sigsuspend()=
 to unblock SIGUSR1 and sleep for SIGUSR1. By doing so, we may avoid the in=
finite sleep and keeping attached shm forever so that affect other hugetlb =
test. In parent process, aonther sigprocmask() is called before usleep(). T=
his has the same effect of sleep more time. By, shenlinf <shenlinf@cn.ibm.c=
om>=20

Modified File(s):
ltp/testcases/kernel/mem/hugetlb/hugeshmctl/hugeshmctl01.c

17) Log Message:
I am testing ltp-full-20080430. When I execute hugemmap04, hugemmap01 is sh=
own in the output which makes the output confusing. patch to fix the bad na=
me. By, shenlinf <shenlinf@cn.ibm.com>

Modified File(s):
ltp/testcases/kernel/mem/hugetlb/hugemmap/hugemmap04.c

18) Log Message:
punt useless local prototype for fdopen() -- stdio.h already provides this,=
 by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/lib/tst_res.c

19) Log Message:
cleanup CFLAGS handling, by, Mike Frysinger <vapier@users.sourceforge.net>

Modified File(s):
ltp/lib/Makefile

20) Log Message:
tst_require_root(): unify root checking with this function, by, Mike Frysin=
ger <vapier@users.sourceforge.net>

Modified File(s):
ltp/include/test.h

21) Log Message:
tst_require_root(): unify root checking with this function

Modified File(s):
ltp/lib/tst_res.c

22) Log Message:
convert to standard ltp functions, by, Mike Frysinger <vapier@users.sourcef=
orge.net>

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/Makefile
ltp/testcases/kernel/fs/fs_perms/fs_perms.c

23) Log Message:
fix error in previous commit: compare result to expected result, not 0

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/fs_perms.c

24) Log Message:
normalize exit values as expected: 0 means PASS and non-0 means FAIL

Modified File(s):
ltp/testcases/kernel/fs/fs_perms/fs_perms.c
ltp/testcases/kernel/fs/fs_perms/simpletest.sh
ltp/testcases/kernel/fs/fs_perms/testx.c

25) Log Message:
lcov: --norecursion becomes --no-recursion + added docs, by, Peter Oberparl=
eiter <oberpapr@users.sourceforge.net>

Modified File(s):
ltp/utils/analysis/lcov/man/geninfo.1
ltp/utils/analysis/lcov/man/lcov.1
ltp/utils/analysis/lcov/bin/geninfo
ltp/utils/analysis/lcov/bin/lcov

26) Log Message:
Attached is a fixed patch to be applied over 1.8 in cvs. Previous patch mis=
took the return of mknod() for a file descriptor and after the first iterat=
ion, test was using the wrong (closed) file descriptor. This patch uses the=
 correct file descriptor. Thanks Rishikesh for catching my error. By, Henry=
 Yei <hyei@mvista.com>

Modified File(s):
ltp/testcases/kernel/syscalls/sockioctl/sockioctl01.c

27) Log Message:
The problem is because some of the realtime tests can't be compiled on olde=
r distros. We will have to fix this 'properly', taking into account the ker=
nel and glibc versions, as well as the architecture. Until we do that, can =
we disable compiling realtime tests by default? Below is a patch that can d=
o it. Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

Modified File(s):
ltp/testcases/Makefile

28) Log Message:
Fix for some failures by Anoop V Chakkalakkal <anoop.vijayan@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/mem/mtest07/mallocstress.c

29) Log Message:
This patch adds a few tests for a variety of bind mounts. More than just sh=
ared subtrees are involved as plain --bind and plain --move are used. Read-=
only bind mounts are not covered by these tests however. Avantika Mathur or=
iginally wrote the tests. I've ported them to use LTP APIs and conventions.=
 I've also modified Avantika's scripts to try and robustly cleanup after br=
oken tests so that leftover mounts and failures at any point in a test are =
cleaned up thoroughly. I've made what efforts I can to follow the conventio=
ns I found in LTP FAQs and the source however there's alot here so I may ha=
ve missed something. Shared bind mounts were introduced in 2.6.15. Because =
of this we need a tst_kvercmp command which can be invoked from a script. I=
've added this to ltpapicmd.c. This patch applies to the April release of L=
TP. I'll also be posting results for x86, x86_64, and ppc64 on a variety of=
 kernels. In order to highlight the results contributed by this patch I've =
only run this portion of the patched LTP. Comments welcome. Signed-off-by: =
Matt Helsley <matthltc@us.ibm.com>.

Modified Files:
ltp/runltp
ltp/testcases/kernel/fs/Makefile
ltp/tools/apicmds/Makefile
ltp/tools/apicmds/ltpapicmd.c

Added Files:
ltp/runtest/fs_bind
ltp/testcases/kernel/fs/fs_bind/BUGS
ltp/testcases/kernel/fs/fs_bind/CHANGELOG
ltp/testcases/kernel/fs/fs_bind/Makefile
ltp/testcases/kernel/fs/fs_bind/README
ltp/testcases/kernel/fs/fs_bind/TODO
ltp/testcases/kernel/fs/fs_bind/bin/Makefile
ltp/testcases/kernel/fs/fs_bind/bin/check_prop
ltp/testcases/kernel/fs/fs_bind/bin/lockfile
ltp/testcases/kernel/fs/fs_bind/bin/makedir
ltp/testcases/kernel/fs/fs_bind/bin/nsclone.c
ltp/testcases/kernel/fs/fs_bind/bin/setup
ltp/testcases/kernel/fs/fs_bind/bin/setupnslock
ltp/testcases/kernel/fs/fs_bind/bin/smount.c
ltp/testcases/kernel/fs/fs_bind/bind/OO_descriptions.txt
ltp/testcases/kernel/fs/fs_bind/bind/test01
ltp/testcases/kernel/fs/fs_bind/bind/test02
ltp/testcases/kernel/fs/fs_bind/bind/test03
ltp/testcases/kernel/fs/fs_bind/bind/test04
ltp/testcases/kernel/fs/fs_bind/bind/test05
ltp/testcases/kernel/fs/fs_bind/bind/test06
ltp/testcases/kernel/fs/fs_bind/bind/test07
ltp/testcases/kernel/fs/fs_bind/bind/test07-2
ltp/testcases/kernel/fs/fs_bind/bind/test08
ltp/testcases/kernel/fs/fs_bind/bind/test09
ltp/testcases/kernel/fs/fs_bind/bind/test10
ltp/testcases/kernel/fs/fs_bind/bind/test11
ltp/testcases/kernel/fs/fs_bind/bind/test12
ltp/testcases/kernel/fs/fs_bind/bind/test13
ltp/testcases/kernel/fs/fs_bind/bind/test14
ltp/testcases/kernel/fs/fs_bind/bind/test15
ltp/testcases/kernel/fs/fs_bind/bind/test16
ltp/testcases/kernel/fs/fs_bind/bind/test17
ltp/testcases/kernel/fs/fs_bind/bind/test18
ltp/testcases/kernel/fs/fs_bind/bind/test19
ltp/testcases/kernel/fs/fs_bind/bind/test20
ltp/testcases/kernel/fs/fs_bind/bind/test21
ltp/testcases/kernel/fs/fs_bind/bind/test22
ltp/testcases/kernel/fs/fs_bind/bind/test23
ltp/testcases/kernel/fs/fs_bind/bind/test24
ltp/testcases/kernel/fs/fs_bind/cloneNS/OO_descriptions.txt
ltp/testcases/kernel/fs/fs_bind/cloneNS/child01
ltp/testcases/kernel/fs/fs_bind/cloneNS/child02
ltp/testcases/kernel/fs/fs_bind/cloneNS/child03
ltp/testcases/kernel/fs/fs_bind/cloneNS/child04
ltp/testcases/kernel/fs/fs_bind/cloneNS/child05
ltp/testcases/kernel/fs/fs_bind/cloneNS/child06
ltp/testcases/kernel/fs/fs_bind/cloneNS/child07
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent01
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent02
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent03
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent04
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent05
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent06
ltp/testcases/kernel/fs/fs_bind/cloneNS/parent07
ltp/testcases/kernel/fs/fs_bind/cloneNS/test01
ltp/testcases/kernel/fs/fs_bind/cloneNS/test02
ltp/testcases/kernel/fs/fs_bind/cloneNS/test03
ltp/testcases/kernel/fs/fs_bind/cloneNS/test04
ltp/testcases/kernel/fs/fs_bind/cloneNS/test05
ltp/testcases/kernel/fs/fs_bind/cloneNS/test06
ltp/testcases/kernel/fs/fs_bind/cloneNS/test07
ltp/testcases/kernel/fs/fs_bind/move/OO_descriptions.txt
ltp/testcases/kernel/fs/fs_bind/move/test01
ltp/testcases/kernel/fs/fs_bind/move/test02
ltp/testcases/kernel/fs/fs_bind/move/test03
ltp/testcases/kernel/fs/fs_bind/move/test04
ltp/testcases/kernel/fs/fs_bind/move/test05
ltp/testcases/kernel/fs/fs_bind/move/test06
ltp/testcases/kernel/fs/fs_bind/move/test07
ltp/testcases/kernel/fs/fs_bind/move/test08
ltp/testcases/kernel/fs/fs_bind/move/test09
ltp/testcases/kernel/fs/fs_bind/move/test10
ltp/testcases/kernel/fs/fs_bind/move/test11
ltp/testcases/kernel/fs/fs_bind/move/test12
ltp/testcases/kernel/fs/fs_bind/move/test13
ltp/testcases/kernel/fs/fs_bind/move/test14
ltp/testcases/kernel/fs/fs_bind/move/test15
ltp/testcases/kernel/fs/fs_bind/move/test16
ltp/testcases/kernel/fs/fs_bind/move/test17
ltp/testcases/kernel/fs/fs_bind/move/test18
ltp/testcases/kernel/fs/fs_bind/move/test19
ltp/testcases/kernel/fs/fs_bind/move/test20
ltp/testcases/kernel/fs/fs_bind/move/test21
ltp/testcases/kernel/fs/fs_bind/move/test22
ltp/testcases/kernel/fs/fs_bind/rbind/OO_descriptions.txt
ltp/testcases/kernel/fs/fs_bind/rbind/test01
ltp/testcases/kernel/fs/fs_bind/rbind/test02
ltp/testcases/kernel/fs/fs_bind/rbind/test03
ltp/testcases/kernel/fs/fs_bind/rbind/test04
ltp/testcases/kernel/fs/fs_bind/rbind/test05
ltp/testcases/kernel/fs/fs_bind/rbind/test06
ltp/testcases/kernel/fs/fs_bind/rbind/test07
ltp/testcases/kernel/fs/fs_bind/rbind/test07-2
ltp/testcases/kernel/fs/fs_bind/rbind/test08
ltp/testcases/kernel/fs/fs_bind/rbind/test09
ltp/testcases/kernel/fs/fs_bind/rbind/test10
ltp/testcases/kernel/fs/fs_bind/rbind/test11
ltp/testcases/kernel/fs/fs_bind/rbind/test12
ltp/testcases/kernel/fs/fs_bind/rbind/test13
ltp/testcases/kernel/fs/fs_bind/rbind/test14
ltp/testcases/kernel/fs/fs_bind/rbind/test15
ltp/testcases/kernel/fs/fs_bind/rbind/test16
ltp/testcases/kernel/fs/fs_bind/rbind/test17
ltp/testcases/kernel/fs/fs_bind/rbind/test18
ltp/testcases/kernel/fs/fs_bind/rbind/test19
ltp/testcases/kernel/fs/fs_bind/rbind/test20
ltp/testcases/kernel/fs/fs_bind/rbind/test21
ltp/testcases/kernel/fs/fs_bind/rbind/test22
ltp/testcases/kernel/fs/fs_bind/rbind/test23
ltp/testcases/kernel/fs/fs_bind/rbind/test24
ltp/testcases/kernel/fs/fs_bind/rbind/test25
ltp/testcases/kernel/fs/fs_bind/rbind/test26
ltp/testcases/kernel/fs/fs_bind/rbind/test27
ltp/testcases/kernel/fs/fs_bind/rbind/test28
ltp/testcases/kernel/fs/fs_bind/rbind/test29
ltp/testcases/kernel/fs/fs_bind/rbind/test30
ltp/testcases/kernel/fs/fs_bind/rbind/test31
ltp/testcases/kernel/fs/fs_bind/rbind/test32
ltp/testcases/kernel/fs/fs_bind/rbind/test33
ltp/testcases/kernel/fs/fs_bind/rbind/test34
ltp/testcases/kernel/fs/fs_bind/rbind/test35
ltp/testcases/kernel/fs/fs_bind/rbind/test36
ltp/testcases/kernel/fs/fs_bind/rbind/test37
ltp/testcases/kernel/fs/fs_bind/rbind/test38
ltp/testcases/kernel/fs/fs_bind/rbind/test39
ltp/testcases/kernel/fs/fs_bind/regression/OO_descriptions.txt
ltp/testcases/kernel/fs/fs_bind/regression/test01
ltp/testcases/kernel/fs/fs_bind/regression/test02
ltp/testcases/kernel/fs/fs_bind/regression/test03
ltp/testscripts/test_fs_bind.sh

30) Log Message:
The fixed address passed to mmap() should be aligned to the value of SHMLBA=
 as defined in sys/shm.h (The same fix can be found in the mmap01 case earl=
ier sent from Martin Habets ). By, Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/io/direct_io/diotest4.c

31) Log Message:
This patch modifies testcases to attach their shm segment to addresses chos=
en by ststem instead of arch-dependent ones. I looked into the history of t=
hese testcases, but couldn't find the reason why they specified arch-depend=
ent addresses in the first place. If it has something to do with the page c=
oloring issue, SHMLBA should be in some manners instead of defining arch-de=
pendent addresses. Tested successfully on ia64, ppc64, x86_64, s390x & i386=
 by Subrata Modak <subrata@linux.vnet.ibm.com>, and by Martin Habets <erran=
dir_news@mph.eclipse.co.uk> on sparc32. Signed-off-by: Roy Lee <roylee17@gm=
ail.com>.

Modified File(s):
ltp/testcases/kernel/mem/shmt/shmt02.c
ltp/testcases/kernel/mem/shmt/shmt04.c
ltp/testcases/kernel/mem/shmt/shmt05.c
ltp/testcases/kernel/mem/shmt/shmt06.c
ltp/testcases/kernel/mem/shmt/shmt07.c
ltp/testcases/kernel/mem/shmt/shmt09.c

32) Log Message:
These patches will allow for the plotting of the max over time in discrete =
segments, rather than as a monotonically increasing value, while maintainin=
g the original behavior by default. Cleanup some whitespace issues here. Si=
gned-off-by: Darren Hart <dvhltc@us.ibm.com>. Acked-by: John Stultz <johnst=
ul@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/func/gtod_latency/gtod_infinite.c

33) Log Message:
These patches will allow for the plotting of the max over time in discrete =
segments, rather than as a monotonically increasing value, while maintainin=
g the original behavior by default. The existing test has an infinite windo=
w and report the new max each time it is increased.  The patch maintains th=
e default behavior and adds a -w option, allowing the user to specify a win=
dow (iteration count) for which the max of that window is reported ever w i=
terations. Signed-off-by: Darren Hart <dvhltc@us.ibm.com>. Acked-by: John S=
tultz <johnstul@us.ibm.com>.

Modified File(s):
ltp/testcases/realtime/func/gtod_latency/gtod_infinite.c

34) Log Message:
I see Roy's patch was already checked in. In principle I agree with the pat=
ch, but a few things are wrong now and IMHO does not fulfill what it should=
 test any longer. shm05.c -> see my (untested!!!) patch below. Some archite=
ctures can only map at specific offsets. Current version "sucessfully" fail=
s, because e.g. hppa can't map at cp+4096. So, it's not failing because the=
 memory regions overlap, although that was intended to be tested...shm06.c =
now does basically the same test as shm04.c ?!? Doesn't make sense... I wou=
ld revert the patch for shm06, but maybe others think different???? Other p=
atches seem ok, although I haven't looked too deep into them yet... Helge D=
eller <deller@gmx.de>.

Modified File(s):
ltp/testcases/kernel/mem/shmt/shmt05.c

35) Log Message:
Roy Lee <roylee17@gmail.com> wrote:
Your patch looks good to me. It does what I'm intended but failed to do; el=
iminating explicit arch-dependent code without breaking logics. How about m=
erge the scenario of shm06 into shm04, and then eliminate shm06? Modify shm=
04 to attach the same segment _twice_ to the child's address space. In this=
 case, the first returned address should be the same as where the parent at=
taches its segment to while the second returned address should be different=
.
Helge Deller <deller@gmx.de> wrote:
Yes, this is probably the best idea. Alternatively, just leave shm04 as-is,=
 and do the twice-mapping you mentioned above in shm06. This way we'd keep =
two simple tests.
Roy Lee <roylee17@gmail.com> wrote back:
Here's the patch for the shmt06 according to Helge's recommandation, please=
 help review it.

Modified File(s):
ltp/testcases/kernel/mem/shmt/shmt06.c

36) Log Message:
Adding default Log File generation support for LTP. By, Subrata Modak<subra=
ta@linux.vnet.ibm.com>

Modified File(s):
ltp/runltp

37) Log Message:
Both of the above test cases has similar issue to shmt/mmap series. This pa=
tch removes the non-aligned addresses explicitly coded for different archit=
ectures by:=20
1) probing an available address by a pair of shmat/shmdt calls, and,=20
2) replaceing the addr with offset in the struct test_case_t.
By, Roy Lee <roylee17@gmail.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/shmat/shmat01.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat02.c

38) Log Message:
The "pan/pan" would failed in segmentation fault with a wrong option "-f co=
mmand-file". Among the options, the "/tmp/test" does not exist. The solutio=
n is to add condition judgements before use the pointer. To execute pan/pan=
 with option "-p" will occurs Segmentation fault. The reason is that it not=
 appends the "-l" option to pan to open the "logfile" for writing log. Just=
 add a condition judgement to fix it. Signed-off-by: Jin Bing Guo <guojb@cn=
.ibm.com>.

Modified File(s):
ltp/pan/pan.c

39) Log Message:
Make-sync_pipe-API-more-generic-and-update-related.patch.
Roy Lee <roylee17@gmail.com> noted:
Referring to the sync_pipes API, create_sync_pipes(), wait_son_startup(), n=
otify_startup(), which is defined in the: testcases/kernel/syscalls/lib/lib=
testsuite.[ch], I found the new sync_pipes API very convenient to synchroni=
ze processes. However the naming might pose some semantic restrictions on t=
heir usages. Since it can be used for makingparent to wait child, and vice =
versa, perhaps a better naming should be used. For example: sync_pipes_crea=
te (), sync_pipes_wait (), sync_pipes_notify(), other names will be good as=
 long as they don't assume the caller is child or parent. Furthermore, sinc=
e it is also suitable for being used in common test cases, moving  it outsi=
de the syscalls's directory to a more common place might be a good idea.
Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com> noted:
I fully agree with your remarks. But if you want to make these functions mo=
re generic, it should be possible to call sync_pipe_wait / notify several t=
imes, which is not possible in the current code since I close file descript=
ors in these functions. A quite simple solution is to keep these file descr=
iptors opened, and to add a function to close them or simply let these file=
 descriptors being closed by libC or kernel at process end. Signed-off-by: =
Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/execve/execve05.c
ltp/testcases/kernel/syscalls/ftruncate/ftruncate04.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv05.c
ltp/testcases/kernel/syscalls/ipc/msgrcv/msgrcv06.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd05.c
ltp/testcases/kernel/syscalls/ipc/msgsnd/msgsnd06.c
ltp/testcases/kernel/syscalls/ipc/semctl/semctl01.c
ltp/testcases/kernel/syscalls/ipc/semop/semop05.c
ltp/testcases/kernel/syscalls/ipc/shmctl/shmctl01.c
ltp/testcases/kernel/syscalls/lib/libtestsuite.c
ltp/testcases/kernel/syscalls/lib/libtestsuite.h

40) Log Message:
Put-libtestsuite-to-a-more-common-place.patch
Roy Lee <roylee17@gmail.com> noted:
Referring to the sync_pipes API, create_sync_pipes(), wait_son_startup(), n=
otify_startup(), which is defined in the: testcases/kernel/syscalls/lib/lib=
testsuite.[ch], I found the new sync_pipes API very convenient to synchroni=
ze processes. However the naming might pose some semantic restrictions on t=
heir usages. Since it can be used for makingparent to wait child, and vice =
versa, perhaps a better naming should be used. For example: sync_pipes_crea=
te (), sync_pipes_wait (), sync_pipes_notify(), other names will be good as=
 long as they don't assume the caller is child or parent. Furthermore, sinc=
e it is also suitable for being used in common test cases, moving  it outsi=
de the syscalls's directory to a more common place might be a good idea.
Renaud Lottiaux <Renaud.Lottiaux@kerlabs.com> noted:
I fully agree with your remarks. But if you want to make these functions mo=
re generic, it should be possible to call sync_pipe_wait / notify several t=
imes, which is not possible in the current code since I close file descript=
ors in these functions. A quite simple solution is to keep these file descr=
iptors opened, and to add a function to close them or simply let these file=
 descriptors being closed by libC or kernel at process end. Signed-off-by: =
Roy Lee <roylee17@gmail.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/Makefile
ltp/testcases/kernel/syscalls/chdir/Makefile
ltp/testcases/kernel/syscalls/creat/Makefile
ltp/testcases/kernel/syscalls/execve/Makefile
ltp/testcases/kernel/syscalls/fchdir/Makefile
ltp/testcases/kernel/syscalls/ftruncate/Makefile
ltp/testcases/kernel/syscalls/ipc/msgrcv/Makefile
ltp/testcases/kernel/syscalls/ipc/msgsnd/Makefile
ltp/testcases/kernel/syscalls/ipc/semctl/Makefile
ltp/testcases/kernel/syscalls/ipc/semop/Makefile
ltp/testcases/kernel/syscalls/ipc/shmctl/Makefile
ltp/testcases/kernel/syscalls/kill/Makefile
ltp/testcases/kernel/syscalls/mkdir/Makefile
ltp/testcases/kernel/syscalls/mremap/Makefile
ltp/testcases/kernel/syscalls/open/Makefile
ltp/testcases/kernel/syscalls/rename/Makefile
ltp/testcases/kernel/syscalls/rmdir/Makefile
ltp/testcases/kernel/syscalls/sched_setscheduler/Makefile
ltp/testcases/kernel/syscalls/vhangup/Makefile

Added File(s):
ltp/include/libtestsuite.h
ltp/lib/libtestsuite.c

41) Log Message:
The earlier patch broke parisc (which has really some strange requirements)=
. Attached patch fixes it. If it's OK for you, please apply. By, Helge Dell=
er <deller@gmx.de>.

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/shmat/shmat01.c
ltp/testcases/kernel/syscalls/ipc/shmat/shmat02.c

42) Log Message:
Currently ltp-devel install man pages in /opt/ltp/share/man/; however, they=
 should be installed in /usr/share/man/. By, George Kraft <gk4@us.ibm.com>.

Modified File(s):
ltp/ltp-devel.spec
ltp/doc/man1/Makefile
ltp/doc/man3/Makefile

43) Log Message:
Included all of /include and /lib and /doc in the ltp-devel RPMs. By George=
 Kraft <gk4@us.ibm.com>.

Modified File(s):
ltp/README.ltp-devel
ltp/ltp-devel.spec
ltp/include/Makefile

44) Log Message:
Preparing for the next Stable release of ltp-devel Packages, which will hav=
e:
1) All files under ltp/include in the package,
2) Install ltp man pages in system man directory.

Modified File(s):
ltp/ltp-devel.spec

45) Log Message:
Profiled Tests:
Basically this was done to enhance the pass/fail criteria usage and allow t=
he user to setup tests configurations according to specific needs. Imagine =
a test series that may validate a hardware for some latencies (case #1) whi=
le another series would validate other criteria (case #2). The same test us=
ed in situation #1 will not have the same configuration (arguments) in situ=
ation #2. Scripting has to be done for this to achieve. The profile system =
does this for you. You just have to configure. Not only pass/fail criteria =
can be set since the profile system simply runs command lines defined in pr=
ofiles. So any argument can be choosen. ie: a profile can define criteria f=
or tests with or without saving statistics (-s) or simulate jvm (-j). A pro=
file comes as a single file so it is easy to copy from a test machine to an=
other. With this patch, profiles can be used either for test global run (./=
run.sh) or for an individual directory (./run_auto.sh). For more informatio=
n, read doc/AUTOMATED_RUN.
This patch is intentionnally global as splitting changes would not make sen=
se.
This includes:
- changes of scripts for automated tests to feature profiles
- individual changes for tests using automation
- a default profile (to be used as an example)
- documentation writing/modifying.
Signed-off-by: Gilles Carry <gilles.carry@bull.net>,
Reviewed-by: Ankita Garg <ankita@in.ibm.com>.

Modified Files:
ltp/testcases/realtime/run.sh
ltp/testcases/realtime/doc/HOWTO_ADD_TESTS
ltp/testcases/realtime/func/gtod_latency/run_auto.sh
ltp/testcases/realtime/func/matrix_mult/run_auto.sh
ltp/testcases/realtime/func/periodic_cpu_load/run_auto.sh
ltp/testcases/realtime/func/pi-tests/run_auto.sh
ltp/testcases/realtime/func/pi_perf/run_auto.sh
ltp/testcases/realtime/func/prio-preempt/run_auto.sh
ltp/testcases/realtime/func/prio-wake/run_auto.sh
ltp/testcases/realtime/func/pthread_kill_latency/run_auto.sh
ltp/testcases/realtime/func/sched_football/run_auto.sh
ltp/testcases/realtime/func/sched_jitter/run_auto.sh
ltp/testcases/realtime/func/sched_latency/run_auto.sh
ltp/testcases/realtime/func/thread_clock/run_auto.sh
ltp/testcases/realtime/scripts/run_c_files.sh
ltp/testcases/realtime/scripts/setenv.sh
Added Files:
ltp/testcases/realtime/doc/AUTOMATED_RUN
ltp/testcases/realtime/doc/run_auto.sh.tpl
ltp/testcases/realtime/profiles/default
ltp/testcases/realtime/testcases/realtime/doc/AUTOMATED_RUN


46) Log Message:
This patch fix a concurrency issue in msgctl06. The tmp directory the IPC k=
ey was build with was destroyed before we destroy the IPC ressource attache=
d to the key. In case of concurency, the same inode id can be reused for an=
other process tmp dir, leading to the generation of the same key. Regards R=
enaud Lottiaux <Renaud.Lottiaux@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/ipc/msgctl/msgctl06.c

47) Log Message:
I got failures on ptrace03 because the latest kernel allows init process to=
 be traced. The commit is:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D00cd5c37afd5f431ac186dd131705048c0a11fdb,
See the discussion in LKML: http://marc.info/?t=3D120628018600001.
So we should not execute this test case if the kernel version is above 2.6.=
25.
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>.

Modified File(s):
ltp/testcases/kernel/syscalls/ptrace/ptrace03.c

48) Log Message:
execve02 checks that execve() fails if the caller does not have executable =
permission on the file. However, in case the test fails and execve() succee=
ds, the default binary (test3) has return code 0, which is interpreted as t=
est success. We get output like that:=20
<output>
Hello World
</output>
with return code 0 (success)

instead of:

<output>
execve02    1  FAIL  :  Failures reported above
</output>
with return code matching FAIL.

This patch simply changes the success return code from 0 to 3, so that exec=
ve() success, and thus test failure, can be properly reported. Signed-off-b=
y: Louis Rilling <Louis.Rilling@kerlabs.com>

Modified File(s):
ltp/testcases/kernel/syscalls/execve/execve02.c

49) Log Message:
Profiled tests - cleanup. I forgot some useless code in the scripts. These =
patches do the cleanup. Signed-off-by: Gilles Carry <gilles.carry@bull.net>=
.

Modified File(s):
ltp/testcases/realtime/scripts/run_c_files.sh
ltp/testcases/realtime/func/sched_latency/run_auto.sh

50) Log message:
I got the following failure:
adjtimex02    4  FAIL  :  Test Failed, adjtimex()returned 5, errno =3D 0 : =
Success
adjtimex02    5  FAIL  :  Test Failed, adjtimex()returned 5, errno =3D 0 : =
Success
This is because the latest kernel normalizes buf.offset value if it is outs=
ide the acceptable range. The commit is: http://git.kernel.org/?p=3Dlinux/k=
ernel/git/torvalds/linux-2.6.git;a=3Dcommitdiff;h=3Deea83d896e318bda54be2d2=
770d2c5d6668d11db. So we should not execute this test case if the kernel ve=
rsion is above 2.6.25. Here is the test result after patching (linux 2.6.26=
-rc2):
adjtimex02    4  CONF  :  this kernel normalizes buf.offset value if it is =
outside the acceptable range.
adjtimex02    5  CONF  :  this kernel normalizes buf.offset value if it is =
outside the acceptable range.
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Modified File(s):
ltp/testcases/kernel/syscalls/adjtimex/adjtimex02.c

51) Log Message:
Manas K Nayak <maknayak@in.ibm.com> updated the fnctl lock tests from http:=
//nfsv4.bullopensource.org/tools/tests/locktest.php. I have retained some i=
nfo like the deploy_info, etc from the older release as well. The old tests=
 were failing. After updates, the test passes.

Modified Files:
ltp/testcases/network/nfsv4/locks/Makefile
ltp/testcases/network/nfsv4/locks/locktests.c
Added Files:
ltp/testcases/network/nfsv4/locks/test
ltp/testcases/network/nfsv4/locks/deploy/locktests.tar.gz
Removed Files:
ltp/testcases/network/nfsv4/locks/locktests.h
ltp/testcases/network/nfsv4/locks/deploy/locktests-2.tar.gz

52) Log Message:
Restored back the Makefile content. Else, there will be build/clean/install=
 failures. Subrata Modak <subrata@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/network/nfsv4/locks/Makefile

53) Log Message:
Adding this part of default LTP run. Subrata Modak <subrata@linux.vnet.ibm.=
com>.

Modified Files:
ltp/runltp

Added Files:
ltp/runtest/fcntl-locktests

54) Log Message:
This patch adds a list for all known issues which are probably subtle to be=
 fixed in kernel to the test, so the test could continue. Also, it will pri=
nt out those expected failures as INFO or WARN to the test result. Signed-o=
ff-by: Cai Qian <qcai@redhat.com>.

Modified File(s):
ltp/testcases/kernel/fs/proc/proc01.c

55) Log Message:
This patch fixes the output of the test, so all fatal errors to cause the f=
inal failure of the test will be printed out as FAIL instead of INFO, and a=
ll verbose and debug output will be moved to STDERR instead of STDOUT for e=
asy output processing. Signed-off-by: Cai Qian <qcai@redhat.com>.

Modified File(s):
ltp/testcases/kernel/fs/proc/proc01.c

56) Log Message:
This patch adds the failcnt check test for memory controller. In this test =
a task runs in a group with some memory limit and does total memory allocat=
ion greater than the limit of the group. The script checks the failcnt from=
 memory.failcnt file under the controller. It reports pass if failcnt incre=
ases otherwise reports fail. Signed-off-by: Sudhir Kumar <skumar@linux.vnet=
.ibm.com>. Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/memctl/memctl_test01.c
ltp/testcases/kernel/controllers/memctl/run_memctl_test.sh

57) Log Message:
This patch adds the stat check test case for memory controller. In this tes=
t a task runs in a group with some memory limit and does some memory alloca=
tion. The script checks the memory usage field from two files under the con=
troller, the memory.usage_in_bytes and memory.stat. It reports pass if the =
two values are same and fail if the two values differ. Signed-off-by: Sudhi=
r Kumar <skumar@linux.vnet.ibm.com>. Acked-by: Dhaval Giani <dhaval@linux.v=
net.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/test_controllers.sh
ltp/testcases/kernel/controllers/memctl/memctl_test01.c
ltp/testcases/kernel/controllers/memctl/run_memctl_test.sh

58) Log Message:
This patch adds the documentation for memory controller. Signed-off-by: Sud=
hir Kumar <skumar@linux.vnet.ibm.com>.

Modified Files:
ltp/testcases/kernel/controllers/README
ltp/testcases/kernel/controllers/testplan.txt
Added Files:
ltp/testcases/kernel/controllers/memctl/README
ltp/testcases/kernel/controllers/memctl/memctl_testplan.txt

59) Log Message:
According to man sigpause :
 int sigpause(int sigmask);  /* BSD */
 int sigpause(int sig);      /* System V / Unix95 */
[...]
Linux Notes
       On Linux, this routine is a system call only on the Sparc (sparc64) =
architecture. Libc4 and libc5 only know about the BSD version. Glibc uses t=
he BSD version if the _BSD_SOURCE feature test macro is defined and none of=
 _POSIX_SOURCE, _POSIX_C_SOURCE, _XOPEN_SOURCE, _GNU_SOURCE,  or _SVID_SOUR=
CE is defined.  The System V version is used if _XOPEN_SOURCE is defined. S=
ince the _BSD_SOURCE_ is not defined for LTP testcases, rather they define =
_XOPEN_SOURCE_, the behaviour is System V, where they expect a signal numbe=
r instead of signal mask. Signed-off-by: Suzuki KP <suzuki@in.ibm.com>.

Modified File(s):
ltp/testcases/kernel/ipc/ipc_stress/signal_test_01.c

60) Log Message:
Ankita Proposed that:
We have been seeing failures in the prio-wake testcase for a while now. Dig=
ged closer into the testcase to find if there was an error lurking in the t=
estcase itself. Did hit a few, which this patch aims to fix. But the failur=
es persist, indicating that something is amiss in the kernel. This patch do=
es the following:
o Make the output of the test more readable. It is now time ordered.
o Bases the pass/fail not only on the order in which the waking up threads =
update the 'wakeup.arr' but also on the time they woke up. This reduced cha=
nces of error.
o Remove an extra lock and unlock on mutex when updating wakeup.arr.

Chirag Jog <chirag@linux.vnet.ibm.com> commented:
I am not convinced that adding a check for wake up time is going to reduce =
the chances for error. Whichever thread wakes up first, takes the lock,upda=
tes priority and time fields. Hence the time field will always be updated i=
n wakeup order. So this is not really adding another useful check. I am rea=
dy to be conviced otherwise :)

Ankita Replied:
Yep I agree that now it would not make any difference. But before this patc=
h, we were unlocking the mutex after only updating the running_threads and =
noting down the wakeup time and try and acquire the lock again to update th=
e wakeup order in wakeup.arr So, there were chances the wakeup time did not=
 match the order in which the wakeup.arr was updated. But yes, with the loc=
k changes, this change would not be required. Shall send the patch again. T=
hanks for the review :-). So here is the updated patch which takes Chirag's=
 comments into account.
Signed-off-by: Ankita Garg <ankita@in.ibm.com>
Signed-off-by: Chandan Kumar B V <cbhuvana@in.ibm.com>

Modified File(s):
ltp/testcases/realtime/func/prio-wake/prio-wake.c

61) Log Message:
This patch addresses the review comments for recently accepted memory contr=
oller testcases (failcnt test and stat_check test). Signed-off-by: Sudhir K=
umar <skumar@linux.vnet.ibm.com>.

Modified File(s):
ltp/testcases/kernel/controllers/memctl/README

--=-pUv9mS0iECL1n2SLdqSE--

