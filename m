Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZDWLVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZDWLVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZDWLVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:21:11 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39186 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbZDWLVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:21:10 -0400
Date: Thu, 23 Apr 2009 12:21:05 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valerie Aurora Henson <vaurora@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423112105.GA1589@shareable.org>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422221748.8c9022d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Would it be better to implement new syscall(s) with finer-grained control
> and better semantics?  Then userspace would just need to to:
> 
> 	fsync_on_steroids(fd, FSYNC_BEFORE_RENAME);
> 
> and that all gets down into the filesystem which can then work out what
> it needs to do to implement the command.

+1 from me.  Several flags come to mind for discussion.
FSYNC_HARDWARE.  FSYNC_ORDER_ONLY, FSYNC_FLUSH.
FSYNC_DATA_BEFORE_SIZE.  FSYNC_BEFORE_NEW_FILE.

Nick Piggin was working on  fsync_range().

Maybe it's time to do fsync properly?

-- Jamie
