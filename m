Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZENOCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZENOCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZENOB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:01:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZENOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:01:56 -0400
Date: Thu, 14 May 2009 10:01:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Minchan Kim <minchan.kim@gmail.com>, leemgs1@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>, tglx <tglx@linutronix.de>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH]append prompt in /debug/tracing/README file.
In-Reply-To: <alpine.LNX.2.00.0905141540470.22712@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0905141001120.30591@gandalf.stny.rr.com>
References: <1242289418.31161.45.camel@centos51> <28c262360905140128q3458e39fu62def873f2d95ae0@mail.gmail.com> <alpine.LNX.2.00.0905141540470.22712@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-846517749-1242309716=:30591"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-846517749-1242309716=:30591
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Thu, 14 May 2009, Jiri Kosina wrote:

> On Thu, 14 May 2009, Minchan Kim wrote:
>=20
> > > =C2=A0 =C2=A0Please, Append prompt in /debug/tracing/README file.
> > >
> > > =C2=A0 =C2=A0This is trivial issue. Fix typo Mini Howto file(README) =
for ftrace.
> > >
> > > =C2=A0 =C2=A0Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> > >
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 1ce5dc6..a4726f5 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -2380,7 +2380,7 @@ static const char readme_msg[] =3D
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0"# echo print-parent > /debug/tracing/trac=
e_options\n"
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0"# echo 1 > /debug/tracing/tracing_enabled=
\n"
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0"# cat /debug/tracing/trace > /tmp/trace.t=
xt\n"
> > > - =C2=A0 =C2=A0 =C2=A0 "echo 0 > /debug/tracing/tracing_enabled\n"
> > > + =C2=A0 =C2=A0 =C2=A0 "# echo 0 > /debug/tracing/tracing_enabled\n"
> > > =C2=A0;
> > >
> > > =C2=A0static ssize_t
>=20
> I have applied this to trivial tree. If anyone else has already applied i=
t=20
> to his tree, please let me know so that I can drop it.

It's fine with me that this goes via the trivial tree.

If you want, you can also add:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

-- Steve

--8323328-846517749-1242309716=:30591--
