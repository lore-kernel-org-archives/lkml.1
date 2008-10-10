Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYJJHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYJJHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJJHyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:54:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYJJHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:54:08 -0400
Subject: Re: cgroup task groups appears sensitive to absolute magnitude of
	shares
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1223618594.7382.60.camel@lappy.programming.kicks-ass.net>
References: <48EE8D06.9060503@nortel.com>
	 <1223618594.7382.60.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 09:53:57 +0200
Message-Id: <1223625237.7382.62.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 08:03 +0200, Peter Zijlstra wrote:
> On Thu, 2008-10-09 at 17:00 -0600, Chris Friesen wrote:
> 
> > Going to 4000/2000/1000/200 doesn't seem to give noticeable 
> > improvements, and going to 40000/20000/10000/2000 causes the test to 
> > behave unpredictably, either taking abnormally long to complete or else 
> > not completing at all.
> 
> Hmm, I would have expected it to work for at least the normal nice range
> of weight values..
> 
> Will have to look into that I suppose..

One thought, are you running 32 or 64 bit? If you're on 32, could you
try 64? If that fixes it its probably an easy fix, otherwise I fear it
might take a bit more..

