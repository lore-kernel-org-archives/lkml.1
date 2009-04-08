Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbZDHP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbZDHP0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763466AbZDHPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:25:55 -0400
Received: from thunk.org ([69.25.196.29]:47143 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbZDHPZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:25:54 -0400
Date: Wed, 8 Apr 2009 11:25:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Message-ID: <20090408152541.GA14895@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
References: <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu> <20090408055853.GJ5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408055853.GJ5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 07:58:54AM +0200, Jens Axboe wrote:
> 
> I'm not even sure what is documented about this sort of thing in biodoc,
> but it's actually somewhat outside the realm of block layer
> documentation. The block layer should document that you need to call
> unplug if you are going to be waiting for that IO. How the vm code does
> it is implementation detail mostly, the important thing is that it gets
> done :-)

Fair enough; I agree a lot of the problem is the page writeback
subsystem isn't well documented at all, and is crying out for a review
for possible refactorization and cleanup....

						- Ted
