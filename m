Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0BMIRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:17:52 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57639 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab0BMIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:17:50 -0500
Date: Sat, 13 Feb 2010 09:17:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Willy Tarreau <w@1wt.eu>
Cc: lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100213091748.276821e1@hyperion.delvare>
In-Reply-To: <20100212230702.GA10266@1wt.eu>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
	<4B75A5DC.3060803@kernel.org>
	<20100212202357.6363d5af@hyperion.delvare>
	<20100212230702.GA10266@1wt.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Willy,

On Sat, 13 Feb 2010 00:07:02 +0100, Willy Tarreau wrote:
> On Fri, Feb 12, 2010 at 08:23:57PM +0100, Jean Delvare wrote:
> > > It's probably worth keeping things like the .gz files around, if nothing
> > > else for older distros, systems, etc that don't have xz yet (since it's
> > > still relatively new)
> > 
> > Hardly a good reason IMHO. xz can be installed on these systems. When
> > we switched to git, nobody had it and it did not stop us.
> 
> I don't agree, it's different. Git is only used by developers, and even
> not all of them. Sources are a reference. Anyone can download them to
> look for anything. Switching to a specific format which really is not
> common at all on older distros nor on any system looks a bit like
> proprietary encoding eventhough it's not the case. But it's a way to
> tell people that if they want the sources in clear text form, they
> first have to find a tool capable of decompressing them.

Just like switching to git was a way to tell people that if they wanted
to contribute to the kernel, they first had to install the right, at
the time uncommon tool. Of course the audience isn't the same, but the
principle is similar. And the audience is still fairly limited in both
cases. My parents aren't downloading kernel tarballs. I would assume
that anyone willing and able to download, read and understand the linux
kernel source code wouldn't be frightened by having to install a small
tool to extract these sources. And they may not even have to do this:
sources can be read with just a web browser: we have the gitweb
interface, and several public LXR installations are deployed as well.
These days, web browsers are much more popular than ftp clients and
tarballs.

As a matter of fact, I am advocating the use of xz while I don't have
it installed on most of my machines. I really don't see this as a
blocker.

> Gzip is well
> defined as a standard, it's even described in an RFC and is present
> on almost any system (unix or not) now. Any student who wants to take
> a look at the kernel will have access to gunzip, even from an old
> Solaris 8 workstation or a Windows XP desktop PC.

Really? I have a Windows XP laptop at hand and it can't read .gz files.
If I ask it to try, it tells me I should install WinZip. I also seem to
recall that I had to install GNU gzip myself back when I was working on
a Solaris workstation (but I might remember badly.)

> XZ if far from
> being there, and the student will not necessarily be able to install
> it. And Peter raised some valid points about the hardware requirements
> to run such tools ; I'm not sure the guys running Linux on their old
> Sparc-2 would like XZ only a lot.

I don't quite buy this argument either. I suspect this is a very
limited count of users, and these users have access to other, more
powerful machines where they can easily achieve any format conversion
they need.

I have an old, slow machine here which I am going to use to perform
some real world testing, and I'll post the results when I'm done. But I
suspect that building a kernel on this machine, even a small one with
just the drivers it needs, will take much longer than unpacking the
sources. So anyone worrying about performance would rather rely on
cross-compilation, and in turn can afford whatever decompression tool
is needed.

-- 
Jean Delvare
