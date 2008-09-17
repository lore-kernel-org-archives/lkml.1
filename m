Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYIQVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYIQVyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYIQVyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:54:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:59097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbYIQVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:54:01 -0400
Date: Wed, 17 Sep 2008 14:54:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080917145400.29d1809c@infradead.org>
In-Reply-To: <48D17B47.7080704@yahoo.com>
References: <fa.vMKgvqjqmYnI2J40GHoTENeYm8U@ifi.uio.no>
	<fa.808p0ZtU9DCpeky4KfNS8Drdw9w@ifi.uio.no>
	<48D17B47.7080704@yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 22:48:55 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Arjan van de Ven wrote:
> > this says you haven't done "make install" on the latencytop
> > directory so it's not translating things for you.. can you do that
> > please?
> 
> > Cause                                                Maximum
> > 
Percentage 

Scheduler: waiting for cpu                        208 msec         59.4 %


you're rather CPU bound, and your process was woken up but didn't run for over 200 milliseconds..
that sounds like a scheduler fairness issue!
