Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZGJStb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZGJStb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZGJStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:49:21 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43913 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZGJStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:49:20 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: David Newall <davidn@davidnewall.com>
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Fri, 10 Jul 2009 20:49:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907100023.48039.Martin@lichtvoll.de> <4A569D36.3060707@davidnewall.com> (sfid-20090710_091245_389167_A9F855BE)
In-Reply-To: <4A569D36.3060707@davidnewall.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1278397.KaE20dchdP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907102049.12427.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1278397.KaE20dchdP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Freitag 10 Juli 2009 schrieb David Newall:
> Martin Steigerwald wrote:
> > Am Donnerstag 09 Juli 2009 schrieb David Newall:
> >> What I don't understand is how anybody could be satisfied with the
> >> status quo. We cannot leave vfat unchanged, for that will perpetuate
> >> a pool of victims to be sued, and Linux loses credibility every time
> >> that happens. Something *must* change.
> >>
> >> What is especially attractive about Andrew's position (he said this
> >> more eloquently than me) is that developing a solution to avoid the
> >> patent will impact Microsoft revenues; and that will be most
> >> instructive to them. That's almost sufficient reason by itself!
> >
> > Pardon me, but I just don't get how adapting software to software
> > patents will contribute into solving the problems they cause.
>
> As Andrew said, if we work around a patent without losing function we
> destroy the economic value of that patent.  Nobody would pay licence
> fees for a patent if there was a good work around.  As patent holders
> attack us, we devalue their patents.  Eventually (probably quickly)
> they'll learn not to attack us.

To me your thoughts appear to be *within* the patent approach and *thus*=20
implicitely saying "yes" software patents as such. Going this way I think=20
actually strengthen patents. The FAT patents have not yet been tested.=20
They might easily just be void and invalid.

But going the way you outline would be giving in to the patent claim=20
*before* it has even been tried and tested for validity. And thus IMHO=20
this strengthens the patent and it holder. If you change the upstream=20
kernel Microsoft can always say: "Look Linux kernel developers think that=20
the kernel infringed our patents."=20

The linux kernel has not yet been proven to infringe any FAT patent.=20
Microsoft claims that it does. But so did SCO claim that it contains=20
source of UNIX that they said they have a license for. SCO could never=20
prove that claim. The linux kernel community ignored SCO for exactly that=20
reason. Why on Earth should it handle Microsoft differently?  Just due to=20
its sheer size and weight in capital? The trial with TomTom just proves=20
nothing right now.

> > Instead of
> > implementing a feature like long name + short name support straight
> > forwardly and simply one has to invent utterly complex, error prone
> > and ugly work-arounds that actually even limit the functionality.
> > Actually I do not envy Tridge for doing that job.
>
> It's not a given that working around a patent will result in something
> ugly, error-prone or complex, nor that it will limit function.  But it
> is true that we have to work around them.  We can't permit Linux to
> violate patents (nor can we permit a serious claim of such.)  That
> would cause no end of legal trouble, and would drive vendors away.=20
> Since vfat violates Microsoft's patent, or at least they seriously
> claim it does, we have to do something.  We really have no choice.

Right now to me it seems that it is nowhere but clear that Linux violates=20
valid patents about the inner workings of FAT. Currently any work to adapt=
=20
the kernel to the FAT patents is based on the assumption that they might=20
be valid, not on facts.

> > To me it seems that Microsoft has won if it can get Linux kernel
> > developers to cripple the upstream vanilla kernel in order to avoid
> > software patents.
>
> It's still not certain that we have to cripple Linux to work around the
> long filename patent.  Granted it looks sad, but Andrew is still
> working on it.  If it turns out that we do have to cripple Linux, well
> sometimes we win, sometimes we lose; but if don't at least try we
> always lose. When we work around a patent without losing function we
> win big, and Andrew said that has already happened for other patents.

I just relate to what is currently available. If Tridge posts a different=20
patch things might be different. But right now this is just pure=20
speculation. So I would like to stick to what is actually there. This=20
patch.

> > Microsoft sued only TomTom regarding FAT patents upto now. Why? If
> > they acted like SCO they would have gone against IBM, big Linux
> > distributors like Novell and especially against several companies at
> > once. I think this might be cause that Microsoft just knows that
> > their software patent claim would break down if really tested. I do
> > think that Microsoft does not want those FAT patents to be tested in
> > court. Cause I think they know they would not stand a chance.
>
> I think you're right that Microsoft does not want their patent tested
> in court, but as they have more money than anyone, they could keep a
> patent case in court forever, costing both them and those they sue more
> and more money.  If the other party keeps fighting they stand a real
> chance of running out of money (and thus out of business); or they
> could settle, as Tom Tom did.

