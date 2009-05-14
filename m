Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbZENX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbZENX2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZENX2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:28:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56031 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZENX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:28:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped pages from reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0905141612100.15881@qirst.com>
References: <20090513084306.5874.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905141612100.15881@qirst.com>
Message-Id: <20090515082312.F5B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 15 May 2009 08:28:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 13 May 2009, KOSAKI Motohiro wrote:
> 
> > > All these expiration modifications do not take into account that a desktop
> > > may sit idle for hours while some other things run in the background (like
> > > backups at night or updatedb and other maintenance things). This still
> > > means that the desktop will be usuable in the morning.
> >
> > Have you seen this phenomenom?
> > I always use linux desktop for development. but I haven't seen it.
> > perhaps I have no luck. I really want to know reproduce way.
> >
> > Please let me know reproduce way.
> 
> Run a backup (or rsync) over a few hundred GB.

-ENOTREPRODUCED

umm.
May I ask detail operation?


> > > The percentage of file backed pages protected is set via
> > > /proc/sys/vm/file_mapped_ratio. This defaults to 20%.
> >
> > Why do you think typical mapped ratio is less than 20% on desktop machine?
> 
> Observation of the typical mapped size of Firefox under KDE.

My point is, desktop people have very various mapped ratio.
Do you oppose this?


> > key point is access-once vs access-many.
> 
> Nothing against it if it works.
> 



