Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbXJUErv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbXJUErv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXJUErp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:47:45 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57543 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXJUEro (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:47:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
In-Reply-To: Your message of "Sat, 20 Oct 2007 21:17:00 +0200."
             <20071020191700.GB8774@uranus.ravnborg.org>
From: Valdis.Kletnieks@vt.edu
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se>
            <20071020191700.GB8774@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192942058_3691P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Oct 2007 00:47:38 -0400
Message-ID: <26703.1192942058@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192942058_3691P
Content-Type: text/plain; charset=us-ascii

On Sat, 20 Oct 2007 21:17:00 +0200, Sam Ravnborg said:
> On Sat, Oct 20, 2007 at 02:42:38PM +0200, Henrik Carlqvist wrote:
> > I think there is a need for Kconfig to specify that a functionality could
> > be built as a module or not built at all.
> 
> I assume
> 	depends on MODULES
> 
> should do the trick.

Umm... I think that will work backwards, and give you CONFIG_FOO=y
if.f the kernel *supports* modules. What he needs is to be able to say
CONFIG_FOO=n or CONFIG_FOO=m, but *ban* CONFIG_FOO=y.

(At least, in my kernel, I have MODULES=y, and several other things
from init/Kconfig have 'depends on MODULES' and also end up 'y':

% zgrep MODULE /proc/config.gz 
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_VERIFY_ELF=y


--==_Exmh_1192942058_3691P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHGtnpcC3lWbTT17ARAvmQAJ9fBPNVw5kRWI+fiw1KUalnhOHsggCguswj
JZ37b9JXMWFaDwiZW3dZ2co=
=Xyb4
-----END PGP SIGNATURE-----

--==_Exmh_1192942058_3691P--
