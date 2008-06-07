Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYFGByD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYFGByD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYFGBxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:53:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbYFGBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:53:50 -0400
Date: Fri, 6 Jun 2008 18:52:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 06/25] split LRU lists into anon & file sets
Message-Id: <20080606185248.0b7f53da.akpm@linux-foundation.org>
In-Reply-To: <20080606212231.5a51237c@bree.surriel.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.681500833@redhat.com>
	<20080606180439.e5954a2e.akpm@linux-foundation.org>
	<20080606212231.5a51237c@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 21:22:31 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Fri, 6 Jun 2008 18:04:39 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > The changelogs are a bit scrappy and could do with some care
> > 
> > - stale assertions such as the above
> > 
> > - "From:<random number of spaces>Lee" in various places
> > 
> > - Some have the --- separator and others don't (this trips me up).
> > 
> > - Stuff like "Against: 2.6.26-rc2-mm1" right in the middle of the
> >   changelog for me to hunt down and squish.
> 
> I got rid of all of those - until I merged in Lee's latest :(
> 
> > - "TODO:  DEBUGGING ONLY: NOT FOR UPSTREAM MERGE" <<-- what's up with this?
> 
> I'll remove this one.
> 
> > - random Capitalisation in Various patch Titles.
> > 
> > - "V2 -> V3:" logging in the main changelog - not relevant in the
> >   final commit hence more for me to edit away.
> 
> I got rid of all of those - again, before merging Lee's latest.
> Then I got rid of most of them, but apparently missed a few...

Poeple often maintain that sort of info below the ^--- line.

>
...
>
> > Do we really want to put all this stuff into /proc/meminfo?
> >
> > Would it be better to aggregate it in some manner for meminfo and show
> > the fine-grained info in /proc/vmstat?
> 
> Good question.  I believe we'll want the memory usage statistics
> in /proc/meminfo, but more temporary internal stuff like 
> "writebacktmp" and "nfs_unstable" might not belong there.

Well, I was just asking..  I haven't actually sat down and worked out
what the proposed new meminfo will look like yet.

(It's documented in Documentation/filesystems/proc.txt btw.  Or used
to be ;))
