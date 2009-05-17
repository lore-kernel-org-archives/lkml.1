Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZEQVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZEQVMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZEQVMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:12:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:55638 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZEQVL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:11:59 -0400
Date: Sun, 17 May 2009 23:11:35 +0200
From: Florian Mickler <florian@mickler.org>
To: Rob Landley <rob@landley.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: http://www.kernel.org/doc/local/git-quick.html#bisect
Message-ID: <20090517231135.3c740ab2@schatten>
In-Reply-To: <200905151820.05246.rob@landley.net>
References: <20090515121829.60de2210@schatten>
	<200905151820.05246.rob@landley.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tFTnEEzb89x/qS=9JlHwBRR";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tFTnEEzb89x/qS=9JlHwBRR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi!

Sorry. It seems we started off on the wrong foot.

I know that one never ends learning and I am glad you took the
time to write this stuff down because it helps.=20
So let this be clear between us, i'm not trying to offend you and the
criticism is only about git-quick.html as it is found by google. =20

I choose the 'the sky is falling' attitude to 'shout into the
woods' and provoke at least some response. (not knowing where or who
the maintainer was... )


On Fri, 15 May 2009 18:20:04 -0500
Rob Landley <rob@landley.net> wrote:

> On Friday 15 May 2009 05:18:29 Florian Mickler wrote:
> > Hi Rob!
> >
> > I'm writing to this emailadress, because I went down from $subject
> > to doc/local to doc/  and yours was the first email-adress I found.
> >
> > Who is maintaining $subject? I found it via google searching for git
> > bisect.
>=20
> Um, me?

perhaps you should add that bit of information to it then?=20

>=20
> I wrote it way back when, because I had to learn how to use git
> enough to do a bisect and it wasn't properly documented then.  (At
> least three other people have written up their own bisect howtos on
> it since then.)
>=20
> People poke me about it from time to time, but mostly I personally
> use mercurial.

which is fine and i appreciate your effort.

>=20
> > Instead you should use
> > git bisect skip or
> > git bisect visualize and choose another commit to test.
>=20
> I believe that both of those options were implemented _after_ I wrote
> the above document.  (People keep telling me that the user interface
> of git can't be said to "suck" because it keeps changing.)

yes. so my email is all the more relevant, or not?

>=20
> > If you guess wrong, your bisection result is not valid anymore.
>=20
> Which is why it tells you how to back up to where you guessed so you
> can try it the other way when you guess wrong.  (Did you stop reading
> when you encountered the first thing you disagreed with?)  Lemme cut
> and paste the appropriate chunk:

of course i stopped _not_. Who do you think i am! :)

>=20
>   If you guess wrong (hint: every revision bisect wants
>   to test after that comes out the opposite of your guess, all the
> way to the end) do a <b>git bisect replay ../bisect.log</b> to
> restart from your saved position, and guess the other way.

which is exactly my point: you need to replay and wasted 10
 reboot+compile cycles.
AND it may be possible that every test after your guess comes out the
opposite of your guess but you guessed right nonetheless. this does
not tell you that your guess was wrong! it is not even a pre-requisit
for your guess being wrong.=20

suppose the following:=20

Good--+---B--1+--------BAD
       \     / =20
        ----2  =20

("B" being the bug-introducing changeset, "1" the first tested commit,
"2" the 2nd tested commit, "-" some other commit and "+" some merge or
branchpoint. )

you guess wrong at 1 (this means you classify 1 good.)
second commit is 2 which is good, as there the bug B was never
introduced. so you get 2 as good. which is not the opposite of your
guess.=20

> The ability to do that sort of thing would presumably be why they
> implemented the replay option in the first place.

well,  i would say they introduced it so one can doublecheck the tests
if one realizes that maybe unplugging the speakers is overshadowing the
bug "speakers don't work in rc5, but in rc1 they worked". or smth like
that. but this is irrelevant.

>=20
> > (and that really sucks, because all your compiliations after that
> > one are _worthless_ ).
>=20
> No, they demonstrate that the bug isn't in that fork, at which point
> you back up and check the other fork.
no... you never know because you
have no way of knowing if the bisection succeeded or not.=20

> > But if you defer the decision for that commit (via git-skip) you at
> > least get a range of commits including the bad
> > commit, or if the commit immidiatly before the bad commit is
> > buildable, you even get the right bad commit.
> >
> > i'm quoting the text that neeeds to be _removed_:
>=20
> I'm going to give you the benefit of the doubt and assume that
> "neeeds" isn't a typo rather than a "badwrong" _word_ indicating how
> _falling_ the -=3D>*[(SKY)]*<=3D- is today.

if you use git-bisect skip there is the (large) chance that your
skipped commit is based ontop of a test-able commit which already has
the bug. so you don't  need to guess, but have the chance to get a
correct bisection result.  so i think the 'needs' is warranted.
(relative to the impact git-bisect has on one's life...)

>=20
> Last time somebody poked me about this I added this bit:
>=20
>   Note: you can also tell git itself to skip a commit you can't test
> with git bisect skip.  Unfortunately, the git-bisect man page gives
> this warning about the "skip" command:
>=20
>     But computing the commit to test may be slower afterwards and git
> may eventually not be able to tell the first bad among a bad and one
> or more "skip"ped commits.

this is nonsense (the ''being slower part'').  the other part:
the first bad among a bad and one or more skipped commits is of course
true. but what do you expect? at least you can defer the guessing to
the end of the bisection. maybe the skipped commits are ''cut off'' by
test-able commits. so you don't need to guess about them . at the very
least you get a range of commits which contain the bad one.=20


> Let me know when they sky _finishes_ falling for you, and then if
> you'd like to send a slightly less hysterical message I might take a
> closer look at what git's doing this week and see if it's actually
> changed since the last time I was paying attention.  (Keep in mind
> that since my laptop's still running Ubuntu LTS, because 8.10's
> wireless support spontaneously ate itself so badly I had to
> reinstall, and 9.04 doesn't like Intel 3D chipsets.  So I'll have to
> build git from source to see how the "current" versions differ from
> that...)

i guess this is not necessary, as it is not implementation specific but
fundamental to the princip of binary-search.=20

>=20
> But you have yet to convince me anything's actually wrong...

of course! i never expect someone to do smth without being convinced.
some do, but thats a sign of not caring, being intimidated or being
stupid.=20

sincerely,

Florian

--Sig_/tFTnEEzb89x/qS=9JlHwBRR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoQfZQACgkQPjqCkyL3Kv1oeACgxVnLFZjzsRXjuDExwhX7RvmE
UtwAn3Y/dhNbfZWOtOMyc7by22a3Rfh8
=CvBo
-----END PGP SIGNATURE-----

--Sig_/tFTnEEzb89x/qS=9JlHwBRR--
