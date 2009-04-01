Return-Path: <linux-kernel-owner+w=401wt.eu-S1763894AbZDAQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763894AbZDAQ3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZDAQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:28:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbZDAQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:28:57 -0400
Message-ID: <49D39642.9070606@suse.com>
Date: Wed, 01 Apr 2009 12:28:50 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-1?Q?Fr=E9d?= =?ISO-8859-1?Q?=E9ric_Weisbecker?= 
	<fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
References: <20090330180215.951354436@suse.com> <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain> <20090401161657.GA13802@elte.hu>
In-Reply-To: <20090401161657.GA13802@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>> Once this is applied, I expect reiserfs to be in deep 
>>> maintenance-only mode.
>> Heh, I hadn't expected even this.
> 
> Note, there are BKL-removal patches in the works by Frédéric 
> Weisbecker, for the tip:kill-the-BKL topic branch.
> 
> Reiser3 is the heaviest (and most non-trivial) BKL user amongst all 
> the filesystems, its BKL use is recursive and it frequently relies 
> on the implicit dropping of the BKL at various blocking points both 
> for correctness and for performance reasons.
> 
> There might be something worth posting+reviewing soon.

Oh interesting. I'm glad someone is working on this. I've started to
several times and decided to focus my efforts on things outside of
reiserfs instead. The reiserfs usage of the BKL has always been a black
mark.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknTlkIACgkQLPWxlyuTD7IAsQCfSNKuHk7oL8KhZK1InW7b189z
K4kAn3lINkZFMg89wJbwSiLZEfeQLLJA
=grqX
-----END PGP SIGNATURE-----
