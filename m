Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218Ab0ASErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0ASErR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 23:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640Ab0ASErQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 23:47:16 -0500
Received: from cobra.newdream.net ([66.33.216.30]:42163 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0ASErK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 23:47:10 -0500
Date: Mon, 18 Jan 2010 20:47:35 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: merge fixups relative to the vfs tree
In-Reply-To: <20100119151955.1d07aa71.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1001182037400.17238@cobra.newdream.net>
References: <20100118182852.9820b770.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.1001181512340.1759@cobra.newdream.net>
 <20100119151955.1d07aa71.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-688986664-1263876139=:17238"
Content-ID: <Pine.LNX.4.64.1001182045420.17238@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-688986664-1263876139=:17238
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1001182045421.17238@cobra.newdream.net>

Hi Stephen,

On Tue, 19 Jan 2010, Stephen Rothwell wrote:
> It looks like you added my patch to your tree, but did not merge Al's
> write_inode branch.  So, I assume that your tree is currently broken if
> built on its own.

Not to worry, only the for-next branch.=20

> > More generally, I'm not sure I understand how your fixups are supposed =
to=20
> > be used down the line.  Is whichever tree that caused the conflict to g=
et=20
> > merged second supposed to pick it up in their branch to pull, or are th=
ose=20
> > patches being fed to Linus somehow, or does he usually fix up those=20
> > conflicts himself?
>=20
> Yeah, either the second tree's owner will do the fixup after the first is
> merged into Linus' tree or (more commonly for simple fixups), Linus will
> do the fix when he merges the second tree.  In this particular case, the
> conflicts are not noticed by git during the merge, so they need to be
> done manually by the second tree's owner, or by Linus (if we tell him).
>=20
> I will attempt to remember to warn Linus if these conflicts remain during
> the next merge window but if you and J=F6rn merge Al's branch and apply t=
he
> fix, then it will all be OK.

Okay, that makes sense.  I've merged Al's branch, so feel free to forget. :=
)

Also, I resolved the ioctl-number.txt fixup you're carrying in that merge,=
=20
so you should be able to drop that.  I'll make sure both conflicts are=20
dealt with in my tree one way or another before it gets pulled.

Thanks!
sage
--557981400-688986664-1263876139=:17238--
