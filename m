Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYK3SrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYK3SrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 13:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYK3Sq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 13:46:59 -0500
Received: from mout.perfora.net ([74.208.4.194]:52198 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYK3Sq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 13:46:59 -0500
Date: Sun, 30 Nov 2008 12:41:35 -0600
From: Robby Workman <rw@rlworkman.net>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-gentoo-r4 suspend/hibernate issues with ThinkPad T41
Message-ID: <20081130124135.0d845462@liberty.rlwhome.lan>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.12; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nsLbzRCrDATSf9HqfPQTVjt";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Provags-ID: V01U2FsdGVkX18cQsloMzgS8k2nqaWgSV+V+bB3OBd0RxEIX9k
 VohrC073Q0hT8ympxTPGoO7PYt9pZYzKliRg2Ix3Od1y9swGlX
 RWaBz9ovHuz1F+7Li0Ngg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nsLbzRCrDATSf9HqfPQTVjt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Toralf F=C3=B6rster wrote:

> testing that kernel (based on 2.6.27.7) w/ a  .config from a
> working 2.6.26-gentoo-r3 kernel I run into issues after the system
> should be wake up from hibernation.
> If I startx (from init level 2), suspend the system (FN + F4), wake
> it up and then try to hibernate (FN + F12) I get in my syslog the=20
> following entries:
>
> Nov 30 14:27:02 n22 acpid: received event "ibm/hotkey HKEY 00000080
> 0000100" Nov 30 14:27:02 n22 acpid: notifying client 2796[0:0]
> Nov 30 14:27:02 n22 acpid: executing action "/etc/acpi/default.sh
> ibm/hotkey


I don't have any insight on the problem, but I can offer anecdotal
evidence on my T41.  Using the default kernel methods for suspend and
hibernate ( echo -n (mem|disk) > /sys/power/state ), it sleeps and
wakes up as expected.  More recently, I'm using the pm-utils suite for
this, and it too works as expected.

This is on Slackware -current (development version) with 2.6.27.7
kernel. I now employ xfce4-power-manager for suspend functionality, but
prior to that, I was using this: http://rlworkman.net/conf/acpi/ if
you'd like to peruse it.

-RW

--Sig_/nsLbzRCrDATSf9HqfPQTVjt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkky3l8ACgkQvGy9tf6lsvslEACeNTdoTWgsH0y+wbbzPMNC8sHu
lykAnigD5qGGUkh2Tc+OcSbDXv/cUr5s
=BnCm
-----END PGP SIGNATURE-----

--Sig_/nsLbzRCrDATSf9HqfPQTVjt--
