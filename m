Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbXKKD7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbXKKD7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXKKD7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:59:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:52766 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXKKD7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:59:35 -0500
Date: Sat, 10 Nov 2007 19:59:45 -0800
From: John Johansen <jjohansen@suse.de>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071111035945.GD19216@suse.de>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey> <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm> <20071110235609.00958d87@the-village.bc.nu> <Pine.LNX.4.64.0711101720100.4780@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711101720100.4780@asgard.lang.hm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2007 at 05:27:51PM -0800, david@lang.hm wrote:
> On Sat, 10 Nov 2007, Alan Cox wrote:
>
>>> but how can the system know if the directory the user wants to add is
>>> reasonable or not? what if the user says they want to store their
>>> documents in /etc?
>>
>> A more clear example is wanting to wrap a specific tool with temporary
>> rules. Those rules would depend on the exact file being edited at this
>> moment - something root cannot know in advance
>> (although with apparmor I guess mv $my_file apparmour_magic.name ; foo;
>> mv it back might work 8))
>
> the mechanism being desired was that the system administrator would setup=
 a=20
> restrictive policy and a user who wanted a more permissive policy would=
=20
> have the ability to make it more permissive.
>
> this sort of thing is a disaster waiting to happen.
>
yep

> however, if App Armor sets things up so that there can be a system policy=
=20
> that users cannot touch, but users can have a secondary policy that layer=
s=20
> over the system one to restrict things further it could be safe.
>
> if a sysadmin wants to have 'soft' and 'hard' limits of what a user can d=
o,=20
> they could put the 'hard' limits in the system policy (and the users=20
> _cannot_ violate these limits), and then set the 'soft' limits in the use=
rs=20
> default setup (similar to how .profile is set by default). if a user want=
s=20
> to make things less restrictive they could edit or remove the per-user=20
> policy, but would still not be able to violate the system policy.
>
> however, while this seems attractive, I'm not sure that madness isn't dow=
n=20
> the road a little bit. since the users policy would only apply to=20
> themselves, you have the situation that (DAC permissions permitting) the=
=20
> files are available to other confined processes becouse they are running =
as=20
> other users. this sort of thing will surprise people if the explinations=
=20
> aren't done very carefully.
>
yes, the devil is in the details.

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHNn4xi/GH5xuqKCcRAl3FAKCaEI9Gu6qr8+h+516AkWnRM8tsdgCfUO1Y
p+HyBljyYMKN6hkXmuNtxQY=
=rjz9
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
