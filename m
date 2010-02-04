Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab0BEAGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:06:11 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:33759 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab0BEAGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:06:10 -0500
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 19:06:09 EST
Subject: [ANNOUNCE] upstart 0.6.5 released
From: Scott James Remnant <scott@netsplit.com>
To: upstart-devel@list.ubuntu.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UxZR2OmiGOcUqX+EP1iY"
Date: Thu, 04 Feb 2010 15:37:47 -0800
Message-ID: <1265326667.25725.3.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UxZR2OmiGOcUqX+EP1iY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Haven't quite followed the original release plan here, but I thought it
was important to get a new Upstart release out sooner rather than later
for the stable crowd. The main change here is that the libnih library
has been separated out into its own source tree (you can get it from
Launchpad), along with some merging of patches that had lived in the
Ubuntu branch of Upstart for a while back into the trunk.


0.6.5  2010-02-04  "Our last, best hope for victory"

	* Since libnih has been separated out into its own project, Upstart
	  no longer includes its source and now uses the installed version by
	  default.

	* The external nih-dbus-tool means that cross-compilation is trivial,
	  the path to it may be overriden with NIH_DBUS_TOOL=3D... as an
	  argument to configure.  (Bug: #426740)

	* Developers may still build against a local libnih source tree by
	  passing --with-local-libnih=3D/path/to/libnih to configure.

	* There is a new initctl "reload" command, with matching
	  /sbin/reload symlink.  This sends the SIGHUP signal to the running
	  main process of the named job instance.

	* Event operator matches in jobs now support "!=3D" in addition to the
	  usual "=3D", e.g.:

		start on net-device-added INTERFACE!=3Deth*

	  (Bug: #513035)

	* Moved D-Bus system bus reconnection trigger from SIGHUP to SIGUSR1,
	  since SIGHUP is already used for a forced configuration reload and
	  causes Upstart to "forget" state.

	* Fixed bug where the default runlevel would be lost when an
	  /etc/inittab file exists without an initdefault line.  (Bug: #405847)

	* Fixed "Unhandled error" message from shutdown.  (Bug: #426332)

	* Fixed "Unhandled error" assertion crash from Upstart child
	  processes when failing to spawn a job.  (Bug: #451917)

	* No longer holds /dev/console open, so the SAK SysRq key will not
	  kill Upstart.  (Bug: #486005)

	* Restored sync() call before reboot().

	* Added missing OPTIONS section to init(8) manpage.  (Bug: #449883)


The tarball can be found here:

        http://upstart.ubuntu.com/download/

For more information on upstart:

        http://upstart.ubuntu.com/


Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-UxZR2OmiGOcUqX+EP1iY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAktrWkoACgkQIexP3IStZ2xY/QCcC4QOide5IR7c6OtxMX6xyN0B
AiIAnilOL1b2YI09Qi3ceNwNr8KZuzr0
=fSCt
-----END PGP SIGNATURE-----

--=-UxZR2OmiGOcUqX+EP1iY--

