Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0BNTIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:08:11 -0500
Received: from poutre.nerim.net ([62.4.16.124]:60382 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0BNTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:08:07 -0500
Date: Sun, 14 Feb 2010 20:08:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214200803.4b2348ce@hyperion.delvare>
In-Reply-To: <20100214170724.GE1578@ucw.cz>
References: <4B744E13.8040004@kernel.org>
	<20100212150137.648dca7c@hyperion.delvare>
	<alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
	<4B75A5DC.3060803@kernel.org>
	<20100212202357.6363d5af@hyperion.delvare>
	<20100212230702.GA10266@1wt.eu>
	<20100213091748.276821e1@hyperion.delvare>
	<20100214170724.GE1578@ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 18:07:24 +0100, Pavel Machek wrote:
> Hi!
> 
> > As a matter of fact, I am advocating the use of xz while I don't have
> > it installed on most of my machines. I really don't see this as a
> > blocker.
> 
> Eh?
> 
> Making many people around the world install uncommon tool is not
> something that should be done lightly.

It's pretty obvious that xz will become popular quickly, at least on
Linux and BSD systems, much like bz2 is today. I'm not asking people to
start using ClearCase ;) xz will supersede bz2, it's only a matter of
time. I see no problem in being one of the early adopters.

> > I have an old, slow machine here which I am going to use to perform
> > some real world testing, and I'll post the results when I'm done. But I
> > suspect that building a kernel on this machine, even a small one with
> > just the drivers it needs, will take much longer than unpacking the
> > sources. So anyone worrying about performance would rather rely on
> > cross-compilation, and in turn can afford whatever decompression tool
> > is needed.
> 
> On zaurus, kernel compilation takes 4 hours. (I.e. "one night"). So
> that one is ... well ... done overnight.

Out of curiosity, if it takes that long, why don't you use a
cross-compiler?

> Untar is something I normally wait for, since you need to run
> (interactive) oldconfig after that.

You'll have to wait, no matter what compression format you use (and
even if you don't compress the tarball). Judging by the duration of the
build on your machine, I'd estimate the decompression time to 7 minutes
for gz vs. 15 minutes for bz2 maybe? I doubt you sit in front of the
machine for 7 minutes waiting for tar.gz to decompress, right? So I
fail to see what difference it makes. You'll just do something else for
15 minutes instead of doing something else for 7 minutes.

Anyway, as I have been saying several times already, nothing prevents
you from repacking tarballs to gz before uploading it to your slow
system if such is your desire. I can understand the portability
argument, but the decompression time, no way.

-- 
Jean Delvare
