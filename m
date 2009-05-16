Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZEPTHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZEPTHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZEPTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:06:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40700 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZEPTG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:06:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tuxonice-devel@lists.tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Sat, 16 May 2009 21:07:51 +0200
User-Agent: KMail/1.9.9
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> (sfid-20090506_173640_428357_64FE3098)
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4186167.SPQ7UsC5Dk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905162107.58677.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4186167.SPQ7UsC5Dk
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 06 Mai 2009 schrieb Nigel Cunningham:
> I'd like to submit TuxOnIce for review, with a view to seeking to get
> it merged, perhaps in 2.6.31 or .32 (depending upon what needs work
> before it can be merged) and the willingness of those who matter.
>
> To briefly summarise the advantages to merging TuxOnIce:

As a user I support this.

Why?

Cause everytime I tried TuxOnIce just worked while I had various problems=20
whenever I tried out any in-kernel snapshot stuff, be it hard-wired or=20
userspace supported. Actually I never could have been bothered to try out=20
to fix any issues with these while I just had a working solution and=20
thats TuxOnIce. Might have been that issues could have been fixed - but=20
exactly why should I care when I have something that just works? Honestly=20
I can't even be bothered to remember those issues in detail. It was=20
crashes, hangs and on the last occurence of testing mostly slowness while=20
it basically worked mostly. Release versions of TuxOnIce didn't fail for=20
me as long as I can remember.

My case for TuxOnIce?

shambhala:~> cat /sys/power/tuxonice/debug_info
TuxOnIce debugging info:
=2D TuxOnIce core  : 3.0.1
=2D Kernel Version : 2.6.29.2-tp42-toi-3.0.1
=2D Compiler vers. : 4.3
=2D Attempt number : 39
=2D Parameters     : 0 667656 0 1 700 5
=2D Overall expected compression percentage: 30.
=2D Checksum method is 'md4'.
  0 pages resaved in atomic copy.
=2D Compressor is 'lzo'.
  Compressed 528949248 bytes into 223456685 (57 percent compression).
=2D Max outstanding reads 570. Max writes 132.
  Memory_needed: 1024 x (4096 + 216 + 72) =3D 4489216 bytes.
  Free mem throttle point reached 0.
=2D SwapAllocator active.
  Swap available for image: 661830 pages.
=2D FileAllocator inactive.
=2D I/O speed: Write 41 MB/s, Read 35 MB/s.
=2D Extra pages    : 18 used/500.
=2D Result         : Succeeded.

39 attempts and counting.

I have seen uptimes of up to almost 70 days and this one has only been=20
interrupted by user error - shutting down instead of triggering snapshot.

shambhala:~> uprecords | head -12 | cut -b1-56
     #               Uptime | System
=2D---------------------------+---------------------------
     1    31 days, 01:07:24 | Linux 2.6.26.5-tp42-toi-
=2D>   2    17 days, 21:47:04 | Linux 2.6.29.2-tp42-toi-
     3    17 days, 12:38:36 | Linux 2.6.28.8-tp42-toi-
     4    15 days, 14:39:26 | Linux 2.6.28.4-tp42-toi-
     5    15 days, 13:58:12 | Linux 2.6.27.7-tp42-toi-
     6    12 days, 21:54:18 | Linux 2.6.26.5-tp42-toi-
     7    10 days, 22:02:14 | Linux 2.6.28.7-tp42-toi-
     8    10 days, 08:04:52 | Linux 2.6.26.2-tp42-toi-
     9     8 days, 00:34:34 | Linux 2.6.28.7-tp42-toi-
    10     7 days, 12:56:54 | Linux 2.6.28.8-tp42-toi-

(uprecords cuts kernel version, so concrete TuxOnIce versions are missing.=
=20
Including low uptimes with 2.6.28 due to hard crashes during preparing=20
hibernation when the switch from X11 to console frame buffer was about to=20
come - which luckily appear to have gone with 2.6.29. And from time to=20
time I can be bothered to upgrade the kernel as well.)

And the speed - which even got higher after the switch from LZF to=20
in-kernel LZO:

shambhala:~> zgrep "I/O speed" /var/log/syslog | sed 's/localhost //' |=20
tail -10
May 10 18:15:09 kernel: - I/O speed: Write 49 MB/s, Read 48 MB/s.
May 11 09:37:31 kernel: - I/O speed: Write 49 MB/s, Read 45 MB/s.
May 12 08:22:55 kernel: - I/O speed: Write 46 MB/s, Read 45 MB/s.
May 12 19:40:25 kernel: - I/O speed: Write 45 MB/s, Read 42 MB/s.
May 13 09:03:34 kernel: - I/O speed: Write 44 MB/s, Read 35 MB/s.
May 13 19:21:31 kernel: - I/O speed: Write 50 MB/s, Read 39 MB/s.
May 14 08:51:45 kernel: - I/O speed: Write 46 MB/s, Read 38 MB/s.
May 15 08:52:53 kernel: - I/O speed: Write 46 MB/s, Read 40 MB/s.
May 16 12:56:10 kernel: - I/O speed: Write 53 MB/s, Read 54 MB/s.
May 16 19:08:55 kernel: - I/O speed: Write 41 MB/s, Read 35 MB/s.

Thats on ThinkPad T42 with 160 GB Hitachi IDE drive.

My conclusion: TuxOnIce is awesome.

I do not add anything more to the general discussion. I am fine with=20
TuxOnIce replacing in-kernel snapshot implementation. I am also fine with=20
TuxOnIce serving as inspiration to make in-kernel snapshot better. But I=20
for my take can't be bothered to waste my precious time to try out=20
in-kernel stuff again unless I can be convinced that it might have a=20
competitive reliability, speed and feature set. In the role of an user I=20
can be very lazy. TuxOnIce in kernel would convince me, thats for sure.=20

I am pretty puzzled that apparently apart from Sam Ravnborg no kernel=20
developer made any public review of concrete patches.

I think the effort of Nigel deserves a bit more than general comments and=20
the usual userspace versus in kernel discussion. At least some hints for=20
Nigel for what he should change in general in order to improve the=20
likelihood of a review. In the moment it appears to me that it has been=20
rejected without even looking at it.

So what are the *concrete* issues with the patchset Nigel posted?

I respect that kernel developers have the right to be lazy as well ;). And=
=20
I am free to compile my own kernels for as long as I see fit with=20
TuxOnIce being probably my only reason to do so.

But I ask for at least some concrete feedback on the concrete patchset=20
Nigel posted, instructions for Nigel on what to change / do differently -=20
apart from that general and repetitive discussion. Does the patchset need=20
to be smaller? Should patches be split or joined? Should comments be=20
improved? Should the patchset be structured differently?

And when replacing in kernel snapshot implementation by TuxOnIce is=20
completely out of question - even without looking at the concrete=20
patchset - I ask for concrete hints on alternative approaches Nigel could=20
follow.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart4186167.SPQ7UsC5Dk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoPDwgACgkQmRvqrKWZhMcm2gCcCSf8f5i6NhYSagZPudBhThDO
tjcAoIIPFggVSKG58cgkWBhq8lgpB2/F
=ThtF
-----END PGP SIGNATURE-----

--nextPart4186167.SPQ7UsC5Dk--
