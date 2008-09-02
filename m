Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYIBNG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYIBNG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYIBNGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:06:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:58834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYIBNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:06:48 -0400
Date: Tue, 2 Sep 2008 06:06:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de,
       Fabio Checconi <fabio@gandalf.sssup.it>
Subject: Re: [PATCH 11/13] hrtimer: turn hrtimers into range timers
Message-ID: <20080902060645.338b54a2@infradead.org>
In-Reply-To: <1220353725.8609.32.camel@twins>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161336.10a71c9f@infradead.org>
	<1220343732.8609.19.camel@twins>
	<1220353725.8609.32.camel@twins>
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

On Tue, 02 Sep 2008 13:08:45 +0200
> 
> What you need is a data structure that supports stabbing queries on
> overlapping intervals, such like a Priority Search Tree.
> 


for perfection we'd need that, for a simple good we don't; timers are
also performance critical so whatever we do can't be expensive in any
way... the current method isn't any more expensive.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
