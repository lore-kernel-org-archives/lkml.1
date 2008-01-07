Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYAGKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYAGKDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYAGKDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:03:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47662 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYAGKDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:03:20 -0500
Date: Mon, 7 Jan 2008 19:06:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-Id: <20080107190610.ed3be7b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080103120000.1768f220@cuia.boston.redhat.com>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
	<20080103120000.1768f220@cuia.boston.redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 12:00:00 -0500
Rik van Riel <riel@redhat.com> wrote:

> On Thu, 03 Jan 2008 11:52:08 -0500
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > Also, I should point out that the full noreclaim series includes a
> > couple of other patches NOT posted here by Rik:
> > 
> > 1) treat swap backed pages as nonreclaimable when no swap space is
> > available.  This addresses a problem we've seen in real life, with
> > vmscan spending a lot of time trying to reclaim anon/shmem/tmpfs/...
> > pages only to find that there is no swap space--add_to_swap() fails.
> > Maybe not a problem with Rik's new anon page handling.
> 
> If there is no swap space, my VM code will not bother scanning
> any anon pages.  This has the same effect as moving the pages
> to the no-reclaim list, with the extra benefit of being able to
> resume scanning the anon lists once swap space is freed.
> 
Is this 'avoiding scanning anon if no swap' feature  in this set ?

Thanks
-Kame

