Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYEPPwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYEPPwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYEPPwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:52:45 -0400
Received: from server4.pinguin-hosting.de ([88.198.11.108]:49075 "EHLO
	server4.pinguin-hosting.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYEPPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:52:44 -0400
Date: Fri, 16 May 2008 17:22:07 +0200
From: Michelle Konzack <linux4michelle@tamay-dogan.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Hardware designt to prevent Damages... [WAS: [patch 23/37] i2c-piix4: Blacklist two mainboards]
Message-ID: <20080516152207.GA2201@freenet.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201225.GX31167@suse.de> <20080514195253.GB5673@freenet.de> <20080515204955.7f877be8@hyperion.delvare>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20080515204955.7f877be8@hyperion.delvare>
X-Message-Flag: Improper configuration of Outlook is a breeding ground for viruses. Please take care your Client is configured correctly. Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser Mail oder dieser Mailadresse ist nur mit der Einwilligung des Autors gestattet.
Organisation: Tamay Dogan Network
X-Operating-System: Linux tp570.private 2.4.27-2-686
X-Uptime: 17:16:48 up 54 min,  9 users,  load average: 2.75, 2.68, 2.01
X-Homepage: http://www.debian.tamay-dogan.net/
User-Agent: Mutt/1.5.9i
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri May 16 17:52:44 2008
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 482dadcc225785680314083
X-DSPAM-Factors: 27,
	misunderstanding+the, 0.40000,
	helpful, 0.40000,
	but, 0.40000,
	IRC, 0.40000,
	right, 0.40000,
	right, 0.40000,
	just, 0.40000,
	just, 0.40000,
	of+it?, 0.40000,
	X-Disclaimer-DE*mit, 0.40000,
	can+result, 0.40000,
	made, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	END+OF, 0.40000,
	Url*li, 0.40000,
	a+full, 0.40000,
	Date*May, 0.40000,
	or, 0.40000,
	or, 0.40000,
	list+of, 0.40000,
	list+of, 0.40000,
	an, 0.40000,
	an, 0.40000,
	nice+Day, 0.40000,
	MSN+LinuxMichi, 0.40000,
	a+PC, 0.40000,
	Consultant+Am, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jean,

Thank you for explanation.

OK, if I understand I2C right, there are more or less reserved addresses
for each type of chip if I understand it  right,  but  I  have  only  an
incomplete list of it. (gotten from the  NXP  website  where  the  Tech-
Support is very helpful.  Same for Dallas/Maxim)

Do you know, where I can get a full list of it?

Thanks, Greetings and nice Day
    Michelle Konzack
    Tamay Dogan Network
    Debian GNU/Linux Consultant


Am 2008-05-15 20:49:55, schrieb Jean Delvare:
> In this particular case, the CPU was apparently damaged as the result
> of accidental memory over-voltage. It is worth noting though that said
> CPU had gone through intensive overclocking session beforehand, and
> this might explain the death. Other CPUs are known to have gone through
> the same experience and are still working.
>=20
> So, to clear up any misunderstanding: the CPU damage did not occur
> because we used some odd CPU instruction sequence or anything like
> that. The damage came to the CPU from other hardware on the board.
>=20
> To be a bit more technical, the design mistake (I think) that was made
> by the designers of the motherboard in question, was to use an
> I2C/SMBus chip on a PC motherboard, which uses SMBus receive byte and
> SMBus send byte for control, and which lives at an I2C address which is
> very common amongst hardware monitoring chip. The 4th factor being, of
> course, that improperly programming the chip in question can result in
> hardware damage. If only 3 of these 4 factors had been present, most
> probably there would have been no issue in practice. But with all 4
> factors, bad things just had to happen. And it's not just Linux, users
> had similar problems running hardware monitoring tools under Windows
> too.
------------------------ END OF REPLIED MESSAGE ------------------------



--=20
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
Michelle Konzack   Apt. 917                  ICQ #328449886
+49/177/9351947    50, rue de Soultz         MSN LinuxMichi
+33/6/61925193     67100 Strasbourg/France   IRC #Debian (irc.icq.com)

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.pgp"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFILaafC0FPBMSS+BIRAv1/AJ4oJWAj5++JeJl6yM0d7U8Vrbu5TQCeO20Y
ra03SkIxnTKHSGnR5TADjCg=
=yK2L
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--


