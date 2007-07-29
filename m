Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbXG2Jh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbXG2Jh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbXG2JhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:37:15 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3625 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760989AbXG2JhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:37:13 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 11:37:04 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>, lkml@metanurb.dk
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070728225148.a0e58fdd.diegocg@gmail.com> <alpine.LFD.0.999.0707281401280.3442@woody.linux-foundation.org> (sfid-20070729_101104_135633_B9986945)
In-Reply-To: <alpine.LFD.0.999.0707281401280.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart59306754.EtHrZ5Sb3e";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707291137.10605.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart59306754.EtHrZ5Sb3e
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 28 Juli 2007 schrieb Linus Torvalds:
> On Sat, 28 Jul 2007, Diego Calleja wrote:
> > El Sat, 28 Jul 2007 11:05:25 -0700 (PDT), Linus Torvalds=20
<torvalds@linux-foundation.org> escribi=F3:
> > > So "modal" things are good for fixing behaviour in the short run.
> > > But they are a total disaster in the long run, and even in the
> > > short run they tend to have problems (simply because there will be
> > > cases that straddle the line, and show some of _both_ issues, and
> > > now *neither* mode is the right one)
> >
> > I fully agree with this, but plugsched could have avoided this
> > useless "division" on the topic of SD vs CFS. IMO that counts as an
> > advantage, too ;)
>
> Sure. I actually think it's a huge advantage (see the ManagementStyle
> file on pissing people off), but at the same time, I don't like playing
> politics with technology. The kernel is a technical project, and I make
> technical decisions.

IMHO thats an illusion. The kernel has become a community project pretty=20
soon after you have released it initially. And the community members are=20
human beings. Thus while the kernel source code in itself for sure=20
describes technical processes, the kernel is more than just a technical=20
project.

> So I absolutely detest adding code for "political" reasons.

I can understand this and I agree to it, cause it would mean fixing=20
political things on technical grounds and thus not fixing them at all.

> I personally feel that modal behaviour is bad, so it would introduce
> what is in my opinion bad code, and likely result in problems not being
> found and fixed as well (because people would pick the thing that
> "works for them", and ignore the problems in the other module). So
> while I don't like making irreversible decisions (and the choice of CFS
> wasn't irreversible in itself, but if it pisses off Con, _that_ is
> generally not reversible), I dislike even more making a half-assed
> decision.

I agree to this to some extent. But if the mainline kernel does not=20
contain suitable solutions for one subsystem people will tend to plug in=20
other solutions that work for them even where there is no boot or runtime=20
plugability.

I have been using TuxOnIce (formerly suspend2) for quite some time and=20
didn't even try the in-kernel-suspend-to-disk stuff since quite some=20
kernel versions since I could not have been bothered anymore after it was=20
failing back then.

So when there are two different approaches with good following it may have=
=20
be good to have some plugability for testing things. But it may be=20
difficult to remove it afterwards again..., but it would still be=20
possible to remove plugins that are only used rarely and they how the=20
other ones evolve.

> So rather than making a choice at all, my other choice would have been
> to not merge _either_ scheduler, and let people just continue to fight
> it out. Would that have made people happier? I seriously doubt it.

I tried speaking to Con and Ingo whether they could settle their issue=20
with one another and work together. In *private* mails, away from all the=20
flame throwing.

Actually I believe that human things should be resolved on the human side,=
=20
not on the technical one. And as I perceive no serious attempt has been=20
made on that - except my own maybe.

Maybe just writing an email to both Con and Ingo where you told both of=20
them your concerns and thoughts would have helped a lot. A

"Hi Con and Ingo,=20

Con, I do not believe that you are able to maintain SD for reason 1,2 and=20
3. But I do think that Ingo could. But I think, that you wrote great code=20
and brought in good scheduler concepts and ideas to the Linux world. Now=20
Ingo has CFS and you have SD... could there be a way for you to stay=20
involved with scheduler issues and work together with Ingo? If so how=20
could it look like?

Ingo, do you see areas where Con can help you with? Are there things in SD=
=20
that you would like to have in CFS? Do you see a way to work with Con=20
together on the scheduler?"

(just a draft;-)

for example. It would have given Con some recognition for his work. It=20
could have helped to address the political, well not even the political,=20
but the human issue here. I believe that this is what Con missed the=20
most: Getting some form of recognition from the "official" kernel people!=20
I tried to give some recognition, but I am "just" a user of his patches.

Would that have been difficult for you to write, Linus?

Its not too late for giving Con some recognition. A simple=20

"Hi Con,=20

I am sorry that you decided to leave kernel development. I felt I had to=20
make a decision about the scheduler thing and these where my concerns...

I just wanted to tell you that I did not mean any personal offence with=20
you and did not have any real issue with your code at all,=20

Regards Linus"=20

as an aftermath could still help. Just a little gesture maybe - but it can=
=20
make a big difference. Maybe without even asking him to come back... I=20
think Con made his decision for now at least.

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart59306754.EtHrZ5Sb3e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGrF/GmRvqrKWZhMcRAqF/AJ4yThuadOqz+6++KH8paLbpx3eTQQCgsVX3
QnY8B0J4lTv6nPdZ1OYSq7U=
=1xrd
-----END PGP SIGNATURE-----

--nextPart59306754.EtHrZ5Sb3e--
