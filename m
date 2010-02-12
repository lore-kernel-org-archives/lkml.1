Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0BLXHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:07:51 -0500
Received: from 1wt.eu ([62.212.114.60]:56348 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0BLXHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:07:48 -0500
Date: Sat, 13 Feb 2010 00:07:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jean Delvare <khali@linux-fr.org>
Cc: "J.H." <warthog9@kernel.org>, lasse.collin@tukaani.org, mirrors@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212230702.GA10266@1wt.eu>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212202357.6363d5af@hyperion.delvare>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 08:23:57PM +0100, Jean Delvare wrote:
> > It's probably worth keeping things like the .gz files around, if nothing
> > else for older distros, systems, etc that don't have xz yet (since it's
> > still relatively new)
> 
> Hardly a good reason IMHO. xz can be installed on these systems. When
> we switched to git, nobody had it and it did not stop us.

I don't agree, it's different. Git is only used by developers, and even
not all of them. Sources are a reference. Anyone can download them to
look for anything. Switching to a specific format which really is not
common at all on older distros nor on any system looks a bit like
proprietary encoding eventhough it's not the case. But it's a way to
tell people that if they want the sources in clear text form, they
first have to find a tool capable of decompressing them. Gzip is well
defined as a standard, it's even described in an RFC and is present
on almost any system (unix or not) now. Any student who wants to take
a look at the kernel will have access to gunzip, even from an old
Solaris 8 workstation or a Windows XP desktop PC. XZ if far from
being there, and the student will not necessarily be able to install
it. And Peter raised some valid points about the hardware requirements
to run such tools ; I'm not sure the guys running Linux on their old
Sparc-2 would like XZ only a lot.

Regards,
Willy

