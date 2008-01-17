Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYAQMig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYAQMig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYAQMhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:37:43 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:43427 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752925AbYAQMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:37:43 -0500
Date: Thu, 17 Jan 2008 23:35:32 +1100
From: CaT <cat@zip.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc7: memory leak?
Message-ID: <20080117123532.GU3940@zip.com.au>
References: <1200571632.28661.13.camel@twins> <20080117121408.GS3940@zip.com.au> <20080117212142.11EC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117212142.11EC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:22:50PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > > > Should all this cache usage not be counted towards the
> > > > 'Cached' entry in meminfo rather then getting counted as part of used
> > > > ram. 
> > > 
> > > Cached is only the page-cache, not all the other caches we have..
> > > This someones confuses people, but one gets used to it. slabinfo allows
> > > one to easily view others.
> > 
> > So what would I have to do to find out the real amount of memory free?
> > Would that be the MemFree field in /proc/meminfo plus, from
> > /proc/slabinfo, *_cache and size-*?
> 
> SReclaimable field can't fill requilrement? :)

Ah. Hmm. *pokes about* That does seem to correspond pretty closely to
what happens with the echo 3 >/proc/.... Though it never seems to get to
0 (~4 meg is as close as it gets on this box) which seems to jive with
what Peter said in the other email.

Hmm. I think tomorrow I'll be writing free.pl and modifying my graphing
and monitoring stuff to take this into account somehow. :)

Thanks!

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
