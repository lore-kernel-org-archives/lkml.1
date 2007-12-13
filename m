Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbXLMRVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbXLMRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbXLMRVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:21:32 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:34962 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757955AbXLMRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:21:31 -0500
Date: Thu, 13 Dec 2007 22:50:57 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, vincent.fortier1@ec.gc.ca,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213172057.GA28874@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1197554397.19869.3.camel@lov.site> <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca> <1197562981.19869.5.camel@lov.site> <20071213165059.GC4865@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213165059.GC4865@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:50:59PM +0100, Ingo Molnar wrote:
> 
> * Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > > > > > +   sa->attr.owner = NULL;
> > > > > >     sa->attr.name = name;
> > > > >
> > > > > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > > > > initialize the owner field to NULL automatically?
> > > > 
> > > > Attibutes do not have an owner anymore:
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15
> > > 
> > > This one also fails to apply properly at the exact same place has 
> > > Ingo's previously posted patch.  Would need to backport his one.
> > 
> > It depends on a completely reworked sysfs logic, I don't think it 
> > makes any sense to backport that.
> 
> well, if it fixes a live bug in a still supported stable kernel 
> release...
> 
> Vincent, could you try to just get rid of all actual uses of 
> se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
> (totally untested - might be fatally broken as well)
> 

hmm. I am not too sure if it is a good idea. I think it will break a lot
of drivers. But I will just wait for the sysfs experts to speak up thre.

-- 
regards,
Dhaval
