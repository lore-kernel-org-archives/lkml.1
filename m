Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYAIEYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYAIEYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYAIEXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:23:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47965 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYAIEXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:23:53 -0500
Date: Wed, 9 Jan 2008 13:26:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 03/19] define page_file_cache() function
Message-Id: <20080109132615.8fbaef05.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080108172856.4196bd4b@bree.surriel.com>
References: <20080108205939.323955454@redhat.com>
	<20080108205959.952424899@redhat.com>
	<Pine.LNX.4.64.0801081414230.4281@schroedinger.engr.sgi.com>
	<20080108172856.4196bd4b@bree.surriel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 17:28:56 -0500
Rik van Riel <riel@redhat.com> wrote:

> On Tue, 8 Jan 2008 14:18:40 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Tue, 8 Jan 2008, Rik van Riel wrote:
> > 
> > > Define page_file_cache() function to answer the question:
> > > 	is page backed by a file?
> > 
> > > +static inline int page_file_cache(struct page *page)
> > > +{
> > > +	if (PageSwapBacked(page))
> > > +		return 0;
> > 
> > Could we call this PageNotFileBacked or so? PageSwapBacked is true for 
> > pages that are RAM based. Its a bit confusing.
> 
> PageNotFileBacked confuses me a little, since shared memory segments live
> in tmpfs and are kinda sorta file backed, but go to swap instead of to a
> filesystem when there is memory pressure.
> 
How about PageIsNotCache() ? :)

When a page is a cache, there is an original data somewhere and can be dropped
out.

Thanks,
-Kame

