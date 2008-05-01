Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbYEAXXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbYEAXXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbYEAXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:23:36 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:63909 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYEAXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:23:36 -0400
Date: Thu, 1 May 2008 16:23:34 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, davem@davemloft.net, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501232334.GE4354@smtp.west.cox.net>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501223515.GA11366@linux-os.sc.intel.com>
Organization: Embedded Alley Solutions, Inc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:35:15PM -0700, Venki Pallipadi wrote:
> On Thu, May 01, 2008 at 03:27:26PM -0700, Linus Torvalds wrote:
[snip]
> > It's __GNUC_PATCHLEVEL__, I believe.
> > 
> > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> > (bad, and rather uncommon).
> > 
> > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> > begin with, I think it's better to just not support it.
> > 
> 
> Not sure whether #error on gcc 4.1.{0.1} is the right thing as I found atleast
> one distro gcc which says itself as 4.1.1, do not exhibit the problem as it
> most likely has fix backported.

Really?  At the time this was a very uncommon thing (hence the initial
it's not a bug, you just didn't use the right flags) comments.  I
suppose it's possible of course that some distro took a 4.1 snapshot and
called it 4.1.1.

> Putting all weak functions in one file is something Suresh and I considered
> before sending this patch. But, looking at various users of __weak, that
> single file did not look very appropriate.

Indeed.  I suspect that even if you go so far as to do a single patch
per "feature", it's gonna be a lotta stuff.

-- 
Tom Rini
