Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZCBSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZCBSg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZCBSgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:36:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbZCBSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:36:17 -0500
Date: Mon, 2 Mar 2009 10:34:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Theodore Tso <tytso@mit.edu>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-Id: <20090302103437.f3109332.akpm@linux-foundation.org>
In-Reply-To: <20090302182456.GF19744@sirena.org.uk>
References: <20090228175218.GA4606@sirena.org.uk>
	<49A98F93.5030206@s5r6.in-berlin.de>
	<20090228210223.GA23191@sirena.org.uk>
	<49A9C252.50204@s5r6.in-berlin.de>
	<20090301001829.GA10751@mit.edu>
	<20090301004618.GA12909@sirena.org.uk>
	<20090301025357.GC10751@mit.edu>
	<20090302131514.GC19744@sirena.org.uk>
	<49ABF825.1010501@s5r6.in-berlin.de>
	<20090302100158.bb83bec6.akpm@linux-foundation.org>
	<20090302182456.GF19744@sirena.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 18:24:57 +0000 Mark Brown <broonie@sirena.org.uk> wrote:

> On Mon, Mar 02, 2009 at 10:01:58AM -0800, Andrew Morton wrote:
> 
> > I think what triggered this was a patch from Mark which had no
> > changelog and which had me sitting there wondering wtf it does, whether
> > we need it in 2.6.29, whether we need it in 2.6.28.x and earlier and me
> > not having the foggiest clue then getting grumpy.
> 
> Do you mean no changelog in the body of the e-mail here?  I'm assuming
> now that you mean no changelog in the body but when you say "no
> changelog" that reads differently.  I'm not saying the changelog was
> perfect here but your comments really do read like you felt there was
> nothing at all.


The text covering a patch should describe what the patch does, why it
does it, how it does it and it should describe the end-user effects of
not having the patch present.  Any and all of these can be skipped if
they are utterly obvious and unneeded.

Changes should be properly described, that's all.  The means by which
that is done isn't terribly important.  Sometimes most of the
description is in code comments, or in a newly-added Documentation/
file.

The reason I asked you personally to always send a changelog is because
I quite frequently sit there scratching my head at your patches not
having a clue what they do nor how to prioritise them.
