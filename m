Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZBQPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZBQPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBQPZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:25:26 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53592 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZBQPZZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:25:25 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-02-14-00-49 uploaded - synaptics breakage
In-Reply-To: Your message of "Sat, 14 Feb 2009 00:51:41 PST."
             <200902140851.n1E8pfIN030501@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200902140851.n1E8pfIN030501@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1234880923_6651P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Feb 2009 09:28:43 -0500
Message-ID: <7080.1234880923@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1234880923_6651P
Content-Type: text/plain; charset=us-ascii

On Sat, 14 Feb 2009 00:51:41 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-02-14-00-49 has been uploaded to

The two patches:

psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

make my laptop (Dell Latitude D820) throw this message at every boot:

WARNING: synaptics was reset on resume. Try using the synaptics_resume_reset module parameter if you have trouble on resume

I have no idea what it does at resume, I don't *use* suspend/resume.

Is this supposed to be resume-only, or at every boot?

--==_Exmh_1234880923_6651P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJmsmbcC3lWbTT17ARAoSuAKD66itSvMvkca3PNyH6YvLFFh1cCACfXqGu
ZPq8LsNdVhIAGRBz1F9dgdg=
=eZTs
-----END PGP SIGNATURE-----

--==_Exmh_1234880923_6651P--
