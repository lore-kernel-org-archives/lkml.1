Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZAWMGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZAWMGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZAWMFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:05:51 -0500
Received: from mx02.jhcn.net ([194.25.102.130]:58510 "EHLO mx02.jhcn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZAWMFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:05:50 -0500
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2009 07:05:50 EST
Content-Type: multipart/mixed; boundary="===============0216615111=="
From: Lampersperger Andreas <lampersperger.andreas@heidenhain.de>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Date: Fri, 23 Jan 2009 12:53:02 +0100
Thread-Topic: 2.6.26.8-rt13
Thread-Index: Acly0sZj2wJbnIhLR0m1axfS03dgYAKeLVKg
Message-ID: <CEE27071B8F0914B91B3076CEB63C2B6072DD8BF@de01ex08.GLOBAL.JHCN.NET>
References: <1231557759.922.9.camel@localhost.localdomain>
In-Reply-To: <1231557759.922.9.camel@localhost.localdomain>
Accept-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
MIME-Version: 1.0
Subject: RE: 2.6.26.8-rt13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0216615111==
MIME-Version: 1.0
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello Steve,

I found the define CONFIG_EVENT_TRACER inconsistent used in 2.6.26.8-rt31 p=
atch set:

It is declared in=20

tracer-event-trace.patch (line 47)=20

as EVENT_TRACER but it is used as CONFIG_EVENT_TRACE (without R at the end)=
 in

arm-compile-fix.patch (line 5 and 22)
event-tracer-syscall-i386.patch (lines 19,31 and 43)
preempt-realtime-i386.patch (line 258)

I think, it should be fixed to CONFIG_EVENT_TRACER.

Should I provide a patch for this?=20

--Andreas



> -----Original Message-----
> From: linux-rt-users-owner@vger.kernel.org [mailto:linux-rt-users-
> owner@vger.kernel.org] On Behalf Of Steven Rostedt
> Sent: Saturday, January 10, 2009 4:23 AM
> To: LKML; RT
> Cc: Ingo Molnar; Thomas Gleixner; Steven Rostedt
> Subject: 2.6.24.7-rt26 and 2.6.26.8-rt13
>=20
> We are pleased to announce the 2.6.24.7-rt26 and 2.6.26.8-rt13 trees,
> which can be downloaded from the location:
>=20
>   http://rt.et.redhat.com/download/
>=20
> Information on the RT patch can be found at:
>=20
>   http://rt.wiki.kernel.org/index.php/Main_Page
>=20
> Changes since 2.6.26.6-rt12
>=20
>   - Removed sched-prioritize-non-migrating-rt-tasks.patch that
>     caused a bug in the scheduler.
>    (Thanks to Arnaldo Carvalho de Melo for reporting the bug,
>     and Gregory Haskins for finding the patch that caused it
>     after I explained to him the problem)
>=20
> Changes in both 2.6.24.7-rt26 and 2.6.26.8-rt13  (all by Thomas
> Gleixner)
>=20
>   - trace-histogram: handle clock going backwards
>=20
>   - interrupt enabled in irq fix
>=20
> to build a 2.6.24.7-rt26 tree, the following patches should be applied:
>=20
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
>   http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
>   http://rt.et.redhat.com/download/patch-2.6.24.7-rt26.bz2
>=20
>=20
> to build a 2.6.26.8-rt13 tree, the following patches should be applied:
>=20
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>   http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.8.bz2
>   http://rt.et.redhat.com/download/patch-2.6.26.8-rt13.bz2
>=20
>=20
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
>=20
>   http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>=20
>=20
> The broken out patches are also available.
>=20
> The git tree can now be compiled, we are now working on getting it to
> boot ;-)  It is based off of the v2.6.28 tag.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-
> rt.git
>=20
> -- Steve
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-
> users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--===============0216615111==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------------=
----------------------------
Registergericht: Traunstein / Registry Court: HRB 275 =E2=80=93 Sitz / Head=
 Office: Traunreut
Aufsichtsratsvorsitzender / Chairman of Supervisory Board: Rainer Burkhard
Gesch=C3=A4ftsf=C3=BChrung / Management Board: Thomas Sesselmann (Vorsitzen=
der / Chairman),
Michael Grimm, Matthias Fauser

E-Mail Haftungsausschluss / E-Mail Disclaimer: http://www.heidenhain.de/dis=
claimer


--===============0216615111==--
