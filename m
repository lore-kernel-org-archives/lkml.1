Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYAPHPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYAPHPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYAPHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:14:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbYAPHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:14:52 -0500
Date: Tue, 15 Jan 2008 23:15:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "dean gaudet" <dean@arctic.org>, NeilBrown <neilb@suse.de>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Message-Id: <20080115231504.4df1b739.akpm@linux-foundation.org>
In-Reply-To: <e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
References: <20080114123726.19968.patches@notabene>
	<1080114014525.20337@suse.de>
	<alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
	<20080115215425.b1fcba31.akpm@linux-foundation.org>
	<alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
	<e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 00:09:31 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:

> > heheh.
> >
> > it's really easy to reproduce the hang without the patch -- i could
> > hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
> > i'll try with ext3... Dan's experiences suggest it won't happen with ext3
> > (or is even more rare), which would explain why this has is overall a
> > rare problem.
> >
> 
> Hmmm... how rare?
> 
> http://marc.info/?l=linux-kernel&m=119461747005776&w=2
> 
> There is nothing specific that prevents other filesystems from hitting
> it, perhaps XFS is just better at submitting large i/o's.  -stable
> should get some kind of treatment.  I'll take altered performance over
> a hung system.

We can always target 2.6.25-rc1 then 2.6.24.1 if Neil is still feeling
wimpy.

