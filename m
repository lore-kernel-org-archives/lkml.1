Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZGHLkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZGHLkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZGHLkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:40:06 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49102 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZGHLkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:40:02 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tridge@samba.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Wed, 8 Jul 2009 13:39:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> (sfid-20090708_090154_372988_3A419270)
In-Reply-To: <19028.3736.892828.352905@samba.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1676513.uhJ5EfJChu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907081339.59815.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1676513.uhJ5EfJChu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 08 Juli 2009 schrieb tridge@samba.org:
> Hi Martin,

Hi Tridge,

>  > Have low level filesystem check, repair and cloning tools been
>  > checked against the patch at all?
>
> I have tested chkdsk.exe obvious, and I have reported the bug in
> chkdsk that this testing has found to Microsoft.
>
> I haven't tested tools like ghost or 3rd party tools. I don't actually
> have any of those tools myself, although I guess I could go out and
> buy them. Does anyone on this list have those tools and can let me
> know if they show any problems?

The question before that would be whether anyone has a comprehensive list=20
of those tools, cause I think there are quite many. Well at least those=20
from bigger vendors should be tested I think. Paragon, Symantec, ...

And has it been tested with Linux tools such as fsck.msdos, fsck.vfat,=20
parted and partimage? I think it probably has not much effect on parted and=
=20
partimage, but what about the fscks?

>  > I think the patch actively *corrupts* perfectly fine shortname FAT
>  > filesystems and at least for certain use scenarios even those with
>  > long name support.
>
> The patch only changes the values stored for new files created by
> Linux, so I think it is going a bit far to say it "actively corrupts"
> filesystems.

I do not. A filesystem is intact when all of its metadata is intact. This=20
is at least what I believe and what various fsck tools seem to implement.=20
Thus even when the patch only changes the values stored for new - or=20
rewritten? - files it actively corrupts the meta consistency of the whole=20
filesystem. To me it is like inserting a defective inode into a consistent=
=20
Linux filesystem.

> I am looking into the Win9X issued raised by Jan. As I mentioned in my
> mail to him, it seems to work better with some different values in the
> 11 bytes. I'll keep looking at that, although I don't think Win9X
> support is a high priority for anyone any more. After installing Win98
> in a virtual machine I connected it to the windows update service to
> see if there had been updates to the old install images I had, and I
> found it couldn't even connect to windows update, it just throws a
> page full of html errors:
>
>   http://samba.org/tridge/Win98-update.png

I don't believe that Microsoft is still providing updates for Win98. But I=
=20
think Windows 2000 might still be in use - I for example have a Win 2000=20
installation on my ThinkPad T23, although I didn't boot it for about a=20
year or so. Has it been tested against Windows 2000? I digged for the mail=
=20
where you said something about against which Windows versions you tested,=20
but I didn't find it anymore.

I think information regarding test status of the patch should be collected=
=20
in the FAQ.

> When the vendor of an operating system doesn't even bother to display
> a clean "sorry, you don't get updates any more" page for their OS then
> I think it is safe to say that the operating system is dead and
> buried.

It is safe to say much. But still users might not behave according to your=
=20
saying or might even not be able to. A potential customer asked us to=20
migrate a Windows 98 installation into a virtual machine, cause the=20
software that is running there would not run with any newer version of=20
Windows. Sometimes people are locked / forced to a specific Windows (or=20
Linux) version at least is they do not want to pay lots of $$$ to replace=20
their proprietary special hardware + software combination by something=20
which is supported on a newer version of an operating system. And for a=20
coincidence I think digital photos have been involved in that use case.

I skip most of the political stuff. I was not my main point to make. It=20
has been discussed before. We obviously have different oppinions and thats=
=20
just how it is. No need to cycle around our different view points.

>  > If the Linux kernel would be changed to avoid any software patent
>  > issues I am not sure whether it would even be able to boot
>  > anymore.
>
> That argument can be used with pretty much any software (both
> proprietary and free), not just the Linux kernel.

I think this doesn't render my argument invalid. To me it merely says that=
=20
also other free software projects shall be careful with politically or=20
juristically motivated patches. Drastically spoken if everyone decides to=20
jump out of the window, why should I follow?

> In the case of the GIF patents the correct answer was a concerted
> effort to switch to a new format. That was a fantastic campaign and
> largely successful.
>
> We don't, as yet, have any equivalent campaign to get behind for these
> VFAT patents. The calls for changing to a different filesystem format
> are great, but they fall down in an even worse way than what I have
> proposed on exactly the same issues. This hypothetical new format
> won't work with cheap MP3 players, won't work with Win9X, and almost
> certainly won't work with existing Windows boxes (yes, I know about
> UDF, but if you actually try it you'll see it isn't the panacea some
> have claimed). So in what way is it a solution, even if the new format
> existed?

Its challening, agreed. Especially as for it to be truly multi-plattform=20
Linux developers, Apple, Microsoft and little device makers would have to=20
agree on it. Or it needs to be a free software product that can be=20
installed on any OS really easily. Then you could have a small fat16=20
partition with a *.exe file and a MacOS X dmg to click on in order to=20
install the driver for the real new inter-exchange filesystem. But what=20
about device makers. And what about existing devices? I think it can only=20
be a slow migration.

> If you can propose a truly workable alternative then I would be
> delighted to never have to think about FAT filesystems again in my
> life.

I did not meant any personal offence. So no need to justify yourself for=20
what you do. You are just trying to find a workaround for the issue. And I=
=20
am pretty sure you believe in what you do to be a viable workaround. I am=20
not intending to shoot the messenger of a possible workaround. I am just=20
not a fan of a patch like yours being in vanilla and thats about it ;).

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7


--nextPart1676513.uhJ5EfJChu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpUhYgACgkQmRvqrKWZhMf6cACfdpcT4TYvWk4zo5vlGVIrTRbt
tLYAnjiFLRm3CFYYFQiPP2GilE8+fmim
=b5DV
-----END PGP SIGNATURE-----

--nextPart1676513.uhJ5EfJChu--
