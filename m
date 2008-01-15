Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYAOAG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYAOAG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYAOAGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:06:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59236 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYAOAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:06:47 -0500
Date: Tue, 15 Jan 2008 09:06:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 10/19] No Reclaim LRU Infrastructure
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1200066224.5304.6.camel@localhost>
References: <20080111133048.FD5C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1200066224.5304.6.camel@localhost>
Message-Id: <20080115085931.116D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee-san

> > > +config NORECLAIM
> > > +	bool "Track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > > +	depends on EXPERIMENTAL && 64BIT
> > > +	help
> > > +	  Supports tracking of non-reclaimable pages off the [in]active lists
> > > +	  to avoid excessive reclaim overhead on large memory systems.  Pages
> > > +	  may be non-reclaimable because:  they are locked into memory, they
> > > +	  are anonymous pages for which no swap space exists, or they are anon
> > > +	  pages that are expensive to unmap [long anon_vma "related vma" list.]
> > 
> > Why do you select to default is NO ?
> > I think this is really improvement and no one of 64bit user
> > hope turn off without NORECLAIM developer :)
> 
> This was my doing.  I left the default == NO during
> development/experimemental stage so that one would have to take explicit
> action to enable this function.  If the feature makes it into mainline
> and we decide that the default should be 'yes', that will be an easy
> change.

Oh I see.
I will help testing too for it merges to mainline early. 

thanks.


- kosaki


