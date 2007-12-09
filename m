Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbXLIQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbXLIQAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 11:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXLIQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 11:00:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59637 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXLIQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:00:07 -0500
Date: Sun, 9 Dec 2007 07:59:21 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071209075921.4a0e1240@laptopd505.fenrus.org>
In-Reply-To: <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208093039.GA28054@elte.hu>
	<20071208163749.GI19691@waste.org>
	<alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
	<20071208100950.a3547868.akpm@linux-foundation.org>
	<alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
	<20071208195211.GA3727@elte.hu>
	<20071208202930.GA17934@elte.hu>
	<84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 10:20:19 +0200
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
\
> Now, while SLAB code is "pleasant and straightforward code" (thanks,
> btw) for UMA, it's really hairy for NUMA plus the "alien caches" eat
> tons of memory 

.. and they make slab slower on numa systems for database workloads
(I'm sure they do fine for SGI's customers HPC load though))

>(which is why Christoph wrote SLUB in the first place,
> the current code in SLAB is mostly unfixable due to its *queuing*
> nature).

To be honest, a SLAB without the alien stuff might be one of the best
performers today .... ;)
(on database loads.. where slub is quite a disaster as everyone knows)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
