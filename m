Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZBRSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZBRSY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZBRSYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:24:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbZBRSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:24:16 -0500
Date: Wed, 18 Feb 2009 10:23:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>, peterz@infradead.org,
       rmh3093@gmail.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [patch 1/2] vfs: add/use update_page_accounting
Message-Id: <20090218102314.15a0b0c6.akpm@linux-foundation.org>
In-Reply-To: <20090218140626.GA13362@wotan.suse.de>
References: <1234530519.6519.46.camel@twins>
	<49957C43.7050701@gmail.com>
	<1234534150.6519.101.camel@twins>
	<18838.49922.215481.399653@edward.zelnet.ru>
	<1234645893.4695.8.camel@laptop>
	<18841.60432.329341.514726@edward.zelnet.ru>
	<20090217143506.f6899342.akpm@linux-foundation.org>
	<499B55A8.50103@gmail.com>
	<20090217163820.48a2ce68.akpm@linux-foundation.org>
	<18844.3238.965571.619560@edward.zelnet.ru>
	<20090218140626.GA13362@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 15:06:26 +0100 Nick Piggin <npiggin@suse.de> wrote:

> On Wed, Feb 18, 2009 at 04:27:02PM +0300, Edward Shishkin wrote:
> >  > > Maybe it makes sense to add comments with warnings
> >  > > in all such places, or create a header file with a static inline
> >  > > function update_page_accounting() ?
> >  > 
> >  > Could just uninline the helper function I guess - if you look, those
> >  > four statements already involve doing a heck of a lot of stuff.
> >  > 
> >  > Try it, see how it looks?
> >  > 
> > 
> > Done.
> > Please, review.
> > 
> > Add/use a helper function update_page_accounting().
> 
> Fine patch, except the name I don't like. account_set_page_dirty, or
> account_page_dirtied, or something to hint it is for accounting
> dirty.

yep, sorry, I didn't think too hard about that for-example.

I'll edit the diffs..
