Return-Path: <linux-kernel-owner+w=401wt.eu-S1161144AbXAZSWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161144AbXAZSWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXAZSWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:22:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60293 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161144AbXAZSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:22:20 -0500
Date: Sat, 27 Jan 2007 03:21:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Cc: clameter@sgi.com, nickpiggin@yahoo.com.au, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
Message-Id: <20070127032133.4368e2cb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070126101027.90bf3e63.akpm@osdl.org>
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
	<45B9A00C.4040701@yahoo.com.au>
	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
	<20070126031300.59f75b06.akpm@osdl.org>
	<Pine.LNX.4.64.0701260742340.6141@schroedinger.engr.sgi.com>
	<20070126101027.90bf3e63.akpm@osdl.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 10:10:27 -0800
Andrew Morton <akpm@osdl.org> wrote:

> On Fri, 26 Jan 2007 07:44:42 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Fri, 26 Jan 2007, Andrew Morton wrote:
> > 
> > > > > > Track mlocked pages via a ZVC
> > > 
> > > Why?
> > 
> > Large amounts of mlocked pages may be a problem for 
> > 
> > 1. Reclaim behavior.
> > 
> > 2. Defragmentation
> > 
> 
> We know that.  What has that to do with this patch?
> 
3. just counting mlocked pages....

I have an experience that I was asked by the user to calculate "free" pages
on the system where several big 'mlockall' process runs, which shared amounts of
pages...when I answered the user cannot trust the result of "/bin/free" 
if you use mlock processes.

It was very fun :P

-Kame

