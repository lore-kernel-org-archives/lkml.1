Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYBQO2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYBQO2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbYBQO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:27:52 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35133 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbYBQO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:27:51 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080217162559.d0b01760.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	 <adalk5np1h5.fsf@cisco.com> <20080215120222.b3263e4a.sfr@canb.auug.org.au>
	 <1203174872.3182.16.camel@localhost.localdomain>
	 <20080217162559.d0b01760.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 08:27:45 -0600
Message-Id: <1203258465.3082.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-17 at 16:25 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> On Sat, 16 Feb 2008 09:14:32 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > Do you have the tree and build logs available anywhere?  I'd like to
> > turn off the merge tree builds when this is able to replace it.
> 
> The tree is at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git - or did
> you mean the logs of creating the tree.

Yes, the logs of creating the tree.

>   I currently ceate the tree
> fairly manually (as I slowly script what can be) and so have no logs of
> that process.

Um, well, I've already pointed to tools that currently do this bit
automatically.  Do you have a list of input trees anywhere?

> The build logs that I have some control over are at
> http://kisskb.ellerman.id.au/kisskb/branch/9/.  I am hoping to expand on
> the arch/config combinations over time (I have to convince my tame cross
> compiler builder :-)).  I also hope that others will build this tree for
> themselves and publish the results.

Oh, OK ... by build I mean combine the trees and quilts into the actual
tree.  Compiling is nice, but it's the tree construction logs I want to
see to make sure there aren't any impending merge problems.  Most people
verify on a fairly constant basis that their own trees actually build.
The only problems we have are edge configurations (like arm and sparc,
which have SCSI drivers that don't build except on those architectures).

James


