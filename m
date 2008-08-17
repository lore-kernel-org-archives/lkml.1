Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYHQCV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYHQCV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 22:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHQCVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 22:21:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYHQCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 22:21:50 -0400
Date: Sun, 17 Aug 2008 04:23:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Message-ID: <20080817022323.GN19125@one.firstfloor.org>
References: <200808141753.58547.rjw@sisk.pl> <20080814163450.GA13814@one.firstfloor.org> <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com> <200808162128.25330.rjw@sisk.pl> <20080816201813.GA30715@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816201813.GA30715@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I'm still seeing it on 2.6.27-rc2, even with the 
> > > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > > wbinvd_halt code patch applied.  Maybe something else
> > > broke in some of the recent hotplug changes?
> > 
> > My guess is that MCE does somthing that is not allowed by sysfs any more.
> 
> Hm, sysfs hasn't changed any in 2.6.27-rcX that I know of.

mce hasn't either in this regard. My current theory is that the CPU 
up/down notifiers are not balanced anymore (as in duplicated up events) 

Would need to add printk to verify that.

-Andi
