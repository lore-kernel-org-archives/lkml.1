Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbZCIELK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbZCIELK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 00:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZCIEK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 00:10:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50175 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750918AbZCIEK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 00:10:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18M8OpZG5YMBInYDkRkwHvAXdOqhVuGrGX8wZJPBj
	lbRI8m/2b1g0zX
Subject: Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090308185518.GB28169@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu> <1236537580.7094.8.camel@marge.simson.net>
	 <20090308185518.GB28169@elte.hu>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 05:10:51 +0100
Message-Id: <1236571851.15543.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 19:55 +0100, Ingo Molnar wrote:

> btw., there's room for a cleanup + micro-optimization here too: 
> it would be nice to change se.last_wakeup and 
> se.prev_sum_exec_runtime to be the same variable, 
> se.prev_timestamp or so.

I don't see how they can meld without breaking check_preempt_tick() all
to pieces.

	-Mike

