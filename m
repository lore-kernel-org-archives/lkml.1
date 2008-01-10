Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYAJIbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYAJIbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYAJIbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:31:35 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27869 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYAJIbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:31:34 -0500
Date: Thu, 10 Jan 2008 09:31:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110083130.GP6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080109231628.GB4039@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109231628.GB4039@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09 2008, Alasdair G Kergon wrote:
> Here's the latest version of dm-loop, for comparison.
> 
> To try it out, 
>   ln -s dmsetup dmlosetup
> and supply similar basic parameters to losetup.
> (using dmsetup version 1.02.11 or higher)

Why oh why does dm always insist to reinvent everything? That's bad
enough in itself, but on top of that most of the extra stuff ends up
being essentially unmaintained.

If we instead improve loop, everyone wins.

Sorry to sound a bit harsh, but sometimes it doesn't hurt to think a bit
outside your own sandbox.

-- 
Jens Axboe

