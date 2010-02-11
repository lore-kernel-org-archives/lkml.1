Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0BKSkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:40:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37048 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab0BKSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:40:23 -0500
Message-ID: <4B744E13.8040004@kernel.org>
Date: Thu, 11 Feb 2010 10:36:03 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org
CC: lasse.collin@tukaani.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: XZ Migration discussion
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Feb 2010 10:36:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hey Everyone,

So as the subject states this is more a centralized discussion on
migration plans to using and providing xz for content on kernel.org.
Currently we provide gz and bz2, with gz acting as the original content
and kernel.org itself generating the resulting bz2 files.  There are a
couple of possible proposals and wanted to toss them out there, and get
feedback from everyone: the kernel community, the mirrors of kernel.org
and the direct users of kernel.org.

========================================================================

Option 1)

Leave gz as the master, and migrate bz2 to xz.  This will happen in
stages obviously. with bz2 ultimately being phased out.

	Migration option 1)

		All new content would be provided in .bz2 and .xz with
		an ultimate date set that the .bz2 files would stop
		being generated with new content.  This would leave all
		existing content alone and it would not be a migration
		of the current .bz2 files to xz

	Migration option 2)

		At some point there would be a mass conversion of all
		existing content to include .bz2 and .xz.  These would
		be run in parallel for a time period until it was
		determined that .bz2 was no longer needed and it would
		be removed from the servers leaving .gz and .xz

Option 2)

Convert the master data from gz to bz2 and use xz as the new file
format.  This has the downside of causing more tool churn as it means
the kernel developers will have to eventually convert from gz to bz2,
which means for a time there will be nag e-mails if you upload gz
instead of bz2 and such.  It would also mean that we (kernel.org) would
need to be able to support .gz and .bz2 as master data for a time.

Migration options are identical to Option 1 more or less, with either
just new content getting converted, or all content getting converted.

========================================================================

I'm personally leaning towards option 1, though personally don't really
have a preference on the migration options, as both obviously offer
different advantages, and again this e-mail is more to spur on the
discussion and come to some general consensus across all of the groups
concerned before moving forward with a more specific plan.

So I'm inviting discussion, questions and comments on this so we know
which way to ultimately go.

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkt0ThMACgkQ/E3kyWU9dicQIwCggCACEHuEViVvnIiv42McbCQh
SmUAn049beEHPucEc7X+0hBQkW6A5oTt
=ugaX
-----END PGP SIGNATURE-----
