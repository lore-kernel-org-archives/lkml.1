Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab0BRWCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:02:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:42559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0BRWCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:02:35 -0500
Date: Thu, 18 Feb 2010 23:02:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Ball <cjb@laptop.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
In-Reply-To: <m37hqamlau.fsf@pullcord.laptop.org>
Message-ID: <alpine.LNX.2.00.1002182300520.30967@pobox.suse.cz>
References: <20100218095200.63509b8c@bike.lwn.net> <m37hqamlau.fsf@pullcord.laptop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, Chris Ball wrote:

>    > The ChangeLog file under drivers/char is 30K of stuff dedicated
>    > to the mid-90's TTY exploits of Ted Ts'o; it has been updated
>    > once since 1998 - and that was in 2001.  It's interesting
>    > history, but we don't normally carry that kind of history inline
>    > with the code.  Let's remove it.
> 
> Should we lose the others too, then?
> 
> pullcord:cjb~/git/linux-2.6 % du -sh **/ChangeLog
> 8.0K	arch/arm/nwfpe/ChangeLog
> 32K	drivers/char/ChangeLog
> 20K	drivers/parport/ChangeLog
> 16K	fs/befs/ChangeLog
> 100K	fs/ntfs/ChangeLog
> 
> Last changed dates:
> 
> arch/arm/nwfpe/ChangeLog  = 2003/03
> drivers/parport/ChangeLog = 2001/10
> fs/befs/ChangeLog         = 2002/03
> fs/ntfs/ChangeLog         = 2007/10
> 
> The ntfs changelog is modified recently, but the ChangeLog text added
> to it is duplicated as the commit message for each change, so those
> ChangeLog entries are redundant -- they're already in the commit
> history, unless you want changes from earlier than the initial import
> cutoff in 2004, in which case you'd need the history repo for those.

I think we could nuke them all, but I'd suggest first checking with 
maintainers of the code in question. It's possible that they do some kind 
of auto-import from some weird external repositories in which they 
auto-generate this Changelog file, so they might re-appear later (not 
everyone is using git even these days ... strange, but apparently true).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
