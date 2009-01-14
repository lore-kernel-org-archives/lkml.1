Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZANOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZANOga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761433AbZANOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:36:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59984 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756265AbZANOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:36:13 -0500
Date: Wed, 14 Jan 2009 09:34:55 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114143455.GE6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>, sandeen@redhat.com
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114140802.GC30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114140802.GC30821@kernel.dk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:08:04PM +0100, Jens Axboe wrote:
> 
> It also guarentees that when you get a completion for that barrier
> write, it's on safe storage. Think of it as a flush-write-flush
> operation, in the presence of write back caching.
> 

Is that true even if the barrier isn't attached to a write operation,
i.e., when using

      blkdev_issue_flush(sb, NULL);

?

					- Ted
