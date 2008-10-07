Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYJGP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYJGP6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYJGP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:58:32 -0400
Received: from xenotime.net ([66.160.160.81]:42026 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751235AbYJGP6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:58:32 -0400
Date: Tue, 7 Oct 2008 08:58:29 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Andi Kleen <andi@firstfloor.org>
cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Add kerneldoc documentation for new printk format
 extensions
In-Reply-To: <20081007111410.GF20740@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0810070857070.8747@shark.he.net>
References: <20081007101532.GA25565@basil.nowhere.org> <20081007103305.GH2886@hack.voiplan.pt>
 <20081007111410.GF20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-775977357-1223395109=:8747"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-775977357-1223395109=:8747
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 7 Oct 2008, Andi Kleen wrote:

> On Tue, Oct 07, 2008 at 11:33:05AM +0100, Am=E9rico Wang wrote:
> > On Tue, Oct 07, 2008 at 12:15:32PM +0200, Andi Kleen wrote:
> > >Add documentation in kerneldoc for new printk format extensions
> > >
> > >This patch documents the new %pS/%pF options in printk in kernel doc.
> > >
> > >Hope I didn't miss any other extension.
> > >
> > >Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > >
> > >Index: linux-2.6.27-rc6-misc/kernel/printk.c
> > >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >--- linux-2.6.27-rc6-misc.orig/kernel/printk.c
> > >+++ linux-2.6.27-rc6-misc/kernel/printk.c
> > >@@ -593,6 +593,8 @@ static int have_callable_console(void)
> > >  *
> > >  * See also:
> > >  * printf(3)
> > >+ *
> > >+ * See the vsnprintf() documentation for format string extensions ove=
r C99.
> > >  */
> > >=20
> > > asmlinkage int printk(const char *fmt, ...)
> > >Index: linux-2.6.27-rc6-misc/lib/vsprintf.c
> > >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >--- linux-2.6.27-rc6-misc.orig/lib/vsprintf.c
> > >+++ linux-2.6.27-rc6-misc/lib/vsprintf.c
> > >@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
> > >  * @fmt: The format string to use
> > >  * @args: Arguments for the format string
> > >  *
> > >+ * This function follows C99 vsnprintf, but has some extensions:
> > >+ * %pS output the name of a text symbol
> > >+ * %pF output the name of a function pointer
> >=20
> > s/output/outputs/ ? :)
>=20
> It's not complete sentences but a list of options, so no.
>=20
> bla do this
> blub do that

I would use "outputs" _or_ separate the format string extension from the
description, like:

 * %pS: output the name of a text symbol

Anyway, thanks for adding them.
--=20
~Randy
---1606286688-775977357-1223395109=:8747--
