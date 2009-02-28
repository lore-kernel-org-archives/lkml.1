Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZB1OwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZB1OwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbZB1OwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:52:06 -0500
Received: from thunk.org ([69.25.196.29]:44640 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZB1OwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:52:04 -0500
Date: Sat, 28 Feb 2009 09:52:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Fries <david@fries.net>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reorder ext4 and ext2 so that ext2 root filesystems
	are mounted using ext2
Message-ID: <20090228145200.GA6935@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Fries <david@fries.net>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1235831060-10086-1-git-send-email-tytso@mit.edu> <20090228143943.GD4894@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228143943.GD4894@spacedout.fries.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 08:39:43AM -0600, David Fries wrote:
> 
> Try
> > +# We place ext4 after ext2 so plain ext2 root fs's aren't mounted using ext4
> > +# unless explicitly requested by rootfstype
> 

Oops, nice catch!  I changed it to be:

# We place ext4 after ext2 so plain ext2 root fs's are mounted using ext2
# unless explicitly requested by rootfstype

Thanks,

						- Ted
