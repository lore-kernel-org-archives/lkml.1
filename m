Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbZFQViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbZFQViK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZFQVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:37:58 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:54984 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754208AbZFQVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:37:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qML1LTBoW0B2ywcmHiPZmhwIRSMedzFvgdyS55LQZlXly32tY8Ybu17dqYws+gGwU3jOJjD6BwmbAy9Dy4sSDZfKYENiI8G3mxRpeUHrhAMkQMo0R+GBJk2myfoy21Hy;
Date: Wed, 17 Jun 2009 14:37:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
 citizen
Message-ID: <20090617143756.5c57f6e7@jbarnes-g45>
In-Reply-To: <20090617141135.0d622bfe@jbarnes-g45>
References: <20090516090005.916779788@intel.com>
	<1242485776.32543.834.camel@laptop>
	<20090617141135.0d622bfe@jbarnes-g45>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 14:11:35 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Sat, 16 May 2009 16:56:16 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2009-05-16 at 17:00 +0800, Wu Fengguang wrote:
> > > Andrew,
> > > 
> > > This patchset makes mapped executable pages the first class
> > > citizen. This version has incorparated many valuable comments
> > > from people in the CC list, and runs OK on my desktop. Let's test
> > > it in your -mm?
> > 
> > Seems like a good set to me. Thanks for following this through Wu!
> 
> Now that this set has hit the mainline I just wanted to chime in and
> say this makes a big difference.  Under my current load (a parallel
> kernel build and virtualbox session the old kernel would have been
> totally unusable.  With Linus's current bits, things are much better
> (still a little sluggish with a big dd going on in the virtualbox, but
> actually usable).

To really make things better though, I changed from CFQ to deadline on
the disk I'm using.  I also changed swappiness to 40 and reduced my
max_sectors_kb (512 -> 64) though...

-- 
Jesse Barnes, Intel Open Source Technology Center
