Return-Path: <linux-kernel-owner+w=401wt.eu-S1423271AbXDYHc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423271AbXDYHc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423275AbXDYHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:32:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:41105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423271AbXDYHcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:32:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
Date: Wed, 25 Apr 2007 09:32:39 +0200
User-Agent: KMail/1.9.6
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com> <a44ae5cd0704242341n4c8d9eaaw4516759ff79e8cd5@mail.gmail.com> <20070425000735.130ec3e7.akpm@linux-foundation.org>
In-Reply-To: <20070425000735.130ec3e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704250932.39200.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >  Upon resuming, I
> > checked dmesg and found the time seems to be totally out of whack:
> 
> So sched_clock() went bad.  That's another tree or three we can't merge.

Right now sched_clock doesn't have a call back to resync for suspend/resume. I will add one.

-Andi
