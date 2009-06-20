Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZFTS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZFTS2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZFTS2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:28:32 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:35223 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZFTS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:28:31 -0400
Date: Sat, 20 Jun 2009 14:27:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfi-devel@simplefirmware.org
Subject: Re: linux-next: Tree for June 19
In-reply-to: <20090620150433.4e038676.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0906201415400.4083@localhost.localdomain>
References: <20090619172622.05adb236.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0906200012200.4325@localhost.localdomain>
 <20090620150433.4e038676.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 20 Jun 2009 00:16:49 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
> >
> > Please add the Simple Firmware Interface "sfi-test" branch to linux-next:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git sfi-test
> 
> Is this 2.6.31 or 32 material?

yes:-)

Most that is in in sfi-test at this moment I hope to catch .31.
There will be much more in .32 -- mostly things that depend on
the first batch...

> > A description of the project is on the SFI home page: http://simplefirmware.org/
> > 
> > Note: like ACPI's test branch, this branch will be occasionally re-based
> > as the patches in it evolve.
> 
> That's fine.
> 
> Should I put just you as the contact, or add the mailing list as well?

The mailing list is fine (on cc), and I'm on that.
It is redundant to send to both.

> What I tell everyone: all patches/commits in the tree/series must
> have been:
> 
> 	posted to a relevant mailing list
> 	reviewed
> 	unit tested
> 	destined for the next merge window (or the current release)
> 
> *before* they are included.  The linux-next tree is for integration
> testing and to lower the impact of conflicts between subsystems in the
> next merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.

The patches are tested on the pre-release platform that
makes use of them.  There have been several internal reviews
and re-writes, but since we just got permission to release the
patches last week, they've not been publically vetted yet.

The content is quite close to what I plan to propose for upstream,
but the format is not.  I'll be re-factoring the series into
"clean history" and senting them to LKML on Sunday night.

I don't expect much comment on the generic part,
but will want x86 maintainers to buy into the
parts that touch their architecture.

thanks,
-Len Brown, Intel Open Source Technology Center

