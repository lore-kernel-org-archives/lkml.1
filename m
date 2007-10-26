Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbXJZPWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbXJZPWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXJZPWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:22:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60814 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbXJZPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:22:31 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193411451.2431.13.camel@lov.site>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 17:22:27 +0200
Message-Id: <1193412147.27652.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 17:10 +0200, Kay Sievers wrote:
> On Fri, 2007-10-26 at 16:48 +0200, Peter Zijlstra wrote:
> 
> > I appreciate the sysfs people their opinion that /sys/bdi/ might not be the
> > best from their POV, however I'm not seeing where to hook the BDI object from
> > so that it all makes sense, a few of the things are currently not exposed in
> > sysfs at all, like the NFS and FUSE things.
> 
> What happended to the idea to create a "bdi" class, and have the
> existing devices as parents, and for stuff that is not (not now, or
> never) in sysfs, no parent is set.

Must have forgotten about that, mainly because I'm not sure I fully
understand it.

So we create a class, create these objects, which are all called bdi and
have children with these attributes in it.

Now, I supposed there is a directory that lists all unparented thingies,
how do I locate the one that matches my nfs mount?



