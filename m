Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYEMPer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYEMPer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYEMPej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:34:39 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:59183 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbYEMPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:34:38 -0400
Date: Tue, 13 May 2008 21:04:03 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Latest Linus git: =?utf-8?Q?kernel=2Fs?=
	=?utf-8?B?Y2hlZC5jOjEyMTY6IHdhcm5pbmc6IOKAmGluaXRfaHJ0aWNr?=
	=?utf-8?B?4oCZ?= defined but not used
Message-ID: <20080513153403.GA4474@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <48278762.1080508@gmail.com> <20080513132328.GB5809@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513132328.GB5809@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:23:28PM +0200, Ingo Molnar wrote:
> 
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
> > Hi Ingo,
> >
> > I got the above warning in my latest build.  I assume it is because 
> > init_hrtick() is only called from CONFIG_SMP sched_init_smp(), and I 
> > have a HRT-enabled UP box.
> >
> > I could write up the simple patch to put #ifdef CONFIG_SMP around 
> > init_hrtick(), but with all of the #ifdefs in that file, I figure it 
> > is probably a little more complicated than that.
> 
> the fix seems simple - see below. The #ifdef jungle ... less so.

I attempted to make it a bit easier to figure out that jungle at 
http://lkml.org/lkml/2008/5/12/64 , if it helps.

-- 
regards,
Dhaval
