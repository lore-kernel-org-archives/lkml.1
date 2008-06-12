Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYFLTGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYFLTGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYFLTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:06:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbYFLTGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:06:10 -0400
Date: Thu, 12 Jun 2008 15:05:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] undo the brd.c part of
 ramfs-and-ram-disk-pages-are-unevictable.patch
Message-ID: <20080612150558.5c8e92a4@cuia.bos.redhat.com>
In-Reply-To: <1213297257.6240.15.camel@lts-notebook>
References: <20080612135353.2d17436a@cuia.bos.redhat.com>
	<1213297257.6240.15.camel@lts-notebook>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 15:00:57 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Thu, 2008-06-12 at 13:53 -0400, Rik van Riel wrote:
> > Undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch.
> > The brd pages do not live on the LRU at all, so there is no need to
> > play these tricks.
> 
> Does this mean that these pages cannot be migrated?  E.g., to evacuate
> memory for hotplug?  Looks like all paths to migrate_pages() construct a
> list of pages to migrate by isolating them from the lru
> [isolate_lru_page()].  Any pages not found in the lru are skipped.

It looks like that, indeed.

-- 
All Rights Reversed
