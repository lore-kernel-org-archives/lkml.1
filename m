Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYAJMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYAJMtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYAJMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:49:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:30067 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYAJMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:49:07 -0500
Date: Thu, 10 Jan 2008 07:47:38 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110074738.6be1c1ad@think.oraclecorp.com>
In-Reply-To: <20080110083130.GP6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk>
	<20080109231628.GB4039@agk.fab.redhat.com>
	<20080110083130.GP6258@kernel.dk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 09:31:31 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Jan 09 2008, Alasdair G Kergon wrote:
> > Here's the latest version of dm-loop, for comparison.
> > 
> > To try it out, 
> >   ln -s dmsetup dmlosetup
> > and supply similar basic parameters to losetup.
> > (using dmsetup version 1.02.11 or higher)
> 
> Why oh why does dm always insist to reinvent everything? That's bad
> enough in itself, but on top of that most of the extra stuff ends up
> being essentially unmaintained.

I don't quite get how the dm version is reinventing things.  They use
the dmsetup command that they use for everything else and provide a
small and fairly clean module for bio specific loop instead of piling
it onto loop.c....

Their code doesn't have the fancy hole handling that yours does, but
neither did yours 4 days ago ;)

> 
> If we instead improve loop, everyone wins.
> 
> Sorry to sound a bit harsh, but sometimes it doesn't hurt to think a
> bit outside your own sandbox.
> 

It is a natural fit in either place, as both loop and dm have a good
infrastructure for it.  I'm not picky about where it ends up, but dm
wouldn't be a bad place.

-chris
