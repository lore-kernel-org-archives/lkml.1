Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbXJCKO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbXJCKO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXJCKOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:14:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39560 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751655AbXJCKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:14:51 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <200710022205.05295.nickpiggin@yahoo.com.au>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 12:15:06 +0200
Message-Id: <1191406506.4093.35.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 22:05 +1000, Nick Piggin wrote:
> On Tuesday 02 October 2007 21:40, Peter Zijlstra wrote:
> > On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:
> 
> > > How about adding this information to the tree then, instead of
> > > creating a new top-level hack, just because something that you think
> > > you need doesn't exist.
> >
> > So you suggest adding all the various network filesystems in there
> > (where?), and adding the concept of a BDI, and ensuring all are properly
> > linked together - somehow. Feel free to do so.
> 
> Would something fit better under /sys/fs/? At least filesystems are
> already an existing concept to userspace.

Sounds at least less messy than an new top-level directory.

But again, if it's "device" releated, like the name suggests, it should
be reachable from the device tree.
Which userspace tool is supposed to set these values, and at what time?
An init-script, something at device discovery/setup? If that is is ever
going to be used in a hotplug setup, you really don't want to go look
for directories with magic device names in another disconnected tree.

Kay

