Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbXJaJYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbXJaJYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXJaJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:24:10 -0400
Received: from zakalwe.fi ([80.83.5.154]:55867 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbXJaJYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:24:08 -0400
Date: Wed, 31 Oct 2007 11:24:07 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Theodore Tso <tytso@mit.edu>, Chris Holvenstot <cholvenstot@comcast.net>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Major SATA / EXT3 Issue?
Message-ID: <20071031092407.GB3441@zakalwe.fi>
References: <1193451712.6639.13.camel@localhost> <20071030135923.GA3441@zakalwe.fi> <20071031072554.GC20965@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071031072554.GC20965@thunk.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 03:25:54AM -0400, Theodore Tso wrote:
> On Tue, Oct 30, 2007 at 03:59:24PM +0200, Heikki Orsila wrote:
> > 3. fsck -p on boot failed
> > 
> > (it is very probable not many files were corrupted at this stage)
> 
> Maybe...

The system wouldn't have worked as it did, if there were so many broken 
files before fsck. For example, the system booted properly before 
fsck. After fsck the grub was broken. So, most files that were 
corrupted, were unrelated to writes that happened that night. For 
example, many files at .deb cache at /var were corrupted, but it has 
been a long time since those were touched.

> > 4. I ran fsck.ext3 -y
> > 
> > => that corrupted lots and lots of files. This went 
> > into a loop, the fsck.ext3 restarted checking over and over again.
> 
> It's possible that e2fsck corrupted the files, but they also could
> have been corrupted earlier by the earlier I/O errors.

At least there were no IO errors in log files before that night. The 
only IO error that happened put filesystem into RO state.

> There are some
> relatively rare filesystem corruptions which e2fsck doesn't handle as
> gracefully as it should, though, I will admit.  I would need to see
> the e2fsck transcript to be sure. 

Unfortunately, I do not have it.

> Were there any messages about needing to relocate inode tables by any
> chance?

I don't recall. I recall seeing messages about "too many blocks 
inside inode" and "clearing inodes". There were hundreds or 
thousands of these messages.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
