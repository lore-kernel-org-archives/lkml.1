Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYBIAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYBIAa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBIAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:30:50 -0500
Received: from lixom.net ([66.141.50.11]:45202 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYBIAat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:30:49 -0500
Date: Fri, 8 Feb 2008 18:32:20 -0600
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080209003220.GA21395@lixom.net>
References: <20080209000456.GA21021@lixom.net> <20080209000829.GA29986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209000829.GA29986@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 01:08:30AM +0100, Ingo Molnar wrote:
> 
> * Olof Johansson <olof@lixom.net> wrote:
> 
> > 2.6.22: 3332 ms
> > 2.6.23: 4397 ms
> > 2.6.24: 8953 ms
> > 2.6.24-git19: 8986 ms
> 
> if you enable SCHED_DEBUG, and subtract 4 from the value of 
> /proc/sys/kernel/sched_features, does it get any better?
> 
> if not, does writing 0 into /proc/sys/kernel/sched_features have any 
> impact?

Doesn't seem to make a difference, either of them. I can unfortunately
not retest on x86 at the moment, only powerpc. But it made no noticable
difference in runtime w/ pasemi_defconfig and current mainline.


-Olof
