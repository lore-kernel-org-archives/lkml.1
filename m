Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZAWElf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZAWElf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 23:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZAWEl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 23:41:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34483 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZAWElZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 23:41:25 -0500
Date: Fri, 23 Jan 2009 05:56:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090123045646.GK15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122203248.GA20159@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:32:49PM -0500, Christoph Hellwig wrote:
> On Thu, Jan 22, 2009 at 06:51:04AM -0800, Andrew Morton wrote:
> > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
> > straightforwad.  But it's really really sad.  It basically leaves a great
> > big FIXME in there.  It'd be better to fix it.
> 
> 
> Umm, we've been discussiong this in and out a guestimated million times.
> 
> Let's go forward with Jon's patch which is on obvious improvement and
> if it shows problems later on we can revisit it.

The point was that we already have a better patch from Oleg.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
