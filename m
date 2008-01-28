Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYA1DPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYA1DPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 22:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYA1DPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 22:15:08 -0500
Received: from mail.fieldses.org ([66.93.2.214]:44410 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYA1DPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 22:15:07 -0500
Date: Sun, 27 Jan 2008 22:15:02 -0500
To: Simon Holm =?utf-8?Q?Th=C3=B8gersen?= <odie@cs.aau.dk>
Cc: Tom Tucker <tom@opengridcomputing.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: nfs server patches for 2.6.25
Message-ID: <20080128031502.GB22503@fieldses.org>
References: <20080125231521.GG25141@fieldses.org> <1201466543.5006.21.camel@odie.local> <20080127221017.GC597@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127221017.GC597@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 05:10:17PM -0500, bfields wrote:
> OK.  I've got a machine running
> 
> 	for c in $(git rev-list origin..linux-nfs/nfs-server-stable^); do
> 		git checkout $c
> 		make -s -j4
> 	done
> 
> now just to make sure....  Thanks again!

Pfft, that should have been:

	for c in $(git rev-list --reverse origin..linux-nfs/nfs-server-stable^); do
		git checkout $c
		make -s -j4
	done

The results are a lot easier to understand if you do the compiles
in chronological order!

Anyway, that found one more compile failure, now fixed.  Hopefully
that's the last.  (Probably I did an incomplete job of reordering one of
the patches the other week....)

--b.
