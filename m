Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbYEIBQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbYEIBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYEIBQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:16:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbYEIBQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:16:18 -0400
Date: Fri, 9 May 2008 11:16:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-next@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-Id: <20080509111608.09574cf0.sfr@canb.auug.org.au>
In-Reply-To: <20080508220443.GE7705@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au>
	<20080508042753.GA6876@kroah.com>
	<20080508062715.GE14951@cs181133002.pp.htv.fi>
	<20080508220443.GE7705@kroah.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_May_2008_11_16_08_+1000_GR_ZjhE+UM+4HfHY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_May_2008_11_16_08_+1000_GR_ZjhE+UM+4HfHY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 8 May 2008 15:04:43 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, May 08, 2008 at 09:27:15AM +0300, Adrian Bunk wrote:
> > On Wed, May 07, 2008 at 09:27:53PM -0700, Greg KH wrote:
> > >=20
> > > I've now moved my trees around a bit, and would like it if you could
> > > include the following, in this order (the # NEXT_BASE variable is set=
 in
> > > them to make sure things get ordered properly.)
> > > 	driver-core.next
> > > 	usb.next
> > > 	driver-core
> > > 	usb
> > > 	ldp.next
> > >=20
> > > The ".next" trees are what is going to Linus before the next major
> > > release happens (bugfixes and new device ids at this point in time for
> > > example.)  The other trees are what is going to go to Linus after the
> > > next major kernel is out.
> > >...
> >=20
> > So the "next" in your .next has the opposite meaning of the one in=20
> > linux-next?
>=20
> It does?  I was following the convention that people used for their git
> tree branch names I thought.

In their git trees, people usually have a branch called "for-linus" for
fixes to the current tree and "for-next" or "for-akpm" (or "devel" or
"testing") for stuff for the next release).

> > Can you name it .fixes instead to make it clearer?
>=20
> I can name it anything that Stephen wants me to, I'll defer to him as he
> is the only one that will ever really see this.

In linux-next, when the choice is left to me I name the trees like this:

xxx-current	bug fixes and stuff not take yet for Linus' current tree
xxx		stuff for the next release.

Today I have used your names, but Adrian is correct that they are
inconsistent with (at least) my normal usage.

One question: is the driver in ldp.next intended for 2.6.26? Because if
it is, ldp.next should be based on usb.next, not usb. If not then
ldp.next is wrongly named.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_May_2008_11_16_08_+1000_GR_ZjhE+UM+4HfHY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFII6XcTgG2atn1QN8RAijTAJ9EcYG+0+foHjRnnHNQstNu1fRbPQCggYIb
HTWhQHpzXjjsiToman2/IoQ=
=Vns8
-----END PGP SIGNATURE-----

--Signature=_Fri__9_May_2008_11_16_08_+1000_GR_ZjhE+UM+4HfHY--
