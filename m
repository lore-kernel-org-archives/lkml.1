Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYIKRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYIKRiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYIKRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 13:38:43 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:12204 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbYIKRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 13:38:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 18:32:36 +0200
User-Agent: KMail/1.9.9
References: <48C68507.6000609@suse.com> <200809111749.40204.elendil@planet.nl> <alpine.LFD.1.10.0809110852460.3384@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809110852460.3384@nehalem.linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111832.38051.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 16:32:38.0552 (UTC) FILETIME=[010D1180:01C9142C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, Linus Torvalds wrote:
> On Thu, 11 Sep 2008, Frans Pop wrote:
> > Just keep on ignoring current issues.
>
> Aren't _you_ the one who are ignoring current issues?

I don't think so.
_The_ current issue for me is that I can no longer build Debian kernel 
packages using 'make deb-pkg', which is part of _your_ tree, and install 
the resulting package *NOW*.

> The fact is, _currently_ everybody looks in /lib/firmware. The fact is,
> most people don't want millions of copies of the firmware (one copy for
> each kernel they compile - think about those of us who compile kernels
> every day).

Right, I totally agree. I did about 40 kernel builds the past two days.
(Yes, I know, there are people doing way more builds than that.)
I regularly have 5 kernels installed simultaneously, and sometimes more if 
I'm actively trying to trace an issue.

> I actually like a release-specific firmware directory, but I think it's
> the *vendor* kernel that should do it, not the normal kernel. The
> _vendor_ should put its firmware files in some vendor-specific place,
> and then add that to the end of the firmware loading path.

Hey, I'm NOT propagating versioned dirs in this thread! I've only 
mentioned them as one of the two options and explained why I think it's a 
valid choice in some scenario's.
I've also explained that I don't think Debian will go that way, but that 
is irrelevant. I basically don't care what Debian does for its official 
packages.

> So all of the noise in this whole discussion has been totally inane and
> idiotic.

Please explain what is idiotic about mentioning that 'make deb-pkg' 
produces broken packages solely because of the separate firmware and that 
that is *not* something that is easily solvable because of the way 
package management works?
Please explain why it is idiotic to say that having a compatibility option 
that would allow me to build firmware _inside_ modules, just like we 
always used to, would solve that problem?

That has nothing to do with vendors or distros. It has to do with me (and 
others like me, as a kernel tester, having to live with broken tools NOW.

I like 'make dep-pkg' because it very quickly produces a solid, *single* 
Debian package I can install and use for kernel testing. I'd like to keep 
using that as I have been, but the separation of firmware essentially 
kills my current workflow.
