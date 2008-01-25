Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYAYRR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYAYRR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYAYRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:17:04 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58240 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbYAYRRC (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:17:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Kosina <jikos@jikos.cz>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: Your message of "Fri, 25 Jan 2008 16:26:45 +0100."
             <Pine.LNX.4.64.0801251624480.5521@twin.jikos.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
            <Pine.LNX.4.64.0801251624480.5521@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201281417_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 12:16:57 -0500
Message-ID: <10536.1201281417@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201281417_2846P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jan 2008 16:26:45 +0100, Jiri Kosina said:
> On Fri, 25 Jan 2008, Bodo Eggert wrote:
> 
> > Enabling this option changes a hard panic on boot errors to a
> > soft panic, which does not stop the system completely.
> > You can still scroll the screen and read the messages.
> 
> Hi Bodo,
> 
> if you are willing to put some effort into the ability to scroll the 
> console after panic, it might be worthwile to look making the keyboard 
> driver work even after panic (i.e. poll the keyboard, rather than relying 
> on interrupts).
> 
> That has significantly smaller potential of breaking because the system is 
> expected to be dead after panic (watchdogs, broken data structures in 
> memory, etc).

I think Bodo is trying to address one specific (but quite common) corner
case, where we currently panic() only because there's nothing else that
makes sense - if we can't find the root fs, we're hosed.  But (barring *other*
oops/etc issues), we're still up and running, our data structures are intact,
and there's no real reason we can't use such kernel services as we want (such
as the screen scroller) to help the sysadmin figure out what he misconfigured.

If we were trying to do a *general case* handler for post-panic, yes, we'd
want to do the polled keyboard and all that....

--==_Exmh_1201281417_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmhmJcC3lWbTT17ARAkC0AKDa7OsrAhl93XZMEAlVRG5S3n5k1QCgpguh
cPYwmBRyvzooqrxr6VOKGWE=
=svX7
-----END PGP SIGNATURE-----

--==_Exmh_1201281417_2846P--
