Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZKKPQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZKKPQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZKKPQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:16:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:37474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbZKKPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:16:12 -0500
Date: Wed, 11 Nov 2009 16:16:16 +0100
From: Jan Blunck <jblunck@suse.de>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, matthew@wil.cx, viro@zeniv.linux.org.uk
Subject: Re: BKL: Remove BKL from Squashfs
Message-ID: <20091111151616.GF21750@bolzano.suse.de>
References: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk> <20091110121511.5adca8a9.akpm@linux-foundation.org> <4AF9D6EE.1070205@lougher.demon.co.uk> <4AF9DD24.8060501@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9DD24.8060501@lougher.demon.co.uk>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, Phillip Lougher wrote:

> Phillip Lougher wrote:
> 
> >This patch was prompted by Jan Blunck's "Push down BKL to the 
> >filesystems" patch
> >series, where he firstly pushes the BKL down to individual filesystems
> >(even if they don't need it) , and then successively removes them
> >(on a one patch per filesystem basis) in later patches.
> >
> >The patch should be reviewed in the context that it is intended for Jan's
> >BKL removal patch series.
> >
> 
> Jan and/or Matthew,
> 
> Can you please ACK this patch, and say whether you're going to
> add it to your BKL patch series? (I'm happy for it to go through
> there, rather than my Squashfs tree).
> 
> After reviewing your patches, it seems to me that the BKL isn't
> needed in Squashfs.  You removed it from 23 filesystems because
> it's not protecting any shared state,  on that basis it isn't needed
> needed in Squashfs either.

Yes, I'll do this through my patch series. I'll rework the series a bit and
will repost it soon.

Thanks,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
