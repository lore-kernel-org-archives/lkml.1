Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYKNBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYKNBda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNBdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:33:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYKNBdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:33:19 -0500
Date: Thu, 13 Nov 2008 20:33:16 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sources.redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: systemtap 0.8 release
Message-ID: <20081114013315.GA14745@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi -


The systemtap team announces release 0.8.



 =3D Where to get it

   http://sourceware.org/systemtap/ - our project page  =20
   http://sourceware.org/systemtap/ftp/releases/systemtap-0.8.tar.gz
   git commit 5879aaccc
   http://koji.fedoraproject.org/koji/packageinfo?packageID=3D615


 =3D How to build it

   See the README and NEWS files at=20
   http://sourceware.org/git/?p=3Dsystemtap.git;a=3Dtree;hb=3D5879aaccc
   Further information at http://sourceware.org/systemtap/wiki/


 =3D Systemtap frontend (stap) changes

 - Error and warning messages are now followed by source context.

 - A new stap "-F" flag is available that activates "flight recorder" mode
   to load module and start probes, then detach from the module leaving the
   probes running.

 - A listing mode improvement "-L" is now available. It's similar
   to "-l", but lists probe points and available script-level variables.

 - Written but unread globals in user's script are automatically displayed.


 =3D Systemtap script language changes

 - %c printf conversion specifier is now supported.

 - Members of anonymous structs/unions are now identified.

 - Additional context variables: $argN, $syscall, $return are
   available on utrace-based process.syscall probes.

 - $$vars, $$parms, $$locals, $$return pseudo-variables=20
   have been added for simplified tracing.


 =3D Systemtap probe points changes

 - User space probing is supported at a prototype level, for kernels
   built with the utrace patches.  With debugging data for /bin/ls
   available, try this script:

      probe process("ls").function("*").call { log($$parms) }

 - Target process mode (stap -c CMD or -x PID) now implicitly restricts
   all "process.*" probes to the given child process and old-style =20
   stap -c "FOO > BAR" type usage is now supported.

 - All user-space-related probes support $PATH-resolved executable
   names.


 =3D Miscellaneous changes

 - Drafts of a new Beginner's Guide and Tapset Reference manual are now
   available within the sources.  They can be rendered to PDF or HTML.

 - Automatic limiting of the compiled module cache ($HOME/.systemtap/cache)=
 size.

 - A system information gathering tool "stap-report" is included.

 - Prototype systemtap network client and compile server are now available.


 =3D The following people helped with code contributions for this release:

   anithra, Dave Brolley, David Smith, Dave Nomura, Don Domingo,
   Elliott Baron, Eugeniy Meshcheryakov, Frank Ch. Eigler, James
   Bottomley, Jim Keniston, Josh Stone, Kent Sebastian, Mark Wielaard,
   Masami Hiramatsu, Michael Meeks, Nobuhiro Tachino, Phil Muldoon,
   Prerna Saxena, Rajan Arora, Srikar Dronamraju, Stan Cox, Tim Moore,
   Wenji Huang, William Cohen, Zhaolei

   Special thanks to Rajan Arora for drafting these release notes.


 =3D Known issues with this release:

   Generally, see our bug tracker at http://sourceware.org/bugzilla/


 =3D Bugs closed for this release:

 #3016 error accessing anonymous struct/union memeber
 #4211 bug reporting data gathering tool
 #4446 port marker code to support 2.6.25 static markers
 #4886 stap should validate debuginfo files with build-id
 #4961 buildreq: libcap-devel not enough
 #5049 Support relative and absolute pathnames in probe PATTERNs
 #5073 examples should be run by installcheck test suite
 #5075 automatic creation of "argstr"
 #5686 automagic printing of global arrays
 #6028 ia64_fetch_register is very slow
 #6030 stap, staprun, stapio interaction quirks: stale module left unloaded
 #6445 extend utrace probes with "system-wide" and target-process syntax
 #6487 kernel.function("internal_add_timer") freezes system
 #6504 change _stp_print_flush to avoid calling into kernel/relay.c
 #6565 network compile server, stage 1
 #6611 read-only variable typo warnings should list alternatives
 #6694 auto_free seems to trigger *** glibc detected *** stap: double free =
or
       corruption (fasttop)
 #6701 improve error/warning messages with source context
 #6737 pass unwind data to compiled module
 #6738 rhel4 (2.6.9) backward compatibility for STP_RELOCATE code
 #6749 tolerate failed kprobe_register calls
 #6752 Retrieval of task argument in probe signal.send on x8664 fails
 #6755 utrace probes under system pressure cause oops
 #6818 systemtap.examples index file generator
 #6820 minor problems in staprun(8)
 #6821 incorrect or missing interpreter command in some of the examples
 #6823 sample script index generator nits
 #6828 uprobe presence interferes with dd signal handling
 #6834 stap-client should not use bash network redirections
 #6835 io_submit.stp is in DOS format
 #6836 $$vars extensions
 #6841 system-wide utrace syscall tracing script don't respond signal
 #6842 system-wide utrace syscall tracing will cause kernel panic by hackbe=
nch
 #6849 $$vars fails to display local variables on ppc64 system
 #6870 task_finder should quiesce threads during initial iteration
 #6871 uprobes $context values often wrong
 #6872 module cache cleaner
 #6876 speed up translator with many $context vars
 #6879 does not currently support probing instruction first byte 0x65
 #6892 user-probe wildcard yields too many probes
 #6903 scripts can be run by non-sudo and non-stapdev users
 #6904 buildok/syscall.stp and buildok/aux_syscalls.stp started failing on =
ia64=20
       and s390x
 #6916 systemtap.base/alternatives.exp started failing in STRUCT1 testcase
 #6923 STAPCONF_ONEACHCPU_RETRY test broken?
 #6928 buildok/seventeen.stp crashes with elfutils 0.137
 #6946 stap unable to resolve probe points for 32 bit user space apps on PP=
C64 arch
 #6967 systemtap broken on s390x, compilation error
 #6969 syscall tapset broken on s390x
 #6970 SystemtapOnFedora yum commands don't work
 #6972 vfs tapset broken on older kernels
 #6964 process probes cause kernel crash on f9

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFJHNVbVZbdDOm/ZT0RAgvbAJ4tUdMMdAlVs6Z0Y64+e33QEcJ4uQCgheTh
0Ex+vP2zsaTsY5Zjtf7Y4Lw=
=ZVZd
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
