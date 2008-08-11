Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYHKO2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYHKO2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYHKO14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:27:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYHKO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:27:56 -0400
Date: Mon, 11 Aug 2008 16:29:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811142900.GU9038@one.firstfloor.org>
References: <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins> <20080811114243.GO9038@one.firstfloor.org> <22551.1218464121@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22551.1218464121@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$INSERT-ANY-OTHER-PRINTK-USE$

The point was that printk may have been perfectly adequate for 
them with its existing buffer sizes and dynamic wake up frequency,
and might not anymore with the timer wakeup change. Essentially
it is making a widely used kernel facility more fragile.

-Andi
