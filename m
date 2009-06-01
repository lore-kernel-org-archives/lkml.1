Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZFAFdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZFAFdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZFAFdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:33:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZFAFdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:33:16 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Mon, 1 Jun 2009 15:33:07 +1000 (EST)
Message-ID: <39efa6d3788eec04b0bc86b02d988c8f.squirrel@neil.brown.name>
In-Reply-To: <yq163fga654.fsf@sermon.lab.mkp.net>
References: <20090525153346.758483fc.sfr@canb.auug.org.au>
    <20090525061552.GH11363@kernel.dk>
    <20090601144218.26810ec8.sfr@canb.auug.org.au>
    <yq163fga654.fsf@sermon.lab.mkp.net>
Subject: Re: linux-next: md tree build failure
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Jens Axboe" <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "raz ben yehuda" <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, June 1, 2009 3:13 pm, Martin K. Petersen wrote:
>>>>>> "Stephen" == Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
>>> > Caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 ("block:
>>> > Do away with the notion of hardsect_size") from the block tree
>>> > interacting with commit 131e4477401ae76a9cbe8539e4b7819e04cfba36
>>> > ("md: raid0: chunk size check in raid0_run") from the md tree.
>
> Stephen> So, is anything happening about these?  I still get these (and
> Stephen> the dm) build failures.
>
> There's a replacement DM patch kit brewing that will hopefully come your
> way shortly.  It replaces the patches currently in Alasdair's tree.
> Mike sent the kit out for review last week and I'm currently testing it.
>
>
> I don't know what Neil's plans are.  Neil: Do you want to rebase your
> tree, fix up the conflicting patches or how would you like to handle
> this?

I'm happy to rebase on something if you have a tree that doesn't have too
much more than the changes that are causing conflicts.
Then I'll fix my patches so they work on that tree.

What should I pull??

NeilBrown

