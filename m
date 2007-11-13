Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbXKMAnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbXKMAnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXKMAmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:42:51 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:54166 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbXKMAmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:42:49 -0500
Date: Tue, 13 Nov 2007 02:12:23 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071113001223.GA15663@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <47387BB5.4090908@smsglobal.net> <20071112171456.GN9771@stusta.de> <slrnfjh2nn.aam.tuomov@jolt.modeemi.cs.tut.fi> <20071112233955.GA25059@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071112233955.GA25059@citd.de>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-11-13 00:39 +0100, Matthias Schniedermeyer wrote:
> That's the problem(tm).
> 
> Contrary to Closed Source Software all(!) OSS-Software is 
> interdependent. There is no "Stand-Alone"-Software. There is always at 
> least "libc". (Scripts depend on a script-interpreter, which in turn 
> depends at least on libc, so there is nothing(tm) that doesn't depend on 
> libc)

Closed source software also depends on other software, but the
non-standard dependencies are usually distributed along with the
main program, which are more often big applications than small 
combinable utilities, than in FOSS.

In FOSS, OTOH, dependencies are no distributed along with the main
software, and now when programs depend on different versions of
a library, the brain-damaged all-in-one-basket *nix file system 
hierarchy results in trouble.

An intermediate is needed between those two extremes: separately
distributed dependencies that do not conflict. If packages lived 
in their own directories, and were relocatable, multiple versions
could more easily coexist, and packages specify the versions they
work with (or rather, more abstract cryptographically identified
capabilities that they require). Of course, there are other 
potential conflicts besides library versions and their locations,
such as the protocol used by some essential system daemon, but 
these are encountered far less often, and could sometimes be 
solved by e.g. a package providing a wrapper capability.

Also, what if distributions would simply go in, say, /debian-etch/,
/fedora-core4/, and so on? You could then to a great extent run 
multiple simultaneously, just having to choose a few services 
from one of them that the others would have to use, and hopefully
work with, as well as a kernel. The problems are not insurmountable:
you can already run another OS in a virtual machine and set DISPLAY 
point to your main OS, although it's a bit cumbersome.

-- 
Tuomo
