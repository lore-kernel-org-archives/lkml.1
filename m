Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYJBRHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYJBRHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYJBRHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:07:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54721 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYJBRHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:07:30 -0400
Date: Thu, 2 Oct 2008 19:07:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: neilb@suse.de, agk@sourceware.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH 5/7] block: Find bio sector offset given idx and offset
Message-ID: <20081002170709.GM19428@kernel.dk>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com> <1222846723-18213-6-git-send-email-martin.petersen@oracle.com> <20081001081056.GB19428@kernel.dk> <yq163obiuoi.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq163obiuoi.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01 2008, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> Too may BUG's there, me thinks, and the interface looks
> Jens> fragile. What if the bio is alreday done (bi_idx == bi_vcnt)?
> 
> Good point!  Obviously I've only used the function for bio splitting
> and not at completion time.  Updated patch below.
> 
> 
> block: Find bio sector offset given idx and offset
> 
> Helper function to find the sector offset in a bio given bvec index
> and page offset.

Looks good, I've applied patches 1-5.

-- 
Jens Axboe