I think you omit that doing this would cost Microsoft really lots of=20
reputation. I believe that Microsoft fears testing the patent in trial and=
=20
having a long trial just as much if not more than the company it sues.

Would you buy a Unix or something else from SCO? I wouldn't. Would a=20
company do it? I think only if forced to by compatibility constraints. Now=
=20
SCO OpenServer or what it was called may be more replaceable than Windows,=
=20
but Windows has become replaceable in more and more use cases as well.

If Microsoft would be serious about playing the bad guy they IMHO would=20
pay a forbiddenly high price for it. Actually I believe this would impose=20
a high, probably existential risk to Microsoft. Yes, Microsoft has lots of=
=20
money. But the current economic crisis has shown how easily insane amounts=
=20
of money can be disintegrated in no time. I do think that Microsoft is=20
neither almighty nor immune to that.

And then they would also show even more clearly than ever the absurdities=20
of the current software patent law in the USA. This would strengthen=20
forces that work to revert that law. More politicians would see that the=20
software patent law must be changed.

> > Accepting such a patch IMHO would help Microsoft to get away with
> > seeding fear, uncertainity and doubt and not having the software
> > patent tested and be made void. Actively adapting to software patents
> > gives them a place to be, gives those who support them your energy.
>
> This is wrong.  Doing nothing is what helps Microsoft.

I can't continue aguing on that basis. I just stated my oppinion. You say=20
it is wrong. I can say your oppinion is wrong. But nothing gained by that.=
=20
No need to continue to cycle this. My oppinion is my oppinion and yours is=
=20
yours. And I don't buy your oppinion even when you present it as factual=20
thing.

> > Actually I think just ignoring them would be better.
>
> This is also wrong.  Microsoft have sued Tom Tom, and they won't stop

Same here. Just:

> there.  They'll keep picking businesses to sue; and each time they do
> they'll win; and each time they win, Linux's reputation becomes
> tarnished.  Eventually the manufacturers that build on Linux will move
> to some other platform, which would be a disaster for us.

You seem to know more than me. Sure I can speculate about what Microsoft=20
will be doing and I did. But I am pretty sure that I can not really *know*=
=20
it. Your statements sounds bold enough to suggest that you have looked=20
into a crystal orb of foresay. Did you?

I just point out to you: They didn't do anything else than suing TomTom=20
just yet. Thats fact, unless I did not notice any other trials going on.

> > Shall Microsoft attack IBM or other big companies. Shall Microsoft
> > attack big Linux distributors. Shall they attack the upstream Linux
> > kernel
>
> IBM?  Of course they would, and then Microsoft and IBM would
> cross-licence their patents.  They've probably already done this.

You really think they would? Have they been already that successful at=20
seeding fear, uncertainity and doubt? I bet that they would not dare to=20
challenge IBM on such ridiculous patents.

> Big Linux distributors?  I don't see Red Hat or Novel fighting, should
> Microsoft sue.  They'd know the score, and either settle or remove the
> function.

Sure? What about indemnification assurances regarding SCO claims that=20
AFAIK both Novell and RedHat offered to their customers? SCO is smaller=20
than Microsoft, granted. But still, those patents, the whole software=20
patent law in USA are ridiculous. Giving in to them would probably loose=20
Novell and RedHat more than is gained by testing them and having them=20
declared as invalid and void as they should be declared.

> The upstream kernel developers?  I don't know.  They would if they felt
> they needed to, but the truth is that they can do just as well by
> attacking manufacturers who build on Linux, such as Tom Tom.  How many
> more Tom Toms do you think it would take to drive manufacturers away
> from Linux?  I don't think the number is large.

Directly attacking upstream kernel developers IMHO would backfire even=20
more than suing companies. Do you really think Microsoft can risk to loose=
=20
that much reputation? Do you really think that Microsoft is ready to=20
handle the response of the open-source community, big news sites,=20
companies supporting open-source, lawyers supporting open-source? I think=20
they aren't and I think they know that. And thus I think they would not=20
dare to do it. Right know they only had a go at TomTom. To me this looks=20
like the behavior of coward. Apart from I think Linux including all its=20
surroundings isn't that weak that it needs to fear Microsoft. I think=20
right know its more the other way around.

Granted, speculation, but IMHO a quite plausible one. Anyway I will end it=
=20
here. And as I think there is not much more to be said without recycling=20
arguments I will try to refrain from any comments on arguments that have=20
already been rised.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1278397.KaE20dchdP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpXjR0ACgkQmRvqrKWZhMfcWACgmmFiDdTtGyxhJNaAmRXoOu1a
b34AmgJLHEq2hf5I07eaTG3vyV9KVadO
=NJGP
-----END PGP SIGNATURE-----

--nextPart1278397.KaE20dchdP--
