Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbZJ3Wp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbZJ3Wp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbZJ3WpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:45:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59905 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbZJ3WpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:45:23 -0400
Date: Fri, 30 Oct 2009 15:45:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Patrik Kluba <kpajko79@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU on UP
Message-ID: <20091030224528.GN6782@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <26080408.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26080408.post@talk.nabble.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 09:10:02AM -0700, Patrik Kluba wrote:
> 
> Hi!
> 
> Does the preemptible RCU implementation have better performance (lower
> latency?) than the classic RCU implementation on embedded uniprocessor
> systems? I can't find any information about this in Documentation/.

I would expect that you would get the best latencies on UP by using
the -rt patchset and preemptible RCU.  I don't know that anyone has
carefully measured the combination of vanilla CONFIG_PREEMPT kernel
and preemptible RCU on UP.

							Thanx, Paul
