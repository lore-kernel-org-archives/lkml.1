Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZDZPPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZDZPPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZDZPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:14:51 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:36652 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZDZPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:14:50 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 11:14:50 EDT
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Greg KH <greg@kroah.com>
Subject: Re: RFC about Comedi on a patch that remove a lot fo code
Date: Sun, 26 Apr 2009 11:08:06 -0400
User-Agent: KMail/1.9.9
Cc: Alessio Igor Bogani <abogani@texware.it>, Ian Abbott <abbotti@mev.co.uk>,
       David Schleef <ds@schleef.org>, LKML <linux-kernel@vger.kernel.org>,
       Comedi-ml <comedi_list@googlegroups.com>
References: <63a49ef40904240228g6a28ba8dsf63d2e0bdc6b57d9@mail.gmail.com> <20090424225122.GB3343@kroah.com>
In-Reply-To: <20090424225122.GB3343@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2135799.RMmGHzKQqV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904261108.09527.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2135799.RMmGHzKQqV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 24 April 2009, Greg KH wrote:
> On Fri, Apr 24, 2009 at 11:28:28AM +0200, Alessio Igor Bogani wrote:
> > Dear Comedi developers,
> >
> > Sorry for my bad english.
> >
> > I would be happy to receive your considerations about that patch:
> >
> > http://marc.info/?l=linux-next&m=123792129500760&w=2
> >
> > I know that some users use Comedi on dual kernel approach systems.
> > Obviously I don't have any against this but i think that Linux git
> > tree isn't the right place to support those software (RTAI, Xenomai,
> > RTLinux and others). Those projects already released patches against
> > Linux source code so it very easy for them add also patch for Comedi
> > drivers in the same tarball.
> >
> > At the already listed 8 reasons  in that email I want added a ninth
> > one: 9) Give more chance for interested developers to fix it against
> > RT_PREEMPT http://marc.info/?l=linux-rt-users&m=124049407712792&w=2
>
> I am siding with you, and agree all of the RT stuff should be deleted
> from the in-kernel comedi code, as there is on in-kernel users of it.
>
> Also, the recent Linux RT changes will not need any of these
> driver-specific changes at all from what I can tell, so they are now
> obsolete.
>
> Frank, unless you have any major objections, I'd like to remove this
> code.

I'm okay with it.


--nextPart2135799.RMmGHzKQqV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ9HjX5vihyNWuA4URArS/AKDqq3kD4C0hb4TIUVqZajemJV9IBgCgoeJe
fLCcywb3VLKaX9BWTAKNZXI=
=/l+0
-----END PGP SIGNATURE-----

--nextPart2135799.RMmGHzKQqV--
