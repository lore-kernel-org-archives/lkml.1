Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZLYQbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZLYQbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 11:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZLYQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 11:31:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44515 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbZLYQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 11:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=jRnRA4gER4I2FIRUZxpByHY90LQ9g+dXr79k7gElupXy0wjR58dn8zWsYQFaaJFOPO
         mpvL0Z8ZidKxKsEpJtNJidzZA7h9gio3W9Xsdk0Paua+aAxQDTIYS/Ff3N4lkof+Deor
         cobekImJbSEmZGFpt3rql2u2ez/U9BFaCOjVY=
Date: Fri, 25 Dec 2009 18:32:05 +0200
From: Sergei Trofimovich <slyich@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU 
 (according to top)
Message-ID: <20091225183205.744be270@mosly>
In-Reply-To: <s5hy6kr6nur.wl%tiwai@suse.de>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	<20091225122107.357d7102@mosly>
	<s5h637vmhcu.wl%tiwai@suse.de>
	<20091225162528.5dbbbea0@mosly>
	<8db1092f0912250731u46637a55lccb77e6cdb376a57@mail.gmail.com>
	<s5hy6kr6nur.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x9KH7zMbf2C3tx62d42m=Rc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x9KH7zMbf2C3tx62d42m=Rc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Dec 2009 17:05:16 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> It's a bit surprising that this resulted in the high CPU usage
> instead of erroneous behavior.  This should be rather a bug of
> codec chip...
>=20
> Anyway, Segei, which codec is on your machine?  Is it Analog Device
> one?=20
> IIRC, the one's on Maciej and Eric machines are AD codecs.
> If so, we can just revert the changes to patch_analog.c in that
> commit.

How can I check? alsamixer shows=20
    Chip: Analog Devices AD1981
Not sure it's valid though.

It's a HP Compaq 2510p laptop.

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Contr=
oller (rev 03)
        Subsystem: Hewlett-Packard Company Device 30c9
(posted whole lspci output slightly earlier if needed)

--=20

  Sergei

--Sig_/x9KH7zMbf2C3tx62d42m=Rc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAks06QoACgkQcaHudmEf86qafQCePFw+hwFRTrO07xFwyT+QDXnj
cv0Anif1zb5nHZht1vTsnYqY/RgqwVaV
=4CbN
-----END PGP SIGNATURE-----

--Sig_/x9KH7zMbf2C3tx62d42m=Rc--
