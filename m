Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZDWOLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZDWOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZDWOLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:11:07 -0400
Received: from thunk.org ([69.25.196.29]:50057 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbZDWOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:11:05 -0400
Date: Thu, 23 Apr 2009 10:10:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423141006.GH2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Jamie Lokier <jamie@shareable.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Valerie Aurora Henson <vaurora@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu> <49F06381.3090605@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F06381.3090605@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:48:01AM -0400, Jeff Garzik wrote:
> Theodore Tso wrote:
>> So we can create a more finer-grained controlled system call ---
>> although I would suggest that we just add some extra flags to
>> sync_file_range() --- but it's doubtful that many application
>> programmers will use it.
>
> sync_file_range() seems the obvious avenue for new fsync flags.
>
> I even explored what it would take to add a "flush storage dev writeback  
> cache, for this file" flag to sync_file_range(), rather unfortunately  
> non-trivial given the current implementation's close ties to MM.

What I had roughly in mind was some (optional) calls to the filesystem
before and after the current implementations MM magic, but I haven't
thought very deeply on the subject yet, mainly because...

> But yeah...  how many people will use these fancy new flags and features?
>

Yeah.  That issue.

It would be nice to have some additional semantics, but in terms of
priorities, it's not the highest thing on my list in terms of itches
to scratch.

	   					- Ted
