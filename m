Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXKCVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXKCVbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 17:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXKCVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 17:31:12 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:38955 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbXKCVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 17:31:11 -0400
Message-ID: <472CE89C.2020801@kernel.org>
Date: Sat, 03 Nov 2007 14:31:08 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Stephen Smalley <sds@epoch.ncsc.mil>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH] file capabilities: allow sigcont within session (v2)
References: <20071031234945.GA16455@sergelap.austin.ibm.com> <1193918844.12018.6.camel@moss-spartans.epoch.ncsc.mil> <20071101134701.GA21131@sergelap.austin.ibm.com>
In-Reply-To: <20071101134701.GA21131@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@epoch.ncsc.mil):
>> On Wed, 2007-10-31 at 18:49 -0500, Serge E. Hallyn wrote:
[..]
>>> Also don't do file-capabilities signaling checks when uids for
>>> the processes don't match, since the standard check_kill_permission
>>> will have done those checks.
>> Description doesn't match the code.
> 
> Egads.  I knew I should've just kept that part out of it for the first
> patch...
> 
> New patch on top of previous one is appended.

Dang! I stared at the code a long time to see what you were doing...

And concluded that you had coded what you intended; allow processes that
share UIDs to kill one another - independent of capabilities. The fact
that this is the reverse of the words you used to introduce your patch,
I didn't notice.

I totally missed the fact that this was (unwanted) new functionality!!
Mea culpa for the bad review.

I certainly Sign off the revised patch.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHLOicmwytjiwfWMwRAq5HAJ49eajMT4myf1oKfrab2oCw/o9HnwCgkYt2
RyIsmHVWmClsrxCz5s1HRJY=
=hGLO
-----END PGP SIGNATURE-----
