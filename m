Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZJJFXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZJJFXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 01:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZJJFXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 01:23:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59248 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZJJFXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 01:23:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Zhu Yi <yi.zhu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mmotm 2009-10-09-01-07 - iwl3945 fails to do firmware load request
In-Reply-To: Your message of "Sat, 10 Oct 2009 08:42:35 +0800."
             <1255135355.3719.22.camel@debian>
From: Valdis.Kletnieks@vt.edu
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org> <16108.1255133561@turing-police.cc.vt.edu>
            <1255135355.3719.22.camel@debian>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255152144_250202P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Oct 2009 01:22:24 -0400
Message-ID: <252795.1255152144@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.38.202 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4AD01A12.0195,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255152144_250202P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Oct 2009 08:42:35 +0800, Zhu Yi said:

> The firmware loading happens when the user space brings the interface
> up. Can you check NM is running for the bad case?

I'm not using NM, because I've never figured out how to get it to DTRT for
my network config, so I run wpa_supplicant directly.  It's looking like
a bad update to dbus was the actual root cause.

(Did I mention how I loath dbus?  Or at least the fact that if it breaks,
everything from wireless to pulseaudio immediately craps out too.  That and
'hald' are my two favorite "only on this laptop because stuff refuses to
work without them"....)

--==_Exmh_1255152144_250202P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK0BoQcC3lWbTT17ARAhFMAKDJ2ReXz//1q9KFawFaDkdeJSmvbgCeOuwN
V8K6LJF+xKnfAkVgzbkCmhU=
=ULSW
-----END PGP SIGNATURE-----

--==_Exmh_1255152144_250202P--

