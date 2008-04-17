Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYDQGvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYDQGvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYDQGvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:51:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57941 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYDQGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:51:11 -0400
Date: Thu, 17 Apr 2008 15:55:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-mm@kvack.org, npiggin@suse.de,
       y-goto@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Warning on memory offline (possible in migration ?)
Message-Id: <20080417155557.a08cbde5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416234303.c6003c08.akpm@linux-foundation.org>
References: <20080414145806.c921c927.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804141044030.6296@schroedinger.engr.sgi.com>
	<20080416200036.2ea9b5c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20080416113642.8ffd5684.akpm@linux-foundation.org>
	<20080417091930.cbac6286.kamezawa.hiroyu@jp.fujitsu.com>
	<20080417153818.d40ddfd8.kamezawa.hiroyu@jp.fujitsu.com>
	<20080416234303.c6003c08.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 23:43:03 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 17 Apr 2008 15:38:18 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 17 Apr 2008 09:19:30 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > I'd expect that you could reproduce this by disabling readahead with
> > > > fadvise(POSIX_FADV_RANDOM) and then issuing the above four reads.
> > > > 
> > > Thank you for advice. I'll try.
> > > 
> > (Added lkml to CC:)
> > 
> > What happens:
> >   When I do memory offline on ia64/NUMA box, __set_page_dirty_buffers() printed
> >   out WARNINGS because the page under migration is not up-to-date.
> 
> The warning is in __set_page_dirty().
> 
Sorry, __set_page_dirty() in fs/buffer.c 

Thanks,
-Kame

