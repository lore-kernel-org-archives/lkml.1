Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZENU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZENU3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZENU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:29:04 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56892 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752756AbZENU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:29:01 -0400
Date: Thu, 14 May 2009 16:14:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
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
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
 pages from reclaim
In-Reply-To: <20090513084306.5874.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905141612100.15881@qirst.com>
References: <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com> <20090513084306.5874.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, KOSAKI Motohiro wrote:

> > All these expiration modifications do not take into account that a desktop
> > may sit idle for hours while some other things run in the background (like
> > backups at night or updatedb and other maintenance things). This still
> > means that the desktop will be usuable in the morning.
>
> Have you seen this phenomenom?
> I always use linux desktop for development. but I haven't seen it.
> perhaps I have no luck. I really want to know reproduce way.
>
> Please let me know reproduce way.

Run a backup (or rsync) over a few hundred GB.

> > The percentage of file backed pages protected is set via
> > /proc/sys/vm/file_mapped_ratio. This defaults to 20%.
>
> Why do you think typical mapped ratio is less than 20% on desktop machine?

Observation of the typical mapped size of Firefox under KDE.

> key point is access-once vs access-many.

Nothing against it if it works.

