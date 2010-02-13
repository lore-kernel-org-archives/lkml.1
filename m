Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0BMWqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:46:10 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:33492 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757999Ab0BMWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:46:07 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o1DMdXhk032078
Subject: Re: [kernel] Re: [kernel.org users] XZ Migration discussion
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Avi Kivity <avi@redhat.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jean Delvare <khali@linux-fr.org>, Willy Tarreau <w@1wt.eu>,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1002131233450.30803@filesrv1.baby-dragons.com>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
	 <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare>
	 <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare>
	 <4B767810.5020707@s5r6.in-berlin.de> <4B767C67.7060701@redhat.com>
	 <alpine.LNX.2.01.1002131233450.30803@filesrv1.baby-dragons.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Feb 2010 23:39:33 +0100
Message-ID: <1266100773.23181.8.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-DCC-CTc-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sam, 2010-02-13 at 12:37 -0900, Mr. James W. Laferriere wrote:
> On Sat, 13 Feb 2010, Avi Kivity wrote:
[...]
> > Can you even unpack a kernel tree on Windows?  There are some files (e.g. 
Given a sane filesystem, yes. If (the) native filesystem(s) are sane, is
more a flamebait than anything else.

> > net/ipv4/netfilter/ipt_{ecn,ECN}.c) which conflict on a case-preserving 
> > filesystem.
>  	What filesystem version are you talking about ?
All of NTFS (and basically FAT*). Are there are different versions? If
yes, how do I tell?

>  	ntfs as of recent windows is not case insensitive .
It *is* case insensitive (as it compares filesystem names
case-insensitive on the equivalent of an open() syscall).

>  	What do you mean by , "a case-preserving filesystem" ?
Apart from "please google that, thank you": The filesystem (driver))
preserves the case of a filename if you create it (TTBOMK). But it
ignores the case of the filename for other file operations like open(),
stat(), etc.

>  	Now whether or not the tools available are case insensitive is another 
> matter .
ACK. But if you have a case-insensitive or case-preserving filesystem,
the tools can´t really do that much.
And given the "understanding" of the monopolist (as such) in that area,
most of the "tools" are actually inherent part of the OS (and not just
another 3rd party app). SCNR ....

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

