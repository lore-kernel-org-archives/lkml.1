Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXJaBDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXJaBDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJaBDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:03:47 -0400
Received: from ns.suse.de ([195.135.220.2]:39092 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbXJaBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:03:46 -0400
Message-ID: <4727D539.3080103@suse.com>
Date: Tue, 30 Oct 2007 21:07:05 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmap: restore -ENODEV on missing f_op->mmap
References: <4727AE44.10902@suse.com>	<alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org> <20071030161352.80656280.rdunlap@xenotime.net>
In-Reply-To: <20071030161352.80656280.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Randy Dunlap wrote:
> On Tue, 30 Oct 2007 15:45:56 -0700 (PDT) Linus Torvalds wrote:
> 
>>
>> On Tue, 30 Oct 2007, Jeff Mahoney wrote:
>>>  Personally, I think this is probably a case of LTP codifying existing
>>>  behavior rather than testing the for the specification. If that's the case
>>>  and nobody really cares about the change in behavior, I'm fine letting this
>>>  drop.
>> Hmm.. I think it's kind of stupid adding that special case early on, just 
>> to get one particular error case return when there are multiple possible 
>> ones. 
>>
>> I don't care deeply, but this does smell like a test issue rather than a 
>> code issue.
>>
>> Looking at that path, there are *other* things that might be worth 
>> cleaning up, but this wasn't one of them..
> 
> 
> Jeff, will you (at least) notify the LTP project of this issue and
> need for a patch?

Sure. I'll send that out tonight or tomorrow morning.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHJ9U5LPWxlyuTD7IRArcqAJ4hGnSf0Z67sLJJ6OU4t72VFodPnQCbBwHw
Usml2lnHxuwyXpXvjwlTbaI=
=ss6E
-----END PGP SIGNATURE-----
