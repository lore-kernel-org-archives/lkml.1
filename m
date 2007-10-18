Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXJRP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXJRP2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXJRP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:27:46 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:53269 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370AbXJRP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:27:44 -0400
Message-ID: <47177B65.7040408@kernel.org>
Date: Thu, 18 Oct 2007 08:27:33 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaigai@kaigai.gr.jp, casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil> <20071016214159.GB13294@sergelap.austin.ibm.com> <20071017180002.33fe4986.akpm@linux-foundation.org> <20071018025920.GA5067@vino.hallyn.com> <20071018052111.GQ3906@sequoia.sous-sol.org> <20071018125026.GA10387@vino.hallyn.com>
In-Reply-To: <20071018125026.GA10387@vino.hallyn.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> Quoting Chris Wright (chrisw@sous-sol.org):
>> * Serge E. Hallyn (serge@hallyn.com) wrote:
>>> I guess now that I've written this out, it seems pretty clear
>>> that capget64() and capget64() are the way to go.  Any objections?
>> How is capget64() different from capget() that supports 2 different
>> header->versions (I thought that was the whole point of the versioned,
>> rather opaque interface)?  I don't object to a new syscall, but I don't
>> see why it's required to avoid breaking libcap.
> 
> Hmm, I guess it *works*, it's just harder to explain the "inconsistent"
> behavior.  Now instead of saying "capget() will fail under certain
> conditions while capget64() will always succeed", capget() will actually
> fail under certain conditions only if you send in a certain header.
> 
> Again, once I've written it out, I guess it isn't *so* bad.

[I'm just wading back into a mass of neglected email. Long story.]

Chris is right, this is precisely why the interface is versioned, and
there is at least one version of libcap that was written to support this
versioning scheme

cvs -z3
- -d:pserver:anonymous@cvs.linux-privs.sourceforge.net:/cvsroot/linux-privs
co -r libcap-pre2 libcap

I'll try and unwind all the threads of email I've been neglecting and
have something useful to say over the next few days.

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHF3tj+bHCR3gb8jsRAhF1AJ9gfmUnO+O0YyzPLaqGVv++pZjvdgCgzz3J
+yF6CRASj8QVYArDydc84k8=
=K/Wb
-----END PGP SIGNATURE-----
