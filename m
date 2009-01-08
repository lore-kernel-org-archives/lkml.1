Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZAHIjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZAHIjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZAHIjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:39:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36089 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZAHIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:39:31 -0500
To: nickpiggin@yahoo.com.au
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       konishi.ryusuke@lab.ntt.co.jp
In-reply-to: <200901071321.43068.nickpiggin@yahoo.com.au> (message from Nick
	Piggin on Wed, 7 Jan 2009 13:21:42 +1100)
Subject: Re: 2.6.29 -mm merge plans
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106152829.43dab4a0.akpm@linux-foundation.org> <200901071321.43068.nickpiggin@yahoo.com.au>
Message-Id: <E1LKqPt-000287-U3@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Jan 2009 09:39:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Nick Piggin wrote:
> I don't know how stable fuse APIs are (ie. whether we'd just be handing the
> anchors to FUSE), but if it is very stable, then it would be nice to push a
> lot of them out of the kernel (although OTOH the old ones tend not to have
> complex interactions with mm or block layer).

Fuse APIs are very stable, so pushing old filesystems out to userspace
makes sense.  Porting them, however, is not entirely trivial.  Amit
Singh (of MacFUSE) got minix, ufs and sysvfs to work on OSX using only
lightly modified linux source code.  That framework could probably be
used to port other filesystems to userspace.

Miklos
