Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZA1VOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZA1VOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZA1VNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:13:54 -0500
Received: from THUNK.ORG ([69.25.196.29]:44991 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZA1VNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:13:53 -0500
Date: Wed, 28 Jan 2009 16:13:47 -0500
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk,
       linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: add required versions for new
	filesystems
Message-ID: <20090128211347.GG8990@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk,
	linux-btrfs@vger.kernel.org
References: <1233158441-5475-1-git-send-email-notting@redhat.com> <20090128160157.GA5598@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128160157.GA5598@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:01:57AM -0500, Bill Nottingham wrote:
> Bill Nottingham (notting@redhat.com) said: 
> > btrfs requires version 0.18 of its tools, and squashfs requires
> > 4.0.
> 
> This time, with a typo fix.

While you're at it, could you also update e2fsprogs to require 1.41.4.
It's required for ext4, and even for ext3, if the text is going to
say, "if you're going to report any bugs, please update to the
versions of these programs".  So the line for e2fsprogs should read:

 o  e2fsprogs              1.41.4                    # e2fsck -V

I could push this as a separate patch, but then there could be patch
conflicts, so it might be nice if you could update e2fsprogs at the
same time.

Thanks!!

						- Ted
