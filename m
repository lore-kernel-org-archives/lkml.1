Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbXKKERj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbXKKERj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 23:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXKKERb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 23:17:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:54396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXKKERa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 23:17:30 -0500
Date: Sat, 10 Nov 2007 20:17:39 -0800
From: John Johansen <jjohansen@suse.de>
To: david@lang.hm
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071111041739.GE19216@suse.de>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey> <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2007 at 03:52:31PM -0800, david@lang.hm wrote:
> On Sat, 10 Nov 2007, Dr. David Alan Gilbert wrote:
>

<snip>

>
> a question for Crispin,
>   is there a wildcard replacement for username? so that you could grant=
=20
> permission to /home/$user/.mozilla...... and grant each user access to on=
ly=20
> their own stuff? I realize that in this particular example the underlying=
=20
> DAC will handle it, but I can see other cases where people may want to ha=
ve=20
> users more intermixed (say webserver files or directories for example)
>
A variable no.  But the current iteration does allow specifying permissions
for files that are owned by the user.  The method to do so has been
changed from the current posting and may change again as their is some
debate as to how best express this.

So system policy can express something similar by doing

owner rw @{HOME}/.mozilla,

where @{HOME} is a user side variable that gets expanded into the
locations of the systems home directories.

>> Allowing a user to tweak (under constraints) their settings might allow
>> them to do something like create two mozilla profiles which are isolated
>> from each other, so that the profile they use for general web surfing
>> is isolated from the one they use for online banking.
>
> the model of being able to add restrictions would still handle this. make=
=20
> two shell scripts (one to start each browser profile) and set the AA poli=
cy=20
> for these scripts to only have access to the appropriate directories.
>
yes you could do this, though I tend to want it just so I can control
which of my files firefox should be able to touch, without messing
up system policy.

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHNoJji/GH5xuqKCcRAo/qAJ4+qjQmc/YAKFxtNLPim3pg+c38owCeJjr9
izqnA9G5nd4MxbgEdv9z9ZA=
=Qj9t
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
