Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYEYKWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYEYKWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYEYKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:22:30 -0400
Received: from toomai.ethgen.de ([85.10.201.50]:38452 "EHLO toomai.ethgen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYEYKW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:22:29 -0400
Date: Sun, 25 May 2008 12:22:22 +0200
From: Klaus Ethgen <Klaus@Ethgen.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [KERNEL] Re: Bug in libata
Message-ID: <20080525102222.GB27369@ikki.ethgen.de>
References: <20080524191326.GA2917@ikki.ethgen.de> <48386DFB.2090607@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Content-Disposition: inline
In-Reply-To: <48386DFB.2090607@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Resent as the mail had delivery failure on on
linux-kernel@vger.kernel.org.

Hi Jeff,

Am Sa den 24. Mai 2008 um 21:35 schrieb Jeff Garzik:
>> after several time I decided to update the kernel on my IBM ThinkPad
>> T43p to the newest one (2.6.25.4). After doing so my system was unable
>> to boot. I always got the following error:
>>    ata_piix 000:00:1f.2: failed to request/iomap BARs for port 0 (errno=-16)
>>
>> After doing some regressions tests I got the wrong commit. Git commit
>> 8cdfb29c0cd8018f92214c11c631d8926f4cb032 which is from Jeff Garzik
>> introduce the bug that makes the system unbootable at all.
[...]
> This is a configuration problem.  You need to pick one driver or the other, 
> not both, as that commit's description indicates.

Ah, now I read that in the right way. I didn't read it the way that it
is excepting each other. The reason I misread it was that I have a
system with a SATA hard drive and a PATA CDROM. So I read that I need
explicit both for both devices. Compiling the PATA stuff as module (or
not compiling with it) gets the issue solved.

Shouldn't there a excluding rule in the configuration?

Regards
   Klaus Ethgen
- -- 
Klaus Ethgen                            http://www.ethgen.de/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBSDk93p+OKpjRpO3lAQIQ5wf/S8xnADlviXi2bXBcJha93pp9c/pEsg+H
Cf6GrYG1A9oLq2ZDcYXkskiEqLMzcv89HOuUMaBKHx2rglBDjF8HvcWv/urJZwsW
qao0oB9ez7Gr1EJUOqxdTCGagmjZqZNOBCeCBGJB0HjHT/I8hFfYOwXql+B6LEWh
t9RHWDg4bnOWYq0Wedo/zpASkyShJwGsCEubffgWjxzhJcZ/ynAz5PQNaQKZx9JW
SQ2UfJ2IZe1kPJrB3t9yldwhl6E9wqZrG85Y9PR7+i5d6LLZBxwlHjG8e5ZQjZPY
t85+daxer0tIY/HNyQL/M206eevDQy1DATJNdea/RyU2zm0QZ4PGtA==
=FA1Y
-----END PGP SIGNATURE-----
