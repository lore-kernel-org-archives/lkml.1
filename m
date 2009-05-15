Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZEOS32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZEOS32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZEOS3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:29:16 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55237 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbZEOS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:29:15 -0400
Date: Fri, 15 May 2009 14:09:25 -0400 (EDT)
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
In-Reply-To: <20090515082312.F5B6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905151402370.26559@qirst.com>
References: <20090513084306.5874.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905141612100.15881@qirst.com> <20090515082312.F5B6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, KOSAKI Motohiro wrote:

> May I ask detail operation?

Detailed operation? Well no. More of an experience.

Browse the web in the evening. Let the backup run overnight. Try to access
the web in the morning. Pretty unscientific.

> > Observation of the typical mapped size of Firefox under KDE.
>
> My point is, desktop people have very various mapped ratio.
> Do you oppose this?

No of course not. Loads may have different mapped ratios. That is why
there is a /proc/sys/vm tunable in my patch (which is not good as
mentioned in the patch). If Rik's solution works without it great.
