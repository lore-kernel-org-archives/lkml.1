Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132Ab0A3Xzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0A3Xzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131Ab0A3Xzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:55:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0A3Xzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:55:53 -0500
Date: Sat, 30 Jan 2010 15:56:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100130155640.62ce3104@infradead.org>
In-Reply-To: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 17:45:51 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> Hello,
> 
> Currently we have a workload that depends on around 50 processes that
> wake up 1000 times a second do a small amount of work and go back to
> sleep.  This works great on RHEL 5 (2.6.18-164.6.1.el5), but on recent
> kernels we are unable to achieve 1000 iterations per second.  Using
> the simple test application below on RHEL 5 2.6.18-164.6.1.el5 I can
> run 500 of these processes on and still achieve 999.99 iterations per
> second.  Running just 10 of these processes on the same machine with
> 2.6.32.6 produces results like:
> 
> ...
> Iterations Per Sec: 905.659667
> Iterations Per Sec: 805.099068
> Iterations Per Sec: 925.195578
> Iterations Per Sec: 759.310773
> Iterations Per Sec: 702.849261
> Iterations Per Sec: 782.157292
> Iterations Per Sec: 917.138031
> Iterations Per Sec: 834.770391
> Iterations Per Sec: 850.543755
> ...
> 
> I've tried playing with some of the cfs tunables in /proc/sys/kernel/
> without success.  Are there any suggestions on how to achieve the
> results we are looking for using a recent kernel?

I'll play a bit, but I wonder idly what kind of machine this is on ?
(number and types of cpus)
