Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYAPKNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYAPKNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYAPKN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:13:28 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54914 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbYAPKN1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:13:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: mtime updates for mmapped files.
In-Reply-To: Your message of "Wed, 16 Jan 2008 18:03:17 +0800."
             <a8e1da0801160203s234f7005k3e95aa8b007c0f70@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20080116094640.GA2071@bitwizard.nl>
            <a8e1da0801160203s234f7005k3e95aa8b007c0f70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200478395_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 05:13:15 -0500
Message-ID: <10071.1200478395@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200478395_2966P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jan 2008 18:03:17 +0800, Dave Young said:
> On Jan 16, 2008 5:46 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> >
> > Hi,
> >
> > I  wrote a small app yesterday that updates a file by mmapping the
> > file (RW), changing the thing around, and then exiting.
> >
> > This did not trigger a change in the mtime of the file. Thus rsync
> > didn't pick up that the file had changed.
> >
> > I understand that tracking every change to a RW mmapped file is
> > costly, and thus unfeasable, but shouldn't then the close cause a
> > mtime update?
> >
> > The server where this happened is running 2.6.21, so my apologies if
> > this has already been corrected.
> 
> This is an old bug, don't know if it was fixed or not. Please see
> http://lkml.org/lkml/2006/5/17/138

If it was fixed, we'd not be having the currently ongoing long thread about how
to fix it. :)

See also:
http://lkml.org/lkml/2007/2/21/242
http://lkml.org/lkml/2008/1/7/234

(Note the last is the start of the *current* thread...)


--==_Exmh_1200478395_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjdi7cC3lWbTT17ARAn1BAKCVIfOOafrayFhg8Yxl0wTUz/wqogCeOb45
9hFzgrvqNDeXKQHb0/oNl2g=
=jvCn
-----END PGP SIGNATURE-----

--==_Exmh_1200478395_2966P--
