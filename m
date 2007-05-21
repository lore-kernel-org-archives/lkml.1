Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbXEUFB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbXEUFB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXEUFBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:01:19 -0400
Received: from tuxrocks.com ([63.99.9.217]:39739 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXEUFBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:01:19 -0400
Message-ID: <46512778.2050205@tuxrocks.com>
Date: Mon, 21 May 2007 00:00:40 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Maarten Maathuis <madman2003@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [realtime kernel 2.6.21-rt2 and up] Extremely slow bootup for
 x86_64
References: <6d4bc9fc0705200525m1b72aaaevf8a1d090038bb7dc@mail.gmail.com> <1179669982.21827.25.camel@chaos>
In-Reply-To: <1179669982.21827.25.camel@chaos>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> On Sun, 2007-05-20 at 14:25 +0200, Maarten Maathuis wrote:
>> When i try to boot a kernel higher than 2.6.21-rt1, it boots very
>> slowly. It takes minutes to even detect two cdrom players. I noticed
>> in the changelog:
>>
>> - x86/64 high-res timers and dynticks update (Thomas Gleixner)
>>
>> I included the .config from 2.6.21-rt1, which i ran make oldconfig on.
>>
>> I cannot provide any other information, since i estimate it will take
>> ages to bootup.
> 
> Does the same problem show up with
> 
> http://tglx.de/projects/hrtimers/2.6.22-rc2/linux-2.6.22-rc2-x86_64-highres-v1.patch
> 
> 	tglx

I see the slow bootup as well, even with 2.6.22-rc2-hrt1.  It takes at
least 5 times as long to boot, for X to start, to login, etc.

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUSd4aI0dwg4A47wRAog8AJ9QkOlDEweqxeLxC3Bx7C5TQbMbjACfeM6k
pDJzhXJYwoH39CzIYy3eAnw=
=qNW6
-----END PGP SIGNATURE-----
