Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYI2I02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYI2I02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYI2I0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:26:20 -0400
Received: from mail.anarazel.de ([217.115.131.40]:53462 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYI2I0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:26:19 -0400
From: Andres Freund <andres@anarazel.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Date: Mon, 29 Sep 2008 10:26:15 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-rc7; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Tomas Winkler <tomasw@gmail.com>
References: <200809251511.20132.andres@anarazel.de> <1222441833.3798.10.camel@johannes.berg>
In-Reply-To: <1222441833.3798.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1671546.fHiBhP5sPO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809291026.16394.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1671546.fHiBhP5sPO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Friday 26 September 2008, you wrote in "Re: bad DMAR interaction with=20
iwlagn and SATA":
> > [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr
> > fa946000 [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not s=
et
> > [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting. [
> > 4186.646000] psmouse.c: TouchPad at isa0060/serio1/input0 lost
> > synchronization, throwing 1 bytes away. [ 4186.683034] Registered led
> > device: iwl-phy0:radio
> > [ 4186.683478] Registered led device: iwl-phy0:assoc
> > [ 4186.683793] Registered led device: iwl-phy0:RX
> > [ 4186.684094] Registered led device: iwl-phy0:TX
> > [ 4186.689749] wlan0: authenticate with AP 00:1d:7e:42:fe:42
> > [ 4186.691691] wlan0: authenticated
> > [ 4186.691705] wlan0: associate with AP 00:1d:7e:42:fe:42
> > [ 4186.696380] wlan0: RX ReassocResp from 00:1d:7e:42:fe:42 (capab=3D0x=
411
> > status=3D0 aid=3D2) [ 4186.696392] wlan0: associated

> > Most of the time when this happened, the machine wasnt reacting for 1-3
> > seconds and had audio buffer underruns, but I also had a hard lockup
> > which I couldnt diagnose so far.
> I suspect the hard lockup was due to a BUG_ON in the iwlagn driver, if
> you can reproduce this either try applying the patch here [1] or going
> to a VC to see if it crashes there. It's a BUG_ON in iwl-tx.c.
Could not reproduce so far - it is rather hard working on the machine with=
=20
DMAR enabled because I get 1-5s lockups all the time like described above...

Andres


--nextPart1671546.fHiBhP5sPO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjgkSgACgkQporPraT14ii4cACfQBehnutTOVuJiZ2XqKgldTrH
fwMAnitB5D7h0bnzHmoqlCAFY2iU3ixp
=Xg1+
-----END PGP SIGNATURE-----

--nextPart1671546.fHiBhP5sPO--
