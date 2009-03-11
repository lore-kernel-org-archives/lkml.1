Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZCKUOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZCKUOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZCKUN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:13:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50838 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZCKUNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:13:55 -0400
Date: Wed, 11 Mar 2009 14:13:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
Message-ID: <20090311201337.GI25995@parisc-linux.org>
References: <20090311043659.GC25995@parisc-linux.org> <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:22:56PM -0700, Linus Torvalds wrote:
> On Tue, 10 Mar 2009, Matthew Wilcox wrote:
> > These are the PCI fixes that have been piling up for the last week while
> > Jesse's been on vacation.  I don't think there's anything questionable
> > here.  All the patches have been posted to linux-pci.
> 
> Grrr. It doesn't even compile cleanly:
> 
> drivers/pci/quirks.c: In function ?ht_check_msi_mapping?:
> drivers/pci/quirks.c:2142: warning: ?return? with no value, in function returning non-void
> 
> and yes, it's a real bug.

Agreed, it's a real bug.  I also think it should return 0, but I want
Prakash to verify that, since I don't have a system of this nature.

I wish this warning were an error.  According to the GCC docs,
-Werror=return-type should do this, but it seems to have no effect.

> I'm not happy.

Me neither.  I'm sorry I didn't catch the warning.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
