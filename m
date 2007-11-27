Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXK0Wcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXK0Wcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759574AbXK0WcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:32:23 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47872 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbXK0WcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:32:21 -0500
X-Sasl-enc: +HTXqI0nWpB/yaJIUgIHvPDrx85TAQGjwA/tRobHoolO 1196202740
Message-ID: <474C9B31.8000408@imap.cc>
Date: Tue, 27 Nov 2007 23:33:21 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: git guidance
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6DCC4CA401EC931903014573"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6DCC4CA401EC931903014573
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

So I've watched Linus' Google Tech Talk about git and let him convince
me that I've been stupid to use CVS, that Subversion is even worse,
and the only sensible approach is to use git. Went ahead and tried to
convert my driver development to git.

It didn't work too well. The first result was one of maximal
embarrassment: I produced a patch that didn't even compile when
applied to the official tree. This shouldn't happen with git, right?
Well, it did. So now I'm back to keeping a virgin kernel source tree
alongside my development area in order to produce diffs. That can't
be right?

Obviously I'm still being stupid. (Probably an aftereffect of using
CVS for too long.) But where do I turn for guidance? I read all the
docs and READMEs I could find, but I still don't understand why GIT
doesn't produce the results I need, and what to do differently.

Does somebody have a step by step tutorial for doing the standard
"edit - test - modify - retest - submit - edit - resubmit" sequence
with GIT? Is there a GIT newsgroup or mailinglist? Or should I just
post my silly questions to LKML?

TIA

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6DCC4CA401EC931903014573
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHTJs5MdB4Whm86/kRAsbLAJ9WWnutzYPwsOOPnbkMo9IQv3bD8wCfaeyV
RPSyo5Dl5hKiarKVyK6fJj8=
=r/lI
-----END PGP SIGNATURE-----

--------------enig6DCC4CA401EC931903014573--
