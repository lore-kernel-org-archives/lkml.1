Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYIRUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYIRUcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbYIRUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:32:15 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:4123 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbYIRUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:32:15 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 16:32:15 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=Date:From:To:Cc:Subject:Message-ID:References:
   MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
   User-Agent;
  b=e+ntKjgLS/dCc4wAPcMb7QGheIp0qYfPIXIrtYcnbi+G65kg4mnhG6lD
   smouyRX4FzkvpFXBmqBG3GFX4k3ttr2W6YC1kBeJg608LiGHM9LDxHd8N
   VmP+25og8sd7TBL;
Date: Thu, 18 Sep 2008 15:22:57 -0500
From: Michael E Brown <Michael_E_Brown@dell.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add Dell laptop driver
Message-ID: <20080918202257.GJ14180@duo.us.dell.com>
References: <20080816202452.GA3331@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opg8F0UgoHELSI+9"
Content-Disposition: inline
In-Reply-To: <20080816202452.GA3331@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opg8F0UgoHELSI+9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2008 at 09:24:52PM +0100, Matthew Garrett wrote:
> This driver adds backlight and rfkill support for Dell laptops. It uses=
=20
> the DCDBAS driver to trigger the system management calls required for=20
> this, and parses the DMI tables itself in order to find the appropriate=
=20
> tokens. In future it should be possible to add LED control, but I don't=
=20
> have any appropriate machines right now for testing.

Sorry, I'm *way* late on giving feedback for this (thanks for the cc). Aside
=66rom the other code review comments, I agree with the approach and am glad
somebody finally took the time to write this correctly.

The i8k driver incorrectly hardcodes magic port io data/address. Can somebo=
dy
fix i8k to use the code in this module to do it correctly?
--
Michael Brown
libsmbios maintainer

--opg8F0UgoHELSI+9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFI0rihcnW8GdAFD+URAk2wAKCmjhNXTFhNjptVRByM6n6Kcswq3ACeJHS2
vL0tYfkO9hK7dFDXsiujobE=
=EWm+
-----END PGP SIGNATURE-----

--opg8F0UgoHELSI+9--
