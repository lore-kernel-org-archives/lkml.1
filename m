Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZDWQ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZDWQ2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZDWQ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:27:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZDWQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:27:51 -0400
Date: Thu, 23 Apr 2009 11:49:59 -0400
From: Valerie Aurora Henson <vaurora@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Eric Sandeen <sandeen@redhat.com>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423154959.GE8476@shell>
References: <20090423001257.GA16540@shell> <20090423111147.GC4833@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423111147.GC4833@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 07:11:47AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 22, 2009 at 08:12:57PM -0400, Valerie Aurora Henson wrote:
> > In the default mode for ext3 and btrfs, fsync() is both slow and
> > unnecessary for some important application use cases - at the same
> > time that it is absolutely required for correctness for other modes of
> > ext3, ext4, XFS, etc.  If applications could easilyl distinguish
> > between the two cases, they would be more likely to be correct and
> > fast.
> > 
> > How about an fpathconf() variable, something like _PC_ORDERED?  E.g.:
> 
> Before we add any new fpathconf varibale we need a reall (f)pathconf(at)
> syscall so that the fs driver can exposed it's characteristics, having
> to replicate that information to glibc especially for something required
> for data integrity is a receipe for a desaster.

I think a real pathconf() is a great idea, regardless of the solution
for this exact problem.  Anyone want to beat me to the patch?  I
really need to be working on union mounts right now.

-VAL
