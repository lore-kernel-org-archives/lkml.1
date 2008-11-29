Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYK2S1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYK2S1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYK2S04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:26:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbYK2S0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:26:55 -0500
Date: Sat, 29 Nov 2008 10:26:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-Id: <20081129102608.f8228afd.akpm@linux-foundation.org>
In-Reply-To: <493182C8.1080303@redhat.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
	<20081128231933.8daef193.akpm@linux-foundation.org>
	<4931721D.7010001@redhat.com>
	<20081129094537.a224098a.akpm@linux-foundation.org>
	<493182C8.1080303@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 12:58:32 -0500 Rik van Riel <riel@redhat.com> wrote:

> > Will this new patch reintroduce the problem which
> > 26e4931632352e3c95a61edac22d12ebb72038fe fixed?
> 
> Googling on 26e4931632352e3c95a61edac22d12ebb72038fe only finds
> your emails with that commit id in it - which git tree do I
> need to search to get that changeset?

It's the historical git tree.  All the pre-2.6.12 history which was
migrated from bitkeeper.  

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git

Spending a couple of fun hours reading `git-log mm/vmscan.c' is pretty
instructive.  For some reason that command generates rather a lot of
unrelated changelog info which needs to be manually skipped over.
