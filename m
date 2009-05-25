Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbZEYLY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbZEYLY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZEYLYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:24:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZEYLYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:24:52 -0400
Date: Mon, 25 May 2009 13:24:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
In-Reply-To: <1243249766.26820.665.camel@twins>
Message-ID: <alpine.LSU.2.00.0905251316510.3539@fbirervta.pbzchgretzou.qr>
References: <20090518160904.7df88425@skybase>  <1242660243.26820.439.camel@twins> <20090519104900.12e1f80c@skybase>  <1242723635.26820.471.camel@twins>  <20090525125034.159ecb78@skybase> <1243249766.26820.665.camel@twins>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-05-25 13:09, Peter Zijlstra wrote:
>
>I really prefer using things like percpu_counter/vmstat that have error
>bounds that scale with the number of cpus in the system.
>
>We simply have to start educating people that numbers on the global
>state of the machine are inaccurate (they were anyway, because by the
>time the userspace bits that read the /proc file get scheduled again the
>numbers will have changed again).
>
>There's a variant of Heisenberg's uncertainty principle applicable to
>(parallel) computers in that one either gets concurrency or accuracy on
>global state, you cannot have both.
>
Inaccuracies are fine, esp. for something like monotic increasing
idle uptime.
