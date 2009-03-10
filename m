Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZCJSTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZCJSTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZCJSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:19:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37908 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZCJSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:19:40 -0400
Date: Tue, 10 Mar 2009 18:19:36 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Theodore Tso <tytso@mit.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090310181936.GD28243@shadowen.org>
References: <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301001829.GA10751@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 07:18:29PM -0500, Theodore Tso wrote:
> On Sun, Mar 01, 2009 at 12:01:38AM +0100, Stefan Richter wrote:
> > > As I have previously said, that is not the case in reality.  There
> > > appears to be substantial sentiment among people handling patches that
> > > not having any text in the body of the e-mail makes it harder to handle
> > > patches.
> > 
> > It is indeed a problem
> >   - if the patch title alone insufficiently describes the patch
> > or
> >   - if a patch reviewer believes that it is OK to ignore patch titles.
> 
> Worse yet, if we start getting these sorts of entries being returned
> by "git log":
> 
> ------------
> ext4: Fix spelling error: successfull
> 
> Fix spelling error: successfull
> 
> Signed-off-by: "Trivial Patch Submitter" <spelling@nits.org>
> ------------
> 
> Just to shut up checkpatch, I'm going to feel the urge to shake a
> checkpatch maintainer warmly by the throat.
> 
> Sometimes, all that is needed is:
> 
> ------------
> ext4: Fix spelling error: successfull
> 
> Signed-off-by: "Trivial Patch Submitter" <spelling@nits.org>
> ------------

Not wanting my throat felt warmly, and as there does not seem to be
a sensible way to detect poor changelogs I am not propsing to make any
change to checkpatch on this one.

-apw
