Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYJVSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYJVSES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYJVSDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:03:47 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53876 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbYJVSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:03:46 -0400
Date: Wed, 22 Oct 2008 14:03:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yea old defrag
Message-ID: <20081022180342.GA26257@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Phillip Susi <psusi@cfl.rr.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <48FF506F.6060701@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF506F.6060701@cfl.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:10:23PM -0400, Phillip Susi wrote:
> I'm writing this to Theodore Ts'o because he has worked on the package  
> in the past, and currently maintains e2fsprogs.   I am CCing lkml since  
> there are likely to be other interested parties, and there does not seem  
> to be a separate list for e2fsprogs.
>
> The old defrag package for doing offline defragmentation of ext2 has not  
> been maintained in many years.  About two years ago I fixed a few bugs  
> that were causing it to not work on ext3 and placed the changes in  
> Ubuntu.  I would like to see this program continue to live since it  
> still serves a purpose, but because it has had no upstream maintainer in  
> so long, Debian and thus Ubuntu have dropped the package.  I am trying  
> to resurrect it.
>
> I was wondering why it was never integrated into e2fsprogs, and if this  
> could now be done.  It seems to me that e2fsprogs would be the proper  
> home for it, and a neutral upstream for everyone.  If not, then I will  
> try to maintain it as an Ubuntu native package in a bazaar branch on  
> launchpad.

The problem with the defrag code has always been that I haven't had
time to give it proper love and attention, and it needs a *lot* of
work before I would be willing to stand behind it as a useful and
"safe" tool to use.  Basically, I don't want to get the hate mail from
people who lose their data due to bugs or other potential failures
from e2defrag.

I have a vague memory it doesn't even work if the filesystem blocksize
is greater than 1k, but I'm not 100% certain that is still true.

There is also an on-line defragmetter that requires kernel support
that some folks from NEC are working on for ext4 (which can also
support ext3 filesystems).  My thinking is that it's more worthwhile
to focus my attentions on helping Akira Fujita and Takashi Sato finish
theiron-line ext4 defragmentation patches than to worry about
e2defrag.  Of course, if you'd like to give some love and attention to
e2defrag, that's great.  But e2defrag doesn't use the ext2fs
libraries, and it would be a huge amount of work to make sure it
supports things like extended attributes and other newer format
enhancements that have been made to the ext3 filesystem.

Regards,

						- Ted

