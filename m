Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYAKJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYAKJff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYAKJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:35:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYAKJf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:35:26 -0500
Date: Fri, 11 Jan 2008 10:34:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Dillow <dillowda@ornl.gov>
Cc: linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
Message-ID: <20080111093432.GD8143@elte.hu>
References: <1199918912.8388.13.camel@lap75545.ornl.gov> <1199996752.9159.46.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199996752.9159.46.camel@lap75545.ornl.gov>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Dillow <dillowda@ornl.gov> wrote:

> Ingo, Thomas added as I think this is related to 
> sched.c:__update_rq_clock()'s checking for forward time warps.

yep, we've got some fixes in this area. Do blktrace timestamps work fine 
in v2.6.23, with NOHZ?

	Ingo
