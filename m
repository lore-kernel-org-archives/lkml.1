Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXIIAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXIIAY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXIIAYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 20:24:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53212 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbXIIAYR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 20:24:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
In-Reply-To: Your message of "Thu, 30 Aug 2007 12:27:10 EDT."
             <46D6EFDE.4020107@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23252.1188396273@turing-police.cc.vt.edu> <3909.1188409058@turing-police.cc.vt.edu> <20070829161545.9fde1a5c.akpm@linux-foundation.org>
            <46D6EFDE.4020107@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189297449_2832P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 08 Sep 2007 20:24:09 -0400
Message-ID: <7671.1189297449@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189297449_2832P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Aug 2007 12:27:10 EDT, Chuck Ebbert said:
> On 08/29/2007 07:15 PM, Andrew Morton wrote:
> >>> The issue:  vdso and gettimeofday seem to be having a quarrel.
> >> This is also open as a Fedora bug:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=262481
> >>
> > 
> > So it's an interaction between the x86_64 vdso patches in Andi's tree and 
> > newer glibc, and we don't know which one is getting it wrong yet?
> > 
> > If I ever get another -mm out the door (have been without electricity for
> > several days) I'll drop the vdso changes until this is sorted out.
> > -
> 
> Problem is present in stock 2.6.23-rc too. Still don't know whether it is
> the new glibc code or the vdso that's causing it, though.

Updating on this issue:   Both myself and another person have reported on
the RedHat bugzilla that it's a clocksource issue - if you are using the
hpet clocksource, the time warps, but booting with clocksource=acpi_pm works.

This ring any bells?


--==_Exmh_1189297449_2832P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG4z0pcC3lWbTT17ARAgrOAJ95JYOclMU8yob0HwlZeytkjxCoTACdHx9e
ZxS2jBayp+33u+l33CPOhSs=
=CJpd
-----END PGP SIGNATURE-----

--==_Exmh_1189297449_2832P--
