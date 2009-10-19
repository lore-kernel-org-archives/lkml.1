Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZJSPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZJSPr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZJSPr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:47:27 -0400
Received: from mail.perches.com ([173.55.12.10]:2257 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZJSPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:47:27 -0400
Subject: Re: [PATCH 1/3] scripts/get_maintainer.pl: Add patch/file search
 for keywords
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20091019094101.GB3414@pengutronix.de>
References: <cover.1255153863.git.joe@perches.com>
	 <73a375fb516cc420fcff9a0489e29a5509fbf34e.1255153863.git.joe@perches.com>
	 <20091019094101.GB3414@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Oct 2009 08:47:30 -0700
Message-Id: <1255967250.24167.621.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 11:41 +0200, Wolfram Sang wrote:
> > @@ -149,6 +153,8 @@ while (<MAINT>) {
> >  	    if ((-d $value)) {
> >  		$value =~ s@([^/])$@$1/@;
> >  	    }
> > +	} elsif ($type eq "K") {
> > +	    $keyword_hash{@typevalue} = $value;
> 
> It matches the way how the current implementation works, but I guess somewhen
> this @typevalue-array should be converted into a hash like
>	$types{$type} = $value;
> or similar unless I missed something.

I think you missed something.

What this is doing is saving the typevalue index of the
section where the keyword is specified.  That index is
used on the type match to add maintainers.

> Maybe the file should be read completely to save the loop.

I see if that matters.

> A bit unrelated: I noticed that lkml gets always added due to "F: *". Maybe
> this list should be skipped if there has been another mailing list found?

I think that get_maintainers is generally used by people
that aren't already sure who should get an email about 
a patch or file.  I think lkml should be cc'd in almost
every case when someone is not already sure where to
send something.

cheers, Joe

