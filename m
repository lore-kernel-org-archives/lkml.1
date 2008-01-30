Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbYA3UVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbYA3UVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933627AbYA3UUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:20:09 -0500
Received: from hydra.gt.owl.de ([195.71.99.218]:60319 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbYA3UUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:20:04 -0500
Date: Wed, 30 Jan 2008 21:17:11 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.24] bcm203x bluetooth dongle does not work
Message-ID: <20080130201711.GA6752@paradigm.rfc822.org>
References: <20080130164920.GA15071@paradigm.rfc822.org> <1201714432.6218.101.camel@violet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1201714432.6218.101.camel@violet>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200801302112@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

On Wed, Jan 30, 2008 at 06:33:52PM +0100, Marcel Holtmann wrote:
> we moved away from using a timer and using a workqueue now. It wrote the
> patch to use a workqueue and tested that it works. Starting with 2.6.19
> we the usage of a workqueue is default. Can you verify that non of the
> kernels 2.6.19-2.6.23 are working. We might have missed a change inside
> the USB subsystem within the 2.6.24 timeframe.

I went through the kernels i still have on this box (FSC LifeBook E8110)=20
and here are the results. Except the debian 2.6.18-5-686 no newer kernel=20
works. The onboard bluetooth works like a charm always whereas the
bcm203x simply does not reconnect after loading firmware from 2.6.19 on.

	2.6.18-5-686 (debian)	works
	2.6.19			breaks
	2.6.21-rc5		breaks
	2.6.22-rc5		breaks
	2.6.22-2-686 (debian)	breaks
	2.6.23-1-686 (debian)	breaks
	2.6.24			breaks

It basically looks always like this:

	<insert>
		usb 1-1: new full speed USB device using uhci_hcd and address 2
		usb 1-1: configuration #1 chosen from 1 choice
		Bluetooth: Broadcom Blutonium firmware driver ver 1.1
		usbcore: registered new interface driver bcm203x
	<wait for 30 seconds - then pull>
		bcm203x_complete: URB failed with status -84
		usb 1-1: USB disconnect, address 2

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoNtHUaz2rXW+gJcRAlXLAJ4o+idAj6fAVbkZCjleG/GuQqcrhACg5T1T
Ql5Wa4i5KQV9H6VGF+Z+21Q=
=33qT
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
