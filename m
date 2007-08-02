Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbXHBQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbXHBQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbXHBQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:47:58 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3624 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbXHBQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:47:57 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org, whansard@sbcglobal.net
Subject: Re: [ck] Re: ck vs. cfs : realtime audio performance
Date: Thu, 2 Aug 2007 18:47:44 +0200
User-Agent: KMail/1.9.7
References: <1745683987@web.de> <20070802115952.6cd4b217.whansard@sbcglobal.net> (sfid-20070802_173626_936634_A2AF5520)
In-Reply-To: <20070802115952.6cd4b217.whansard@sbcglobal.net>
Cc: linux-kernel@vger.kernel.org, Carlo Florendo <subscribermail@gmail.com>,
       Lenar =?iso-8859-1?q?L=F5hmus?= <lenar@city.ee>,
       Klaus Schulz <Klaus.Schulz@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1308718.zCFkd9BAEJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708021847.49271.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1308718.zCFkd9BAEJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Stripped CC list restored.

Am Donnerstag 02 August 2007 schrieb Will:
> > > -----Urspr=FCngliche Nachricht-----
> > > Von: Carlo Florendo <subscribermail@gmail.com>
> > > Gesendet: 02.08.07 08:27:01
> > > An: Lenar L=F5hmus <lenar@city.ee>
> > > CC: Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org,
> > > linux-kernel@vger.kernel.org, mingo@elte.hu Betreff: Re: ck vs. cfs
> > > : realtime audio performance
> > >
> > > Lenar L=F5hmus wrote:
> > > > Klaus Schulz wrote:
> > > >>> I am currently testing the 2.6.22.1 cfs-rt9 vs. ck1 on my
> > > >>> rather pure realtime high-end-audio setup. (NO X, just a
> > > >>> terminal, streaming .wav. I am using my own written player and
> > > >>> brutefir as the audio engine.)
> > > >>> Comment: This is not a standard (amarok or xmms setup), all
> > > >>> buffers in the chain are very small. Any problem will
> > > >>> immidetialy end up in xruns. The sounddriver, HW (pci-bus etc.)
> > > >>> are tweaked accordingly Until now ck1 on 2.6.22 is giving me
> > > >>> better results (less audible distortions) and runs extremely
> > > >>> stable compared to cfs. Under ck I ran my player with schedtool
> > > >>> -R -p 98, which was better than running it e.g. with nice -20
> > > >>> Both setups under cfs were giving me worse results than ck.
> > > >>> With CFS I also experienced XRUNS from time to time, what never
> > > >>> happened with ck.
> > >
> > > See, this is exactly the problem of the SD ranters.  A ranter posts
> > > a problem, doesn't give reproducability hints, and neither provides
> > > technical detail, not even the slightest relevant stats.  And the
> > > most irritating part is that the code that the OP wrote (or at
> > > least its relevant parts) is not even available for download.
> > >
> > > I was wondering why the OP need timers for audio playback.  What
> > > type of audio?  PCM, MIDI?  Once does not need timers for PCM
> > > playback but for MIDI.
> > >
> > > SD ranters. Pure rants.
> > >
> > > Thank you very much.
> > >
> > > Best Regards,
> > >
> > > Carlo
>
> I just think it's funny that there's a group of "SD Ranters", and that
> they have a problem, or cause a problem, or both.  And someone
> has been sitting around trying to figure just what the problem is
> with these "SD Ranters".

And I just think this is getting more and more ridiculous.

If Klaus writes he has given Ingo all debug information Ingo requested, I=20
have no reason to believe otherwise until Ingo says he did not receive=20
the information. And before it is clear that this information has not=20
been given, I would not assume this. And if its not in the public post by=20
no way this means they have not been given to the person(s) in charge to=20
fix that potential problem.

I am really upset, cause its actually quite some of those "SD ranters"=20
that actually helped Ingo to get CFS to match the experience that SD gave=20
to them. And it didn't match it initially. (It now seems to do here and=20
thats fine of course.)

Well I think I will just continue to send Ingo pointers to things that=20
look like regression reports *privately*. Cause that avoids the "rants=20
against anyone who looks remotely like someone who likes SD" quite=20
effectively.

The tone I see on responses to posts that are CCed to LKML in my=20
perception often is just completely and utterly awfully unfriendly. And=20
often those responses actual include factual inaccuracies and preliminary=20
assumptions as well. Is that how Linux Kernel Management Style is=20
supposed to work? I hope not. Once in a while IMHO it makes a lot of=20
sense to learn at least some of the basics about how communication works!=20
Cause otherwise you get what happens here.

I do not know how Klaus feels now, but I wouldn't be surprised when he was=
=20
fed up by getting this back when actually he tries to help debugging a=20
potential problem - likely in this free and unpaid time. What would have=20
been if Klaus did not write that he used SD? I think he would have been=20
treated quite differently then.

So now to me it seems LKML people begin to scare away people who actually=20
help debugging CFS just cause they like SD as well - as if scaring away=20
Con was not enough. When I see this I more and more understand Con's=20
decision to stay away from anything that even remotely has something to=20
do with Linux Kernel development.

If people just started to say they are angry, cause ... instead of=20
accusing one another that would be a good start. What Carlo has said=20
could have been said as well like this:

"Hi Klaus!

I did not found any information on how to reproduce the problem in your=20
post. I am quite upset about this, cause I think people who like SD often=20
do not provide good informations on how to reproduce a problem with SD.

Could you please provide these informations?

What audio settings do you use? ...

Thanks.

Regards,
Carlos"

That in my perception would transport exactly the same facts, but it would=
=20
have a completely different impact on the people involved. It would=20
encourage involvement instead of scaring it away. It even would not be=20
longer than the original post by Carlo.

Tthats in no way meant against you, Carlo, everyone - including myself -=20
can learn to communicate in that way. I try to do it, but with differing=20
success. Its not easy to stay with myself when I am upset, cause then I=20
have to feel my emotions in me instead of venting them off at the cost of=20
other people.

(Actually I want to stay away from this discussion at the moment, but I am=
=20
really upset when I see such kind of communication in threads where=20
people are working on *solving* potential problems.)

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1308718.zCFkd9BAEJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGsgq1mRvqrKWZhMcRAlGFAJ9H0iWZx8bnUVyy+lHWQWarYnFJpgCfXVc/
VOikGnzVmRV2nFs4pmFWzYw=
=KwAg
-----END PGP SIGNATURE-----

--nextPart1308718.zCFkd9BAEJ--
