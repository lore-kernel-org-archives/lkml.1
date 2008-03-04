Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYCDJjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYCDJjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYCDJjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:39:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51655 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCDJjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:39:12 -0500
Date: Tue, 4 Mar 2008 10:40:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080304094028.GC15255@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304040048.GA31562@codemonkey.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:00:48PM -0500, Dave Jones wrote:
> On Tue, Mar 04, 2008 at 12:10:33AM +0100, Andi Kleen wrote:
>  > On Mon, Mar 03, 2008 at 06:05:35PM -0500, Alan Stern wrote:
>  > > On Mon, 3 Mar 2008, Pallipadi, Venkatesh wrote:
>  > > 
>  > > > But, with this patch:
>  > > > - we are penalizing good hardware and making them less power efficient
>  > > > to match the bad ones.
>  > > > - There may also be server systems which first may not have these sort
>  > > > of power fluctuations and even when buggy and have this noise, system
>  > > > may be in some corner of some lab with fans making more noise than the
>  > > > capacitors.
>  > > 
>  > > Can you make it configurable through sysfs?  
>  > 
>  > It already is, through a writable module_parm() 
>  > 
>  > > Default to disabled, but 
>  > > allow the user to turn it on if the machine makes too much noise.
>  > 
>  > 99+% of the users wouldn't be able to figure that out.
> 
> 99+% of users don't have singing capacitors. (Or don't care enough to complain)
> For those that do can't figure out what to do from google,
> we have a documentation problem.

The big question is if there is a measurable difference in power consumption
from a reasonable default value.  I doubt it actually. The normal rule
of thumb is that if you average sleeps are long enough (and they still
stay this way even with the patch enabled) you're doing ok. If there is 
no or not significant penalty there is no reason to not enable it by default.

-Andi
