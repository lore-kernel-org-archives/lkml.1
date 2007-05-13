Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXEMAgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXEMAgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 20:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXEMAf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 20:35:58 -0400
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:45437 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbXEMAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 20:35:57 -0400
Message-ID: <46465D43.3060200@gmail.com>
Date: Sat, 12 May 2007 21:35:15 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <4645032E.1030109@gmail.com> <46450910.8080503@zytor.com>
In-Reply-To: <46450910.8080503@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> Kevin Winchester wrote:
>> Not sure if you were looking for testing, but I fuzzed it to apply to
>> 2.6.21-git and gave it a spin.  Worked just like a normal boot (which I
>> assume was the point).
> 
> That would be the point, yes :)  Looking for breakage in video mode
> detection, memory detection, and APM are probably the trickiest areas.
> 
> 	-hpa
> 

Video mode detection (including "scan") seemed to work just the same as before.
 As for memory detection, my 512M x86-64 UP system is probably not what you had
in mind, and I don't really know what goes on for APM or how to test it.

As well, I've been looking through the actual code, and even with my very
limited experience with x86 assembler and operating systems, I now at least have
an idea of what is going on.  So switching to C for as much of the code as
possible seems like the right idea if you want to make it easier for new people
to get involved in that area of the kernel.

Kevin

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGRl1CKPGFQbiQ3tQRAuEcAJ93zlfNzB7YipLHgvkQP3Jrtjh0EwCfSRQ5
9emaZMVvJsuXMs1ifO4KWkY=
=G4zx
-----END PGP SIGNATURE-----
