Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYG2Utu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYG2Utu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYG2Utk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:49:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60166 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYG2Utj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:49:39 -0400
Date: Tue, 29 Jul 2008 21:49:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Greg KH <gregkh@suse.de>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Bernhard Walle <bwalle@suse.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: linux-next: Tree for July 29
In-Reply-To: <20080729181639.GA21311@suse.de>
Message-ID: <Pine.LNX.4.64.0807292145220.28604@blonde.site>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
 <200807291825.14281.bzolnier@gmail.com> <20080729181639.GA21311@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Greg KH wrote:
> On Tue, Jul 29, 2008 at 06:25:14PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 29 July 2008, Stephen Rothwell wrote:
> > > 
> > > Changes since next-20080728:
> > 
> > I keep reverting commit 0e3638d1e04040121af00195f7e4628078246489 ("warn
> > when statically-allocated kobjects are used") with each linux-next release
> > to make it work on my x86_32 laptop (http://lkml.org/lkml/2008/7/19/114).
> > 
> > Depending on the day I either forget to revert it on a first try or (lead by
> > incurable optimism) I don't try to revert it in hope that it was fixed.
> > 
> > Unfortunately the result is always the same cursing-during-qemu-test-run
> > -> git-revert -> recompile cycle and a needless time loss.
> > 
> > Could we have some action taken please?
> 
> What is the problem with this patch that has caused it to suddenly
> keeping the boot from working?  Is the code in the patch warning you of
> objects that are not properly being initialized?
> 
> I'll be glad to fix this if possible.

Isn't this the opposite end of the same problem for which Bernhard
has been repeatedly trying to find a taker for his patch:

http://article.gmane.org/gmane.linux.kernel.kexec/1882

Hugh
