Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZCJPIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZCJPIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZCJPIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:08:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:52958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZCJPIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:08:44 -0400
Date: Tue, 10 Mar 2009 16:08:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 2/2] fs: introduce mnt_clone_write
Message-ID: <20090310150841.GB8579@wotan.suse.de>
References: <20090310143718.GB15977@wotan.suse.de> <20090310143801.GC15977@wotan.suse.de> <20090310145558.GY25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310145558.GY25995@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 08:55:58AM -0600, Matthew Wilcox wrote:
> On Tue, Mar 10, 2009 at 03:38:01PM +0100, Nick Piggin wrote:
> > +EXPORT_SYMBOL_GPL(mnt_clone_write);
> > +EXPORT_SYMBOL_GPL(mnt_want_write_file);
> 
> You don't add any users of these functions in this patch ... is there a
> good reason to export them?

Only to encourage modular code to use them (as a replacement for
mnt_want_write -- which itself is exported).

If that's not the right way to go, I don't mind waiting for a
user to turn up.


[I see many ioctls in btrfs (coming first in the alphabet) could
probably easily use mnt_want_write_file (otoh probably none are
so performance critical).]

