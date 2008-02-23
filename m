Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbYBWJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbYBWJK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYBWJKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:10:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48679 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbYBWJKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:10:03 -0500
Date: Sat, 23 Feb 2008 10:10:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
Message-ID: <20080223091013.GB12161@uranus.ravnborg.org>
References: <200802221837.37680.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221837.37680.chase.venters@clientec.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:37:14PM -0600, Chase Venters wrote:
> I've been making myself more familiar with git lately and I'm curious what 
> habits others have adopted. (I know there are a few documents in circulation 
> that deal with using git to work on the kernel but I don't think this has 
> been specifically covered).
> 
> My question is: If you're working on multiple things at once, do you tend to 
> clone the entire repository repeatedly into a series of separate working 
> directories and do your work there, then pull that work (possibly comprising 
> a series of "temporary" commits) back into a separate local master 
> respository with --squash, either into "master" or into a branch containing 
> the new feature?

The simple (for me) workflow I use is to create a clone of the
kernel for each 'topic' I work on.
So at the same time I may have one or maybe up to five clones of the
kernel.

When I want to combine thing I use git format-patch and git am.
Often there is some amount of editing done before combining stuff
especially for larger changes where the first in the serie is often
preparational work that were identified in random order when I did
the inital work.

	Sam
