Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbZACUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbZACUSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbZACUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:18:34 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47478 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbZACUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:18:33 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <20090103195034.GA27541@infradead.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <20090103195034.GA27541@infradead.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:17:36 -0500
Message-Id: <1231013856.7538.89.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.495FC7E9.015C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 14:50 -0500, Christoph Hellwig wrote:
> On Sat, Jan 03, 2009 at 12:17:06PM -0700, Matthew Wilcox wrote:
>  
> > > - compat.h needs to go
> > 
> > Later.  It's still there for XFS.
> 
> ?

> > > - there should be manpages for all the ioctls and other interfaces.
> > 
> > I wonder if Michael Kerrisk has time to help with that.  Cc'd.
> 
> Actually a lot of the ioctl API don't just need documentation but
> a complete redo.  That's true at least for the physical device
> management and subvolume / snaphot ones.
> 

The ioctl interface is definitely not finalized.  Adding more vs
replacing the existing ones is an open question.

> > > - various checkpath.pl level problems I think (e.g. printk levels) 
> > 
> > Can be fixed up later.
> > 
> > > - the printks should all include which file system they refer to
> > 
> > Ditto.
> 
> >From painfull experience with a lot of things, including a filesystem
> you keep on mentioning it's clear that once stuff is upstream there
> is very little to no incentive to fix these things up.
> 

I'd disagree here.  Cleanup incentive is a mixture of the people
involved and the attention the project has.

-chris


