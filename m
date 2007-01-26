Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbXAZLAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbXAZLAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbXAZLAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:00:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbXAZLAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:00:39 -0500
Date: Fri, 26 Jan 2007 03:00:21 -0800
From: Andrew Morton <akpm@osdl.org>
To: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] lumpy reclaim v2
Message-Id: <20070126030021.72fdeef1.akpm@osdl.org>
In-Reply-To: <20061214205734.0e385643.akpm@osdl.org>
References: <exportbomb.1165424343@pinky>
	<6109d33145c0dcf3a8a3a6bd120d7985@pinky>
	<20061214205734.0e385643.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Dec 2006 20:57:34 -0800
Andrew Morton <akpm@osdl.org> wrote:

> On Wed, 6 Dec 2006 16:59:35 +0000
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > +			tmp = __pfn_to_page(pfn);
> 
> ia64 doesn't implement __page_to_pfn.  Why did you not use page_to_pfn()?

Poke.  I'm still a no-compile on ia64.
