Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYAKPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYAKPm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbYAKPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:42:53 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3044 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784AbYAKPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:42:52 -0500
Subject: Re: [patch 10/19] No Reclaim LRU Infrastructure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080111133048.FD5C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	 <20080108210008.383114457@redhat.com>
	 <20080111133048.FD5C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 11 Jan 2008 10:43:43 -0500
Message-Id: <1200066224.5304.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 13:36 +0900, KOSAKI Motohiro wrote:
> Hi Rik
> 
> > +config NORECLAIM
> > +	bool "Track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > +	depends on EXPERIMENTAL && 64BIT
> > +	help
> > +	  Supports tracking of non-reclaimable pages off the [in]active lists
> > +	  to avoid excessive reclaim overhead on large memory systems.  Pages
> > +	  may be non-reclaimable because:  they are locked into memory, they
> > +	  are anonymous pages for which no swap space exists, or they are anon
> > +	  pages that are expensive to unmap [long anon_vma "related vma" list.]
> 
> Why do you select to default is NO ?
> I think this is really improvement and no one of 64bit user
> hope turn off without NORECLAIM developer :)
> 

Hello, Kosaki-san:

This was my doing.  I left the default == NO during
development/experimemental stage so that one would have to take explicit
action to enable this function.  If the feature makes it into mainline
and we decide that the default should be 'yes', that will be an easy
change.

Thanks for looking at this,
Lee Schermerhorn

