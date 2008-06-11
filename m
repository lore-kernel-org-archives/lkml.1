Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYFKUcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYFKUcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYFKUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:32:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYFKUck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:32:40 -0400
Date: Wed, 11 Jun 2008 16:32:30 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Message-ID: <20080611163230.30bd9f84@bree.surriel.com>
In-Reply-To: <1213216083.6436.66.camel@lts-notebook>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.493423475@redhat.com>
	<20080611130145.2a202339.akpm@linux-foundation.org>
	<1213216083.6436.66.camel@lts-notebook>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 16:28:03 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> On Wed, 2008-06-11 at 13:01 -0700, Andrew Morton wrote:
> > On Wed, 11 Jun 2008 14:42:25 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> > 
> > > Define proper false/noop inline functions for noreclaim page
> > > flags when !defined(CONFIG_NORECLAIM_LRU)
> > 
> > I changed that to CONFIG_UNEVICTABLE_LRU.
> 
> I noticed that the vmstat items [perhaps these will go away] still use
> "noreclaim".

$ cat /proc/vmstat
nr_free_pages 3887198
nr_inactive_anon 5043
nr_active_anon 2182
nr_inactive_file 67121
nr_active_file 49045
nr_unevictable 0
nr_mlock 0

Or am I looking at the wrong thing?

-- 
All rights reversed.
