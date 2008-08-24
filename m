Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYHXF3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYHXF3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 01:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYHXF3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 01:29:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbYHXF3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 01:29:33 -0400
Date: Sat, 23 Aug 2008 22:29:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 1/2] Show quicklist at meminfo
Message-Id: <20080823222923.9a7ce3d5.akpm@linux-foundation.org>
In-Reply-To: <20080823171352.2533.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080822100049.F562.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080821212847.f7fc936b.akpm@linux-foundation.org>
	<20080823171352.2533.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008 17:24:31 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > OK.
> > > I ran cpu hotplug/unplug coutinuous workload over 12H.
> > > then, system crash doesn't happend.
> > > 
> > > So, I believe my patch is cpu unplug safe.
> > 
> > err, which patch?
> > 
> > I presently have:
> > 
> > mm-show-quicklist-memory-usage-in-proc-meminfo.patch
> > mm-show-quicklist-memory-usage-in-proc-meminfo-fix.patch
> > mm-quicklist-shouldnt-be-proportional-to-number-of-cpus.patch
> > mm-quicklist-shouldnt-be-proportional-to-number-of-cpus-fix.patch
> > 
> > Is that what you have?
> > 
> > I'll consolidate them into two patches and will append them here.  Please check.
> 
> Andrew, Thank you for your attention.
> 
> I test on
> 
> mm-show-quicklist-memory-usage-in-proc-meminfo.patch
> mm-show-quicklist-memory-usage-in-proc-meminfo-fix.patch
> 
> and 
> 
> http://marc.info/?l=linux-mm&m=121931317407295&w=2 
> 
> 
> the above url's patch already checked sparc64 compilable by David.
> and I tested it.
> 
> So, if possible, Could you replace current quicklist-shouldnt-be-proportional
> patch to that?
> (of cource, current -mm patch also works well)
> 

OK, there's just too much potential for miscommunication and error here.

Please resend everything as a sequence-numbered, fully-changlelogged
signed-off patch series against current mainline.


