Return-Path: <linux-kernel-owner+w=401wt.eu-S1422829AbXCBLjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbXCBLjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422826AbXCBLjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:39:05 -0500
Received: from p02c11o143.mxlogic.net ([208.65.145.66]:37876 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422824AbXCBLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:39:04 -0500
Date: Fri, 2 Mar 2007 13:39:20 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070302113920.GB9367@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302102216.GA13575@elte.hu>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 02 Mar 2007 11:41:21.0902 (UTC) FILETIME=[B33DA8E0:01C75CBF]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15028.003
X-TM-AS-Result: No--7.728700-4.000000-31
X-Spam: [F=0.2210152620; S=0.221(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: [patch] KVM: T60 resume fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> my T60 laptop does not resume correctly due to KVM attempting to send an 
> IPI to a CPU that might be down (or not up yet). (Doing so also triggers 
> the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 
> 732.)
> 
> with this fix applied my laptop does not hang during resume.
> 
> [ KVM will have to disable/enable virtualization on the CPU itself that
>   goes down / comes up, not via an IPI sent from the requesting CPU. ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Since I don't normally have kvm loaded, this patch is unlikely
to help me, is that right?

-- 
MST
