Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZAZI27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZAZI27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZAZI2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:28:50 -0500
Received: from server4.pinguin-hosting.de ([88.198.11.108]:49284 "EHLO
	server4.pinguin-hosting.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZAZI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:28:49 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 03:28:49 EST
Date: Mon, 26 Jan 2009 09:19:04 +0100
From: Michelle Konzack <linux4michelle@tamay-dogan.net>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: System hang (and other problems) with cdc_acm
Message-ID: <20090126081904.GI25958@tamay-dogan.net>
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com> <20090125232753.db40c160.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_samba3-14629-1232958048-0001-2"
Content-Disposition: inline
In-Reply-To: <20090125232753.db40c160.akpm@linux-foundation.org>
X-Message-Flag: Improper configuration of Outlook is a breeding ground for viruses. Please take care your Client is configured correctly. Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser Mail oder dieser Mailadresse ist nur mit der Einwilligung des Autors gestattet.
Organization: Tamay Dogan Network
X-Operating-System: Linux tp570 2.4.27-2-686
X-Uptime: 09:09:47 up 2 days,  9:06,  3 users,  load average: 0.16, 0.16, 0.10
X-Homepage: http://devel.debian.tamay-dogan.net/
User-Agent: Mutt/1.5.9i
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jan 26 09:21:40 2009
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 497d7294152162442267086
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_samba3-14629-1232958048-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Am 2009-01-25 23:27:53, schrieb Andrew Morton:
> On Mon, 19 Jan 2009 15:20:13 -0500 "Thomas Tuttle" <linux-kernel@ttuttle.=
net> wrote:
>=20
> > Hi.
> >=20
> > I've got a Lenovo X200 with an Ericsson F3507g Mobile Broadband Module
> > (a 3G cellular data card with built-in GPS), which uses the cdc_acm
> > driver.  I've experienced a couple of problems with it.  First, it
> > tends to hang the system after I've been using it for a while.  This
> > occurs whenever it's sending a lot of data to/from the computer,
> > whether it's a PPP connection or a GPS data stream.  I'm not sure how
> > to debug this; the Caps Lock light isn't flashing, so I'm not sure if
> > it's a panic or just a hang.  Second, if I read one of the TTYs using
> > "cat", I get a ton of blank lines.  To make any sense of the data
> > stream, I have to do cat /dev/ttyACM0 | grep -v "^$".
> >=20
> > If anyone could help me debug this, I'd be greatly appreciative.

Same problem here...

My Router is based on Debian Etch with

Linux router 2.6.18-6-686 #1 SMP Fri Dec 12 16:48:28 UTC 2008 i686 GNU/Linux

and even if I install 2.6.26 it is the same effect.

I am using a cell-phone "Nokia 6120 classic" and my german GSM  Provider
is O2/Telefonica.  I get without any problems  550 kByte/Sec,  but  then
=66rom one second to another 2-5 kByte/Sec.

I have to use

1)  poff o2
2)  wait for termination
3)  disconnect the Nokia
4)  nodprobe -r cdc_acm
5)  reconenct the Nokia
6)  pon o2

and now it work again...  But sometimes, my Nokia (Symbian S60) crashs.

Normaly I can use "cdc_ether" plus "rndis_host" but any kernel modules I
have tried are crashing.  (Bugreport alredy to the Debian BTS)

Since the "cdc_ether" and the "rndis_host" is loaded automaticaly  if  I
connect my Nokia I had to remove the two modules plus usbnet physicaly.

Thanks, Greetings and nice Day/Evening
    Michelle Konzack
    Systemadministrator
    24V Electronic Engineer
    Tamay Dogan Network
    Debian GNU/Linux Consultant


--=20
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
<http://www.tamay-dogan.net/>               <http://www.can4linux.org/>
Michelle Konzack   Apt. 917                  ICQ #328449886
+49/177/9351947    50, rue de Soultz         MSN LinuxMichi
+33/6/61925193     67100 Strasbourg/France   IRC #Debian (irc.icq.com)

--=_samba3-14629-1232958048-0001-2
Content-Type: application/pgp-signature; name="signature.pgp"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJfXH4C0FPBMSS+BIRAjopAKDQB+k649T4F/AbAKrquqG8A5jP1QCgjhlN
NLihunmGu2pNBFIP+xrwLTg=
=Ypo5
-----END PGP SIGNATURE-----

--=_samba3-14629-1232958048-0001-2--


