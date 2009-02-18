Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbZBRWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbZBRWvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbZBRWsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:48:22 -0500
Received: from THUNK.ORG ([69.25.196.29]:52140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbZBRWsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:48:21 -0500
Date: Wed, 18 Feb 2009 17:25:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu Jaunty ext3 --> ext4 upgrade issue
Message-ID: <20090218222517.GT3600@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tim Gardner <tim.gardner@canonical.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <499C4F1E.8050901@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C4F1E.8050901@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 11:10:38AM -0700, Tim Gardner wrote:
> I've encountered a situation where the patches that you've proposed for
> stable updates might be causing some issues. This user ivoks appears to
> have an upgrade issue. I assume he's enabled ext4 on an existing ext3
> file system. Hopefully I can get more details. Have you seen anything
> like this?

No, this is the first I've heard of it. 

> <ivoks> i'm getting 'Invalid or unsupported executable format' from grub
> on all jaunty's generic kernels since (including) 2.6.28-7

So grub is complaining that it can't boot from a partition after
upgrading to the new kernel with the for-stable patches?  Um, that's
interesting.  So the obvious thing to check is to do an md5 checksum
of the kernel in /boot to make sure it didn't get corrupted somehow.
The other thing to check would be to ask the user to run e2fsck to
rule out filesystem corruption.

OTOH, if this was just a simple install and upgrade, presumably the
new kernel would have been installed while the previous kernel was
booted.

I do my testing by using a ext3 /boot partition (since my
crash-and-burn netbook is running Ubuntu Jaunty).  So I wouldn't have
noticed anything, but this seems very odd.

More information would be useful; is there a Launchpad bug open on this yet?

Or we can work this out on LKML or the linux-ext4 mailing list if the
reporter is willing to be cc'ed on the thread....

     		       	  	     	   - Ted
