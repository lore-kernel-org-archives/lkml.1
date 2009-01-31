Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZAaEBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZAaEBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 23:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZAaEBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 23:01:16 -0500
Received: from THUNK.ORG ([69.25.196.29]:53647 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbZAaEBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 23:01:15 -0500
Date: Fri, 30 Jan 2009 19:09:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fw: 2.6.27 & ext4 strangeness
Message-ID: <20090131000917.GB27950@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alex Buell <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org
References: <20090130194702.5a2ca774@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130194702.5a2ca774@lithium.local.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 07:47:02PM +0000, Alex Buell wrote:
> 
> As this has happened three times in the last 24 hours, I thought I'd
> report this. Whenever my laptop locks up, I have to powercycle. After
> rebooting, and fsck.ext4 reports a clean filesystem, often I get a 'no
> space on device' error even though I have plenty of disk space left.
> Another reboot with a forced fsck.ext4 cures this, every time. This only
> happens with ext4 filesystems used as the root filesystem. 

If you can reproduce this, can you send me the output of "df /; df -i
/; dumpe2fs /dev/XXX" (where XXX is your root device) before you
reboot and force an fsck?  And then can you send me the output of "df
/ ; df -i /; dumpe2fs /dev/XXX" after the 2nd reboot and forced fsck.
I've never seen anything like this, so I don't know what to make of it.

It also would be interesting to see if you can reproduce it running a
kernel from the ext4-stable branch of the ext4 tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

This has all of the ext4 fixes that is in the latest mainline, based
on the 2.6.28 kernel.

Thanks for reporting your observations,

							- Ted
