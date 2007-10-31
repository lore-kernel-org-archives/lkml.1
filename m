Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXJaH0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXJaH0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXJaH0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:26:35 -0400
Received: from THUNK.ORG ([69.25.196.29]:34843 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbXJaH0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:26:34 -0400
Date: Wed, 31 Oct 2007 03:25:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Chris Holvenstot <cholvenstot@comcast.net>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Major SATA / EXT3 Issue?
Message-ID: <20071031072554.GC20965@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Heikki Orsila <shdl@zakalwe.fi>,
	Chris Holvenstot <cholvenstot@comcast.net>,
	kernel list <linux-kernel@vger.kernel.org>
References: <1193451712.6639.13.camel@localhost> <20071030135923.GA3441@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030135923.GA3441@zakalwe.fi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 03:59:24PM +0200, Heikki Orsila wrote:
> 3. fsck -p on boot failed
> 
> (it is very probable not many files were corrupted at this stage)

Maybe...
> 
> 4. I ran fsck.ext3 -y
> 
> => that corrupted lots and lots of files. This went 
> into a loop, the fsck.ext3 restarted checking over and over again.

It's possible that e2fsck corrupted the files, but they also could
have been corrupted earlier by the earlier I/O errors.  There are some
relatively rare filesystem corruptions which e2fsck doesn't handle as
gracefully as it should, though, I will admit.  I would need to see
the e2fsck transcript to be sure. 

Were there any messages about needing to relocate inode tables by any
chance?

						- Ted
