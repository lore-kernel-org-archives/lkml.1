Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZEZVPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZEZVPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZEZVPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:15:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbZEZVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:15:09 -0400
Date: Tue, 26 May 2009 17:15:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <greg@kroah.com>
cc: GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
 mount debugfs filesystem.
In-Reply-To: <20090526205414.GA26016@kroah.com>
Message-ID: <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com> <20090526205414.GA26016@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 May 2009, Greg KH wrote:
> > 
> > The filesystem Nazi's out there will argue that the proper place to mount 
> > the debugfs filesystem is /sys/kernel/debug. I personally find that 
> > location annoying.
> 
> Why?

Because it is too much to type ;-)

> 
> When I created debugfs, I was told that I had to pick a place to mount
> it so that everyone could write scripts that "knew" where it would be.
> 
> So we picked /sys/kernel/debug/ and the code creates the mount point to
> put it there.  Now distros actually mount debugfs at that location.
> 
> So, now you don't like this?  After it's become a standard?  Ick.
> 
> Becides, /debug/ is pretty presumptious, it's as if debugging the kernel
> is a system-wide thing :)
> 
> So please, don't use /debug/ use the standard, defined, and ACTUALLY
> USED BY DISTROS TODAY mount point of /sys/kernel/debug/
> 
> If you want to create your own symlink from /debug/ to that location to
> make it easier to type, feel free, but do not hard code any scripts to
> use that location, or they are going to break.

All my scripts search /proc/mounts to find where debugfs is mounted, then 
it uses that.

Hmm, Not sure what packages in the distros use the default. I don't see 
the debugfs in /etc/fstab in any of my machines.

-- Steve

