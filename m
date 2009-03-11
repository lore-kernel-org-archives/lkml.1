Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZCKUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZCKUXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZCKUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:23:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbZCKUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:23:31 -0400
Date: Wed, 11 Mar 2009 13:19:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jorge@dti2.net, ext-adrian.hunter@nokia.com, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-Id: <20090311131915.14b8ac71.akpm@linux-foundation.org>
In-Reply-To: <20090311125748.GA14144@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de>
	<20090305100000.GA29177@duck.suse.cz>
	<20090305101637.GB17815@wotan.suse.de>
	<20090305111226.GB29531@duck.suse.cz>
	<20090310134106.GA15977@wotan.suse.de>
	<20090310160321.GB1190@duck.suse.cz>
	<20090311032918.GE16561@wotan.suse.de>
	<20090311122420.GB24590@duck.suse.cz>
	<20090311125748.GA14144@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 13:57:48 +0100
Nick Piggin <npiggin@suse.de> wrote:

> On Wed, Mar 11, 2009 at 01:24:20PM +0100, Jan Kara wrote:
> > On Wed 11-03-09 04:29:18, Nick Piggin wrote:
> > > How about this?
> >   Looks fine to me.
> 
> Thanks for the good review. Andrew, do you think you can apply this
> on top of the previous patch? I'm undecided as to whether they should
> go together or not. Probably the first one is a minimal fix that
> doesn't alter behaviour as much, but things seem more robust after this
> 2nd patch. I think both would probably be suitable for 2.6.29, being a
> nasty bug, but it isn't a recent regression AFAIKS.
> 

How's about we do fs-new-inode-i_state-corruption-fix.patch in 2.6.29
and fs-avoid-i_new-inodes.patch in 2.6.30?  We could backport
fs-avoid-i_new-inodes.patch into 2.6.29.x if needed.

