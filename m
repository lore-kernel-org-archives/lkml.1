Return-Path: <linux-kernel-owner+w=401wt.eu-S1764551AbZDBQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764551AbZDBQqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762274AbZDBQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:45:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41258 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZDBQpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:45:32 -0400
Message-ID: <49D4EB84.6020100@garzik.org>
Date: Thu, 02 Apr 2009 12:44:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       open-osd mailing-list <osd-dev@open-osd.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Request for pulling exofs for 2.6.30
References: <49D4E70A.9090507@panasas.com>
In-Reply-To: <49D4E70A.9090507@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> which is available in the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git for-linus
> 
> Boaz Harrosh (9):
>       exofs: Kbuild, Headers and osd utils
>       exofs: file and file_inode operations
>       exofs: symlink_inode and fast_symlink_inode operations
>       exofs: address_space_operations
>       exofs: dir_inode and directory operations
>       exofs: super_operations and file_system_type
>       exofs: export_operations
>       exofs: Documentation
>       fs: Add exofs to Kernel build



For what little weight I have in this area... ACK

But I would suggest _not_ splitting up the add-filesystem patch.  You 
really only want to split up this stuff for review.

The add-exofs change is one single logical change, and splitting it up 
across multiple changesets is not the most optimal nor bisect-safe approach.

	Jeff



