Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbZBMXAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbZBMXAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZBMW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:59:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:55197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZBMW7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:59:49 -0500
Subject: Re: [PATCH] net: replace commatas with semicolons
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
References: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 23:59:43 +0100
Message-Id: <1234565983.4831.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 22:46 +0100, Thomas Gleixner wrote:
> Impact: syntax fix
> 
> Interestingly enough this compiles w/o any complaints:
> 
> 	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
> 	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),

Yep, the wonders of the , operator. Look her up the next time you're
reading the C specs and marvel :-)

