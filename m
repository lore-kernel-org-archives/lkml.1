Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZERRg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZERRg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZERRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZERRgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:36:50 -0400
Message-ID: <4A119C75.3030400@suse.com>
Date: Mon, 18 May 2009 13:35:49 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 4/4] reiserfs: allow exposing privroot w/ xattrs enabled
References: <20090517050200.786752018@suse.com> <20090517050332.566856122@suse.com> <alpine.LFD.2.01.0905171009200.3301@localhost.localdomain> <alpine.LFD.2.01.0905181026560.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905181026560.3301@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 
> On Sun, 17 May 2009, Linus Torvalds wrote:
>>
>> On Sun, 17 May 2009, Jeff Mahoney wrote:
>>> --- a/fs/reiserfs/dir.c
>>> +++ b/fs/reiserfs/dir.c
>> Hmm. This had no explanation or sign-off. Please? At least the sign-off, 
>> but I think I'd like a log message too, since this adds a new mount option 
>> etc, so it's not like this is some trivial one-liner that doesn't need it.
> 
> Jeff, ping?
> 
> I merged the other three patches, but this one is still pending. I'm not 
> entirely sure it's even appropriate for 2.6.30 (it doesn't _look_ like 
> it's fixing any regressions), but even if you don't actually want me to 
> merge it, can you say so? And if you do want me to merge it, I want the 
> sign-off and fuller log message..

Sorry, I was in and out all weekend. Don't bother merging it for this
window. I wanted to make it easy to clean up xattrs that would have been
left around if a file system that contained xattrs was migrated to a
kernel without support compiled in, but I'll add that to fsck instead.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoRnHUACgkQLPWxlyuTD7IXNwCfXj5l+0m0RTPQqzdD2VUqJep9
aEkAoIVdu7anayn2pP5v1dJAv18s6/4i
=HKsW
-----END PGP SIGNATURE-----
