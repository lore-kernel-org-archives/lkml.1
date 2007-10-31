Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbXJaBEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbXJaBEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXJaBE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:04:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXJaBE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:04:28 -0400
Message-ID: <4727D564.3080205@suse.com>
Date: Tue, 30 Oct 2007 21:07:48 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmap: restore -ENODEV on missing f_op->mmap
References: <4727AE44.10902@suse.com> <alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 
> On Tue, 30 Oct 2007, Jeff Mahoney wrote:
>>  Personally, I think this is probably a case of LTP codifying existing
>>  behavior rather than testing the for the specification. If that's the case
>>  and nobody really cares about the change in behavior, I'm fine letting this
>>  drop.
> 
> Hmm.. I think it's kind of stupid adding that special case early on, just 
> to get one particular error case return when there are multiple possible 
> ones. 
> 
> I don't care deeply, but this does smell like a test issue rather than a 
> code issue.

Ok, I'll drop it and send the LTP fix upstream there.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHJ9VkLPWxlyuTD7IRAviiAKCcOhYu2joLm8tPWZDgMa/5uvtqGQCgiz0Y
z3fHhkTg1Vfqsw9WDadHOak=
=bItr
-----END PGP SIGNATURE-----
