Return-Path: <linux-kernel-owner+w=401wt.eu-S1764384AbZAUMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764384AbZAUMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbZAUMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:43:32 -0500
Received: from mx02.jhcn.net ([194.25.102.130]:4100 "EHLO mx02.jhcn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbZAUMnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:43:31 -0500
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 07:43:30 EST
Content-Type: multipart/mixed; boundary="===============0477043978=="
From: Lampersperger Andreas <lampersperger.andreas@heidenhain.de>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Date: Wed, 21 Jan 2009 13:30:41 +0100
Thread-Topic: 2.6.24.7-rt26 and 2.6.26.8-rt13
Thread-Index: Acly0sZj2wJbnIhLR0m1axfS03dgYAI7Zt8A
Message-ID: <CEE27071B8F0914B91B3076CEB63C2B60725B58E@de01ex08.GLOBAL.JHCN.NET>
References: <1231557759.922.9.camel@localhost.localdomain>
In-Reply-To: <1231557759.922.9.camel@localhost.localdomain>
Accept-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
MIME-Version: 1.0
Subject: RE: 2.6.24.7-rt26 and 2.6.26.8-rt13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0477043978==
MIME-Version: 1.0
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm using kernel 2.6.26.8-rt13 with CONFIG_DYNAMIC_FTRACE=3Dy set.
When loading a kernel object the following message appear:

BUG: sleeping function called from invalid context insmod(1370) at include/=
asm/uaccess_32.h:560
in_atomic():0 [00000000], irqs_disabled():1
Pid: 1370, comm: insmod Not tainted 2.6.26.8-rt13-heros5 #8
 [<c011e13e>] __might_sleep+0xe5/0xea
 [<c011439a>] ftrace_modify_code+0x22/0xa6
 [<c0114364>] ? ftrace_test_p6nop+0x0/0xa
 [<c0162fb4>] __ftrace_update_code+0xed/0x2cf
 [<c0114364>] ? ftrace_test_p6nop+0x0/0xa
 [<c0163730>] ftrace_convert_nops+0x57/0x73
 [<c0163761>] ftrace_init_module+0x15/0x17
 [<c01491da>] sys_init_module+0x14c9/0x1a7d
 [<c016d89d>] ? generic_file_aio_read+0x49a/0x4d6
 [<c0311ef9>] ? sub_preempt_count+0xa2/0xb0
 [<c02180c4>] ? strpbrk+0x0/0x2b
 [<c019b7b9>] ? dput+0x34/0xe4
 [<c0104b31>] sysenter_past_esp+0x6a/0x99
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Is it not possible to use rt-patches and dynamic tracepoints?

-Andreas


--===============0477043978==
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


--===============0477043978==--
