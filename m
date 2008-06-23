Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYFWSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYFWSH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYFWSHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:07:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:54001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYFWSHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:07:17 -0400
Date: Mon, 23 Jun 2008 11:07:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       josh@freedesktop.org, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
 rcutorture less power-hungry
Message-ID: <20080623110706.197f25b1@infradead.org>
In-Reply-To: <1214243649.4440.10.camel@Aeon>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	<20080618162649.GA18326@linux.vnet.ibm.com>
	<20080622200638.GA25328@linux.vnet.ibm.com>
	<20080622131712.54ba732c@infradead.org>
	<1214243649.4440.10.camel@Aeon>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 17:54:09 +0000
Darren Hart <dvhltc@us.ibm.com> wrote:

> I'm a little concerned about how this will affect real-time
> performance, as queueing up lots of timers all at once can lead to
> long running timer expiration handlers.  If just a schedule_timeout,
> I suppose we are only looking at a process wakeup, as opposed to a
> softirq context callback function?

in reality, the time it takes to deliver the interrupt (including
waking the CPU up etc), is likely to be an order or two of magnitude
higher than this kind of code loop.... 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
