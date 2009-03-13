Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZCMSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZCMSIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZCMSIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:08:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2941 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCMSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:08:32 -0400
Date: Fri, 13 Mar 2009 12:08:29 -0600
From: Alex Chiang <achiang@hp.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090313180829.GC5335@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <gregkh@suse.de>,
	Tejun Heo <tj@kernel.org>, Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <49B76640.6010109@kernel.org> <20090312002737.GB17345@ldl.fc.hp.com> <20090312032228.GA25419@suse.de> <20090312220231.GC31042@ldl.fc.hp.com> <20090313130314.77dc18ed@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313130314.77dc18ed@gondolin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Thu, 12 Mar 2009 16:02:31 -0600,
> Alex Chiang <achiang@hp.com> wrote:
> > 
> > Cornelia, I understand your earlier point about a smaller patch
> > in the caller, but I think pushing the code down into the
> > infrastructure is the right thing to do. 
> 
> OK, I don't have further objections.

Thanks.

> > Also, I wasn't brave
> > enough to patch your ccwgroup_ungroup_store(), but I think you
> > won't need the gdev->onoff stuff anymore in that code path.
> 
> We still need it to prevent online/offline vs. ungroup races.
> 
> While device_schedule_callback() should not be able to return -EAGAIN
> on us, I'll sleep better if you could add the following snippet to your
> patch:

Added and resent to Greg.

Thanks.

