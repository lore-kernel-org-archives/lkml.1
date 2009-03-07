Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZCGQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZCGQXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZCGQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:23:29 -0500
Received: from eastrmmtao106.cox.net ([68.230.240.48]:53723 "EHLO
	eastrmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCGQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:23:29 -0500
X-Authority-Analysis: v=1.0 c=1 a=rDF_XFhH7-gA:10 a=DiAPenQi9D4A:10
 a=kviXuzpPAAAA:8 a=aX9v1mc2blCY03KswMsA:9 a=E2eHJ1BuaD3lEDRT3tInrU6METYA:4
 a=zUBsD6tbDSsA:10 a=4vB-4DCPJfMA:10
X-CM-Score: 0.00
From: Chris Brannon <cmbrannon@cox.net>
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
In-reply-to: <1f1b08da0903061456g7621f92cx8a1e251249d739ac@mail.gmail.com>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net> <1f1b08da0903061456g7621f92cx8a1e251249d739ac@mail.gmail.com>
Date: Sat, 07 Mar 2009 10:23:05 -0600
Message-Id: <20090307162327.PQGL18213.eastrmmtao106.cox.net@eastrmimpo02.cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:
> On Tue, Mar 3, 2009 at 7:06 PM, Christopher Brannon <cmbrannon@cox.net> wrote:
> > I implemented such a facility for Linux.  A read of /dev/time produces
> > four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> > jiffies since boot, and jiffies per second.
> 
> Ehh. Why would we want to export raw kernel internal values like
> jiffies and HZ?
> 
> I think the CLOCK_MONOTONIC clockid would probably be a better value to export.

I'll look at CLOCK_MONOTONIC clockid.  I'm more than glad to export something
more appropriate, including nothing at all (dummy values, perhaps).

-- Chris
