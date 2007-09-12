Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbXILXtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbXILXtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXILXsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:48:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41940 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932143AbXILXsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:48:53 -0400
Date: Wed, 12 Sep 2007 18:48:52 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <20070912180937.Y5573@pkunk.americas.sgi.com>
Message-ID: <20070912184601.M37791@pkunk.americas.sgi.com>
References: <20070912144128.D5573@pkunk.americas.sgi.com> <jetzpza7ci.fsf@sykes.suse.de>
 <20070912172519.N5573@pkunk.americas.sgi.com> <20070912224955.GC8181@ftp.linux.org.uk>
 <20070912180937.Y5573@pkunk.americas.sgi.com>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Brent Casavant wrote:

> On Wed, 12 Sep 2007, Al Viro wrote:
> 
> > Give me a break.  And learn about ptrace(2).  This "unlinking" bullshit
> > buys you zero additional security, both for /proc/*/mem and for /dev/mem
> > (see mknod(2)).
> 
> My (limited) understanding of ptrace is that a parent-child
> relationship is needed between the tracing process and the traced
> process (at least that's what I gather from the man page).  This
> does give cause for concern, and I might have to see what can be
> done to alleviate this concern.  I fully realize that making this
> design completely unassilable is a fools errand, but closing off
> as many attack vectors as possible seems prudent.

Hmm.  The solution would appear to be as simple as making the
target program set-user-id.  As long as as the attacker isn't
the superuser (or has CAP_SYS_PTRACE) we should be OK.

Thanks for the heads-up,
Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
