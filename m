Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZEHNne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZEHNne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZEHNnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:43:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZEHNnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:43:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Fri, 8 May 2009 15:42:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905080111.31273.rjw@sisk.pl> <20090508101651.aa4d513d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090508101651.aa4d513d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905081542.48942.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, KAMEZAWA Hiroyuki wrote:
> On Fri, 8 May 2009 01:11:30 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > +	for_each_populated_zone(zone)
> > +		zone_set_flag(zone, ZONE_OOM_LOCKED);
> 
> > +	for_each_populated_zone(zone)
> > +		zone_clear_flag(zone, ZONE_OOM_LOCKED);
> > +
> 
> Isn't it better to make above 2 be functions and move to mm/oom_kill.c ?

Hmm, OK.  I'll do it.

Well, in fact snapshot.c is all about memory management, so perhaps it's a good
idea to move it into mm as a whole. ;-)

Best,
Rafael
