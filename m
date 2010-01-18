Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0ARXQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0ARXQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391Ab0ARXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:16:11 -0500
Received: from cobra.newdream.net ([66.33.216.30]:46477 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0ARXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:16:09 -0500
Date: Mon, 18 Jan 2010 15:16:39 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: merge fixups relative to the vfs tree
In-Reply-To: <20100118182852.9820b770.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1001181512340.1759@cobra.newdream.net>
References: <20100118182852.9820b770.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-1581715584-1263856415=:1759"
Content-ID: <Pine.LNX.4.64.1001181513480.1873@cobra.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-1581715584-1263856415=:1759
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1001181513481.1873@cobra.newdream.net>

On Mon, 18 Jan 2010, Stephen Rothwell wrote:
> Hi J=F6rn, Sage,
>=20
> Al has now created a "write_inode" branch in the vfs tree that just
> contains the changes that your trees need to be fixed up for.  Al
> promises that this branch will never be rebased.  So the best solution is
> for you both to merge that branch into your respective trees ("git pull
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git
> write_inode") and then apply the patches I sent (assuming that they are
> correct).  If you rebase your trees, you will need to repull the above
> branch, of course.

That works, thanks.  I was planning on just making sure my tree got pulled=
=20
after the vfs tree, but this will work either way.

More generally, I'm not sure I understand how your fixups are supposed to=
=20
be used down the line.  Is whichever tree that caused the conflict to get=
=20
merged second supposed to pick it up in their branch to pull, or are those=
=20
patches being fed to Linus somehow, or does he usually fix up those=20
conflicts himself?

Thanks-
sage
--557981400-1581715584-1263856415=:1759--
