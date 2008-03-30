Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYC3JXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYC3JXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 05:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYC3JXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 05:23:24 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:58180 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYC3JXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 05:23:23 -0400
Date: Sun, 30 Mar 2008 14:53:17 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Richard Jonsson <richie@coderworld.net>, linux-kernel@vger.kernel.org
Subject: Re: Keyboard weirdness: keys get stuck
Message-ID: <20080330092317.GD30270@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net> <Pine.LNX.4.64.0803300603110.32241@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803300603110.32241@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 06:04:52AM +0200, Jiri Kosina wrote:
> On Sat, 29 Mar 2008, Richard Jonsson wrote:
> 
> > > With 2.6.25-rc6-git-something I have experienced stuck keys. When typing a
> > > sentence a character repeats aboooooooout 10 times, or as 'about' above ;).
> > > I tested with a new kernel today, 2.6.25-rc7-git-something and the problem
> > > is still present.
> > > With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel in
> > > between.
> > > As a side note, timestamps gets mixed up in dmesg output in a 1-2 second
> > > span. Maybe related?
> > > This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want
> > > configuration details or testing to be done.
> > I should add that while watching a movie I noticed that video stutters every
> > now and then, on an irregular basis. It lasts for approx a second each time.
> 
> Hi Richard,
> 
> what does your .config look like? Do you have CONFIG_GCGROUP_SCHED 
> enabled? (please note that this is different from CONFIG_GROUP_SCHED). If 
> so, please try to reproduce without it.
> 

CGROUP_SCHED depends on GROUP_SCHED. The stutters are not due to the
group scheduling extensions. (or the scheduler AFAICT).

Thanks,
-- 
regards,
Dhaval
