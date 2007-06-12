Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbXFLRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbXFLRZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbXFLRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:25:22 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:1149 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbXFLRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:25:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: kernel scedular
Date: Tue, 12 Jun 2007 19:24:57 +0200
User-Agent: KMail/1.9.7
References: <466B45D3.3020104@gmail.com> <alpine.LFD.0.98.0706091731020.20321@woody.linux-foundation.org> (sfid-20070612_171643_519639_3A5C9A70)
In-Reply-To: <alpine.LFD.0.98.0706091731020.20321@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2262094.M4xEuvb2Wy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706121925.02286.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2262094.M4xEuvb2Wy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 10 Juni 2007 schrieb Linus Torvalds:

Hi Linus!

> Ehh.. It was tested extensively by lots of people. It was in -mm for a
> while, and yes, there have been tons of people testing both. I've
> followed it, and it seems fair to say that yes, Ingo took a lot of
> ideas from SD, but CFS seems to have gotten more people involved, and
> we had several people compare the two, and CFS was generally better.

Well actually I did not see that general result yet. I have seen quite=20
some testings and quite some reports on the ck patch mailinglist also=20
where in favor of SD. If it matters I will collect those, but I think=20
Ingo already did include most of them in his summary.

Ingo's own mail collecting feedback results does not indicate any favorite=
=20
yet[1]:

" Thibaut Varene:          ...
 Serge Belyshev:          ...
 Tobias Gerschner:        about equal (-v?)
 Michael Gerdau:          about equal (-v13)
 Vytautas Stankevicius:   CFS not as interactive (-v?)
 Markus Trnqvist:         ...
 "brihall":               ...
 Diego M. Vadell:         ...
 Cory Grunden:            about equal (-v15)
 Vincent Fortier:         about equal (-v14)
 Jason F. McBrayer:       CFS not as interactive (-v8)
 Maciej Soltysiak:        ...
 Michael Chang:           ...
 Matthew Hawkins:         CFS audio stuttering (-v11)
 Martin Steigerwald:      about equal (-v11)"

http://bhhdoa.org.au/pipermail/ck/2007-June/007794.html

According to Ingo most of the interactivity issues should be fixed by now.=
=20
Still I do not see how that translates to "CFS was generally better".

What I read from recent feedbacks last mails is: They are generally on par=
=20
while there are still reports that one or the other performs better in=20
some area:

=2D possibly a new CFS regression:
http://bhhdoa.org.au/pipermail/ck/2007-June/007871.html

=2D stable / more fair massive_intr results?:
http://bhhdoa.org.au/pipermail/ck/2007-June/007878.html

> That's how open source works.

How it should work and can only work if feedback is collected before=20
summarizing it! IMHO you came to the "CFS was generally better"=20
assumption to early. In my perception a general result in favor of one of=20
the schedulers is *not yet there*!

> Does maintainership matter? Of course it does. Ingo has effectively
> been the maintainer of the scheduler for the last five years or so. So
> his code and words tends to weigh more heavily. AS IT SHOULD.

Agreed. Also it is important on how good a developer is able to support=20
his addition. Both developers did their best to fix bug reports and=20
issues. To me it seems that Ingo has a bit more time, manpower - partly=20
due to the health issues of Con - to spare.

> But in the end, technology is what matters. Several of the benchmarks
> showed that CFS does really really well in the fairness area.

Such as? Really well as in "better as SD"?

> So yes, everybody is biased. That's a fact of life. Anybody who tells
> you he is totally unbiased is lying.=20

Yes, exactly.

Yet, in my perception even those biased oppinions to not yet tend to favor=
=20
*one* of the schedulers. And as someone to decide on which scheduler to=20
include you should really collect the available feedback *before*=20
summarizing it. And honestly I do not think you did a good job on that.

> But we do try to make decisions on=20
> technical grounds, and right now CFS seems to be winning.

Actually I do not yet see this (see above). Could be that I am missing the=
=20
reports you indirectly refer to.

> A big issue for me is also the difference in how Con and Ingo took
> criticism. Both SD and CFS were criticized by various people over
> different things, and quite frankly, Ingo ended up trying to figure out
> why something didn't work, while Con ended up getting involved more in
> flame-wars with the people who criticised SD.
>
> Is that important too? Yes it is.

My perception is differently here too. As far as I read and saw Con worked=
=20
upto his personal limits and likely beyond them in order to fix bugs and=20
issues.=20

As I seen he reacted frustrated when it seemed to him that the decision on=
=20
which scheduler is to go into the kernel has already been made. Which=20
IMHO is quite understandable. Whether his perception of the decision=20
already made matches yours or that of Ingo is a different question tough.

> And yes, apparently Con was sick for part of the time, and that
> certainly didn't help, but in the end, right now it looks like Con
> should take a lot of pride in having shown where the current scheduler
> has problems, and convinced Ingo to fix them - somewhat differently
> than Con did, but the thing that matters is whether the end result is
> better, not who or how it got there.

True of course.=20

At least in my subjective testing I can't tell any difference anymore, so=20
it boils down to design criteria, code size, ability to maintain...

[1] http://bhhdoa.org.au/pipermail/ck/2007-June/007794.html

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2262094.M4xEuvb2Wy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbtbumRvqrKWZhMcRAvjJAJ9da81wJozFdCLUiWQSglQnfEn8ZwCffIwI
qleCb5JIxiW+eA7CuySx7oo=
=FrKR
-----END PGP SIGNATURE-----

--nextPart2262094.M4xEuvb2Wy--
