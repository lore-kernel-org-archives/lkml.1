Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZLRJ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZLRJ2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZLRJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:28:11 -0500
Received: from quamquam.org ([88.198.196.3]:47525 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZLRJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:28:09 -0500
Message-ID: <4B2B4B1D.2000806@poelzi.org>
Date: Fri, 18 Dec 2009 10:27:57 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion: xtime as new inode attribute
References: <4B292D9A.5060501@poelzi.org> <4B29C5FA.8090909@mnsu.edu>
In-Reply-To: <4B29C5FA.8090909@mnsu.edu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 92.117.35.193
X-SA-Exim-Rcpt-To: jeffrey.hundstad@mnsu.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
X-SA-Exim-Scanned: No (on quamquam.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeffrey Hundstad wrote:

>> If a linux installation gets older and older, more and more programs get
>> installed over time. Mostly to just test them for a particular problem
>> and often the deinstallation is forgotten. To find out which packages
>> are not used for a long time is currently quite impossible. The user may
>> use program X which will run but not depend on program Y as a subprocess
>> for example.
>>
>> The solution:
>
>
> Perhaps something like the "Debian package Popularity Contest":
> http://popcon.debian.org/

I think you missunderstood my intension. I wasn't thinking about a
distribution but the installation on a system. All my systems grow in
installed packages over time, i think that is something every hard core
user experiences.
You test 4-5 programs for a new task you have to do, but over time you
only use 1-2 of them and simply forget you installed some more programs
for this.
With xtime there is a very clean way to find which packages are
installed and are never used for a long time and can therefore suggested
to the user to be uninstalled. The cleanup script of course will highly
depend on the package system used and how the packages are organized and
named.

kindly regards
 Daniel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLK0scAAoJEFYpgV2Roepc3F8QAItCR2ma5c5Il26YqZlR7m/j
eFTObrN1RGPTVs3kg0E5DdlBMwg2DyUudrr0JSkfkf6x7Hc0ar39WVM2+LDcT1d/
gV8T8CMONNsqBwfPDfxkkKWzXjVvD48HdwLMLhcbzRHL4KoZJw0Fj3MQfipu5Xe+
qP6RIShyj7zLaUkjsY1p2LP+b/euJ3jpzntvZA/I0/Q/rXQ+2eEHYzelFeyPCgqT
e4zjm7RKBuukQOtvS0Yiys3zyW0lFszfSwLMnWUM8V3vZBjUsVeuULlqmwWgcQhl
cKMzz4lCpkFUZen1CKsw64m8LVWH5MryfEJ+wl8UkgtwBJpKENIrkMRFgjXaIMLQ
4n2rLjbLNwdzJsCA6HdGCqD5Vq7PZtMnWf4n3Fn1NfLGcDN+fScKW9R+SLfEwM8D
i213qvL40jM8nFRxZ3bCjwM9iMKWObF96i8SEZ+q1ig4BzjJXYt3Va1HL31KL9v2
CrDa0w5R04p/IIp5vl6OmXryS1Nsj8kidL433z2WOttrr6tQPnlk1IjPTzoU9zUw
VZcuPck1SNAkLpqeCMK4n5lGeVsfAsiiNRRcZXyOkyqSJimd/BxFmLPmNaf7HYrd
V8oUDUO8NP7Sx9bPCxlmZKmuQWXqm+Eq9bm6vrl179Jy4nd1+UTfRL1twSDuIsnm
nAxFTQ2Ea8Vm2gE/IHvE
=DOSZ
-----END PGP SIGNATURE-----
