Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbYAKPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbYAKPnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbYAKPn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:43:29 -0500
Received: from emroute1.ornl.gov ([160.91.4.119]:44445 "EHLO emroute1.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760639AbYAKPn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:43:27 -0500
Date: Fri, 11 Jan 2008 10:43:25 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
In-reply-to: <20080111093432.GD8143@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de,
       Jens Axboe <jens.axboe@oracle.com>
Message-id: <1200066205.7480.8.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
 <1199996752.9159.46.camel@lap75545.ornl.gov> <20080111093432.GD8143@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 10:34 +0100, Ingo Molnar wrote:
> * David Dillow <dillowda@ornl.gov> wrote:
> 
> > Ingo, Thomas added as I think this is related to 
> > sched.c:__update_rq_clock()'s checking for forward time warps.
> 
> yep, we've got some fixes in this area. Do blktrace timestamps work fine 
> in v2.6.23, with NOHZ?

Do you still want this tested, given that your ktime change works? If
so, it will likely be next week before I can devote some cycles to it --
it'll take installing a new distro on the machines.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


