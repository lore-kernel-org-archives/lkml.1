Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbYG2Ueo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbYG2Ueo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYG2Ueg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:34:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYG2Ueg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:34:36 -0400
Date: Tue, 29 Jul 2008 11:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: linux-next: Tree for July 29
Message-ID: <20080729181639.GA21311@suse.de>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au> <200807291825.14281.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807291825.14281.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 06:25:14PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday 29 July 2008, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since next-20080728:
> 
> I keep reverting commit 0e3638d1e04040121af00195f7e4628078246489 ("warn
> when statically-allocated kobjects are used") with each linux-next release
> to make it work on my x86_32 laptop (http://lkml.org/lkml/2008/7/19/114).
> 
> Depending on the day I either forget to revert it on a first try or (lead by
> incurable optimism) I don't try to revert it in hope that it was fixed.
> 
> Unfortunately the result is always the same cursing-during-qemu-test-run
> -> git-revert -> recompile cycle and a needless time loss.
> 
> Could we have some action taken please?

What is the problem with this patch that has caused it to suddenly
keeping the boot from working?  Is the code in the patch warning you of
objects that are not properly being initialized?

I'll be glad to fix this if possible.

thanks,

greg k-h
