Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZETPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZETPjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZETPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:39:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:12143 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZETPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:39:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,222,1241420400"; 
   d="scan'208";a="145019397"
Date: Wed, 20 May 2009 23:38:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: gnome-list@gnome.org
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "xorg@lists.freedesktop.org" <xorg@lists.freedesktop.org>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090520153851.GA6572@localhost>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com> <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com> <20090519062503.GA9580@localhost> <87pre4nhqf.fsf@basil.nowhere.org> <20090520143258.GA5706@localhost> <20090520144731.GB4753@basil.nowhere.org> <20090520145607.GA6281@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520145607.GA6281@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

On Wed, May 20, 2009 at 10:56:07PM +0800, Wu Fengguang wrote:
> On Wed, May 20, 2009 at 10:47:31PM +0800, Andi Kleen wrote:
> > > > One scenario that might be useful to test is what happens when some
> > > > very large processes, all mapped and executable exceed memory and
> > > 
> > > Good idea. Too bad I may have to install some bloated desktop in order
> > > to test this out ;) I guess the pgmajfault+pswpin numbers can serve as
> > > negative scores in that case?
> > 
> > I would just generate a large C program with a script and compile
> > and run that. The program can be very dumb (e.g. only run
> > a gigantic loop), it just needs to be large.
> > 
> > Just don't compile it with optimization, that can be quite slow.
> > 
> > And use multiple functions, otherwise gcc might exceed your memory.
> 
> 
> Hehe, an arbitrary C program may not be persuasive..but I do have some
> bloated binaries at hand :-)
> 
> -rwsr-sr-x 1 root wfg   36M 2009-04-22 17:21 Xorg
> lrwxrwxrwx 1 wfg  wfg     4 2009-04-22 17:21 X -> Xorg
> -rwxr-xr-x 1 wfg  wfg   39M 2009-04-22 17:21 Xvfb
> -rwxr-xr-x 1 wfg  wfg   35M 2009-04-22 17:21 Xnest

I would like to create a lot of windows in gnome, and to switch
between them. Any ideas on scripting/automating the "switch window"
actions?

Thanks,
Fengguang
