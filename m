Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXEJXpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXEJXpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXEJXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:45:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36233 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXEJXpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:45:41 -0400
Date: Fri, 11 May 2007 09:45:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 -- powerpc missing kset
Message-Id: <20070511094530.59271fdb.sfr@canb.auug.org.au>
In-Reply-To: <20070510084802.04476f66.randy.dunlap@oracle.com>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<4643068C.8010302@shadowen.org>
	<20070510221631.5eb38bdd.sfr@canb.auug.org.au>
	<20070510084802.04476f66.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_May_2007_09_45_30_+1000_JP.3Gv.TUVkX0Wut"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_May_2007_09_45_30_+1000_JP.3Gv.TUVkX0Wut
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 10 May 2007 08:48:02 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> On Thu, 10 May 2007 22:16:31 +1000 Stephen Rothwell wrote:
>
> > On Thu, 10 May 2007 12:48:28 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> > >
> > > arch/powerpc/platforms/pseries/power.c:31: warning: `struct subsystem'
> > > declared inside parameter list
> >
> > There is no explicit reference to struct subsystem in the current version
> > of that file.
>
> There is in 2.6.21-mm2.  Are you saying that it's been fixed
> somewhere else?  (where?)

Linus' tree.  It was fixed by commit
823bccfc4002296ba88c3ad0f049e1abd8108d30 ('remove "struct subsystem" as
it is no longer needed') from Greg Kroah-Hartman dated 2007-04-14 which
was applied before v2.6.21-mm2 (according to gitk).

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_May_2007_09_45_30_+1000_JP.3Gv.TUVkX0Wut
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQ66iFdBgD/zoJvwRAioKAJ9EQnHa2KDcz7UfCkgDVpuXOZqcGwCeKuD3
FF+KQ38cc485Ay1q+ubiEQ4=
=QxJn
-----END PGP SIGNATURE-----

--Signature=_Fri__11_May_2007_09_45_30_+1000_JP.3Gv.TUVkX0Wut--
