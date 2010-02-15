Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0BOXkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 18:40:39 -0500
Received: from fed1rmmtai113.cox.net ([68.230.241.47]:45772 "EHLO
	fed1rmmtai113.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0BOXki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 18:40:38 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 18:40:38 EST
X-VR-Score: -200.00
X-Authority-Analysis: v=1.1 cv=3OYv9oSQMPl2mzQJct9Z0gr0/14v7p3aTRAVsPGESI0=
 c=1 sm=1 a=uTOmaDeAZlAA:10 a=HlZ6VxFVnLLLPNOIqxd1ew==:17
 a=8qkDZ3Nd4RW7hjIsr3oA:9 a=z6u4Lf4_LArV5WxpZp0A:7
 a=GVbtg5tKWI5-ER12EIUtflMpPywA:4 a=HlZ6VxFVnLLLPNOIqxd1ew==:117
X-CM-Score: 0.00
Date: Mon, 15 Feb 2010 16:32:10 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100215233210.GB2147@smtp.west.cox.net>
References: <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <4B767810.5020707@s5r6.in-berlin.de> <20100214171327.GF1578@ucw.cz> <4B7833FD.2010107@s5r6.in-berlin.de> <20100214205117.GE2453@elf.ucw.cz> <4B790A55.8070805@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B790A55.8070805@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:48:21AM +0100, Stefan Richter wrote:
> Pavel Machek wrote:
[snip]
> > No more windows systems
> > here. On android, gzip is supported, xzip is not. Debian machine
> > supports both, but gzip was preinstalled and I had to pull xzip. (This
> > does not help either:
> > 
> > root@amd:~# apt-cache search xzip
> > xzip - Interpreter of Infocom-format story-files
> 
> Considering that xz support is available even on niche systems like
> Amiga OS and BeOS (via p7zip if not by other means) and xz-utils proper
> build even on DOS, OpenVMS and other systems, how hard can it be to
> obtain an xz decompressor on Android, Debian, or Ubuntu¹?  (¹About which
> there was a note somewhere else in this thread that there is a conflict
> between xz-utils and lzma-utils... That's basically because the former
> supersede the latter.)

This, I think gets to one of the problems.  You're telling me that the
p7zip thing I installed for work is this .xz thing?  And it's really all
this LZMA algo?  That's part of the transition problem, folks quite
likely have access, easily, to a decompressor but don't know what it is
(.gz->gzip, .bz2 -> bzip2, .xz -> {p7zip, p7zip-full, xz-utils, ???}).

In fact, why not .lzma?  I'm assuming we're talking about the format,
and xz-utils nad p7zip and others all implement the same format and it's
all compatible and it's just a "how do we get there quickest / fastest"
kind of thing between the utils.

> The name confusion between xz-utils and xzip can be avoided if you
> search for the package in a package manager which shows package
> categories (archivers vs. games).

Actually, no, there's no 'xz-utils' in Debian/Lenny or Ubuntu 9.04, but
there is in 9.10.  But in 9.10, searching on xzip (a good, but
incorrect guess) only gives that.  Searching on xz shows xz-utils too.
At least with apt-cache, and since the desc doesn't list xzip (since
it's not xzip, it's an incorrect but not illogical guess), that
wouldn't help.

-- 
Tom Rini
