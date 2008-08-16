Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYHPTZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYHPTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYHPTZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:25:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYHPTZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:25:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Date: Sat, 16 Aug 2008 21:28:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200808141753.58547.rjw@sisk.pl> <20080814163450.GA13814@one.firstfloor.org> <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808162128.25330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 of August 2008, Langsdorf, Mark wrote:
> > On Thu, Aug 14, 2008 at 05:53:57PM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, 13 of August 2008, Mark Langsdorf wrote:
> > > > I'm seeing the following error message when I hotunplug and replug
> > > > a cpu in 2.6.27-rc2-git5.  The system becomes unstable almost
> > > > immediately afterwards.
> > > 
> > > Hm, it seems that MCE is involved somehow.  Andi, can you 
> > have a look at this,
> > > please?
> > 
> > FWIW the mce code here actually hasn't changed for a long time.
> > 
> > 
> > > > ------------[ cut here ]------------
> > > > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x39()
> > > > sysfs: duplicate filename 'machinecheck4' can not be created
> > 
> > The only way I could see that happening if CPU_DEAD/CPU_ONLINE
> > is not properly balanced.
> 
> I'm still seeing it on 2.6.27-rc2, even with the 
> patch here http://lkml.org/lkml/2008/7/30/171 and the
> wbinvd_halt code patch applied.  Maybe something else
> broke in some of the recent hotplug changes?

My guess is that MCE does somthing that is not allowed by sysfs any more.

Thanks,
Rafael
