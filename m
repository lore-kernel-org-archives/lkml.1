Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbYFKRlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbYFKRlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbYFKRlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:41:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYFKRlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:41:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
	<x491w359fne.fsf@segfault.boston.devel.redhat.com>
	<yq1r6b4mx9y.fsf@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 11 Jun 2008 13:41:41 -0400
In-Reply-To: <yq1r6b4mx9y.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Wed, 11 Jun 2008 00:05:29 -0400")
Message-ID: <x491w3398dm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
> Jeff> Hmm, up until this point you use bi to mean bio_integrity, but
> Jeff> now it means blk_integrity.  Confusion will ensue.  ;)
>
> Err, uhm.  There is no bio_integrity.  There's the bio integrity
> payload which I always refer to as struct bip *bip.  And struct
> blk_integrity which is always bi.  I'm also anal about using bv for
> the data bio_vec and iv for the integrity bio_vec.  I can't see any
> place where I'm inconsistent.

Wow, I have no idea where I got that impression.  Sorry!

> Jeff> struct blk_integrity_exchg is not yet defined in your patch set,
> Jeff> so this will likely break git bisect.
>
> bio-integrity.patch and blk-integrity.patch are artificially split up
> to ease the review process.  They are not meant to be separate
> changesets.

OK, just wanted to make sure you were aware of it.

Cheers,

Jeff
