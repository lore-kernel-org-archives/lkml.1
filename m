Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZDOVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZDOVKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZDOVKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:10:06 -0400
Received: from thunk.org ([69.25.196.29]:47449 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZDOVKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:10:05 -0400
Date: Wed, 15 Apr 2009 17:09:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Message-ID: <20090415210949.GF21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 01:35:23PM -0700, Linus Torvalds wrote:
> I'm inclined to apply the first two patches as infrastructure, since they 
> seem to make sense regardless of data=ordered. The ability to get a 
> callback when IO ends sounds like something that a number of cases might 
> find intriguing, and it's obviously how the actual IO has worked 
> internally anyway.

The first two patches look good to me.  I haven't had time to go
through the last patch carefully (and that's the most complicated one
of course).  They don't currently have any in-kernel users, so it
fails the traditional test for inclusion, but the basic functionality
they provide makes a lot of sense to me.

					- Ted
