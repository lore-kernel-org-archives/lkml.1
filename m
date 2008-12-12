Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYLLDCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYLLDCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYLLDC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:02:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbYLLDC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:02:28 -0500
Date: Thu, 11 Dec 2008 19:02:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-Id: <20081211190225.0de48422.akpm@linux-foundation.org>
In-Reply-To: <200812111945.53399.nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<200812111857.36862.nickpiggin@yahoo.com.au>
	<20081211000730.2e0334d0.akpm@linux-foundation.org>
	<200812111945.53399.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 19:45:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > I still have one fix for a reported regression (softlink code doesn't
> > > honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
> > > ago, but it didn't get anywhere.
> >
> > I don't have a clue what you're talking about.
> >
> > <greps the tree>
> >
> > ./fs/affs/inode.c:      case ST_SOFTLINK:
> > ./fs/affs/namei.c:      error = affs_add_entry(dir, inode, dentry,
> > ST_SOFTLINK); ./include/linux/amigaffs.h:#define ST_SOFTLINK  3
> >
> > really?
> 
> Oh, I thought I cc'ed you...
> 
> http://marc.info/?l=linux-fsdevel&m=122777850302085&w=2
> http://marc.info/?l=linux-fsdevel&m=122777852502093&w=2

yes, but that stuff went round and round in circles and ended up all in
the air.

