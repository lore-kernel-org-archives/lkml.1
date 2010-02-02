Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0BBGzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:55:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0BBGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:55:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B67CC55.40301@s5r6.in-berlin.de>
Date: Tue, 02 Feb 2010 07:55:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com>
In-Reply-To: <4B67C4D2.5050205@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> As for anything changed in the kernel
> (2.6.31 - present), tough to say
> from what I remember I had created a new fresh
> lfs system using these CFLAGS:
> 
> CFLAGS="-mtune=core2 -march=core2 -O2 -pipe -fomit-frame-pointer"
> CXXFLAGS="${CFLAGS}" MAKEOPTS="{-j3}"
> (without -m option gcc defaults(I think)to -m32).
> 
> which booted with ohci1394_dma=early just fine.
> 
> then decided to build another lfs system with the same CFLAGS except
> added -m64 (pure64) to the build process.
> (then this showed up).
> 
> What I can try is do a git revert to 2.6.29/27 to see if this thing
> fires off(before going any further). if the system boots then do a bisect.

Do I understand correctly that at this moment it is only known that the
bug could be
  - *either* a 2.6.31 -> 2.6.32 regression
  - *or* an x86-64 specific bug that does not occur on x86-32,
right?

I have an Core 2 Duo based PC with x86-32 kernel and userland and an AMD
based x86-64 PC and could give ohci1394_dma=early a try on both (never
tested it myself before).  I could furthermore attempt to build and
install an x86-64 kernel on the Core 2 Duo PC but I am afraid I am far
too short of spare time for that.
-- 
Stefan Richter
-=====-==-=- --=- ---=-
http://arcgraph.de/sr/
