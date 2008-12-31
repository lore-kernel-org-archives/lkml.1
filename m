Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYLaLfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYLaLfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYLaLfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:35:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:41340 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYLaLfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id:from;
        b=WXbHHRsoCy/6q5H+yQYAmLpX/GxE/mXZO9MxeowQBVzXGshw/t5s0KcFZNwrVLWv9J
         c/qdSWx3i/aZLBewkASmUfc6rP5Uj49SlWFzWdTX1HVUULVe1zm4ELg6606xKkkB42jy
         r/7CWoIWuaiWngM+0rmyot7Ez8tmodWJcMTps=
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Wed, 31 Dec 2008 11:09:11 +0100
User-Agent: KMail/1.9.9
Cc: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200812310000.55256.phillips@phunq.net> <495B2A02.5010701@gmail.com> (sfid-20081231_102522_624170_EF6300E3)
In-Reply-To: <495B2A02.5010701@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart30023451.OHNcsNj8bl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812311109.12635.Martin@lichtvoll.de>
From: Martin Steigerwald <martin.steigerwald@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart30023451.OHNcsNj8bl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
> Daniel Phillips wrote:
> > On Tuesday 30 December 2008 23:34, sniper wrote:
> >> Great, I have mounted tux3 filesystem under UML with stuffs in this
> >> mail, but I still can't debug it with gdb. Anyone gives me
> >> suggestion?
> >
> > You just have to give a "cont" command a bunch of times and you will
> > eventually get to a command prompt.  The reason for this is, uml uses
> > the segfault interrupt as part of its machine simulation, and there
> > is no exsiting way for uml and gdb to communicate in such a way that
> > uml can recognize that the interrupt came from its own code and
> > filter it.

[...]

> Hmm.. seems like a redundancy;
> Anyways I looked at you're site, but am still
> confused at what tux3 is: what is tux3?
>
> (at first I thought it was  a  video game, but was wrong);
> can I use tux3 to secure a linux system or is it for
> something else?
>

Hmmm, I thought

=2D--------------------------------------------------------------------
Tux3 is a write-anywhere, atomic commit, btree-based versioning=20
filesystem. It is the spiritual and moral successor of Tux2, the most=20
famous filesystem that was never released. The main purpose of Tux3 is to=20
embody Daniel Phillips's new ideas on storage data versioning. The=20
secondary goal is to provide a more efficient snapshotting and=20
replication method for the Zumastor NAS project, and a tertiary goal is=20
to be better than ZFS.
=2D--------------------------------------------------------------------
http://tux3.org/

was pretty clear. What are you missing?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart30023451.OHNcsNj8bl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklbRMgACgkQmRvqrKWZhMcXjwCcDn9ibqsKjdzUdhsPhxNotd7h
crIAoIamoMzec5iFz/sfhFa5cRdxv0jX
=Nrub
-----END PGP SIGNATURE-----

--nextPart30023451.OHNcsNj8bl--
