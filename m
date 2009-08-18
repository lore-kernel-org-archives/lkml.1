Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbZHRT51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbZHRT51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZHRT51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZHRT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:57:26 -0400
Date: Tue, 18 Aug 2009 15:57:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Justin Mattock <justinmattock@gmail.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
In-Reply-To: <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0908181544320.20691@gandalf.stny.rr.com>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-678505499-1250625446=:20691"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-678505499-1250625446=:20691
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 18 Aug 2009, Justin Mattock wrote:

> On Tue, Aug 18, 2009 at 9:09 AM, Steven Rostedt<rostedt@goodmis.org> wrot=
e:
> > On Tue, Aug 18, 2009 at 12:49:06PM +0200, Frederic Weisbecker wrote:
> >> On Thu, Aug 13, 2009 at 08:42:21AM -0700, Justin P. Mattock wrote:
> >> > I posted already and had no reply,
> >> > I cannot boot my system with the latest git
> >> >
> >> > seems to be stuck in some lock:
> >> >
> >> > [ =A0 0.655640] [<ffffffff81440c33>] panic+0x84/0x129
> >> > [ =A0 0.655883] [<ffffffff81063f96>] =A0do_exit+0x84/0x67e
> >> > [ =A0 0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
> >> > [ =A0 0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
> >> > [ =A0 0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0=
x249
> >> > [ =A0 0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x=
1e1
> >> > [ =A0 0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
> >> > [ =A0 0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x53=
3/0x5be
> >> > [ =A0 0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
> >> > [ =A0 0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
> >> > [ =A0 0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x=
40
> >> > [ =A0 0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
> >> > [ =A0 0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
> >> > [ =A0 0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
> >> > [ =A0 0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b
> >>
> >>
> >>
> >> Ouch...
> >>
> >> I've never seen such panic. Could you send me your config, hopefully
> >> I could reproduce it?
> >
> > Send me the config too please.
> >
> > -- Steve
> >
> >
>=20
> yeah this happens with rc6 but not with rc5.
>=20
> The system is a linux from scratch build
> x86_64 I used these flags for building everything:
>=20
>  CFLAGS=3D" -m64 -mtune=3Dcore2 -march=3Dcore2 -mfpmath=3Dboth  -O2 -pipe
>  -fomit-frame-pointer -fstack-protector" CXXFLAGS=3D"${CFLAGS}" MAKEOPTS=
=3D"{-j3}"
>=20
> also:  I have a macbook(not x86_64) that is running rc6 that seems
> to be fine.(I can double check).
>=20
> attached is .config, dmesg as well.

I used your config and I can not reproduce the bug you have. Was this a=20
constant issue? That is, was it reproducible at every boot?

-- Steve
--8323328-678505499-1250625446=:20691--
