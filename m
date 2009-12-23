Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZLWNme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZLWNme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZLWNmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:42:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40680 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZLWNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:42:33 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B321DD6.90408@s5r6.in-berlin.de>
Date: Wed, 23 Dec 2009 14:40:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu> <4B31C210.4010100@kernel.org> <20091223080144.GG23839@elte.hu> <4B31D487.6060706@kernel.org> <20091223083705.GA25240@elte.hu>
In-Reply-To: <20091223083705.GA25240@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (Plus reduction in driver complexity can be measured as well, in the diffstat 
> space.)
> 
> So there's no leap of faith needed really, IMHO.

To measure this properly by means of diffstat, first convert typical
create_singlethread_workqueue users to <linux/slow-work.h>, then convert
them back to <linux/workqueue.h>.  Then look at the diffstat of the
_second_ step.
-- 
Stefan Richter
-=====-==--= ==-- =-===
http://arcgraph.de/sr/
