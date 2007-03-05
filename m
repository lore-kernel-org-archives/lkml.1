Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXCEKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXCEKpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbXCEKpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:45:31 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:35907 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbXCEKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:45:30 -0500
Date: Mon, 5 Mar 2007 12:40:13 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070305104013.GC5029@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <45EBE288.8010101@qumranet.com> <20070305100537.GA9175@elte.hu> <45EBF1E3.4030003@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBF1E3.4030003@qumranet.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Avi Kivity <avi@qumranet.com>:
> Subject: Re: [patch] KVM: T60 resume fix
> 
> Ingo Molnar wrote:
> > * Avi Kivity <avi@qumranet.com> wrote:
> >
> >   
> >>> suspend/resume works fine now and there are no warning messages 
> >>> whatsoever (with suspend simulation). Thanks Avi!
> >>>       
> >> Where do I find this suspend simulation?  Sounds like a great suspend 
> >> debugging tool.
> >>     
> >
> > it's just the simple hack below.
> >
> >
> >   
> 
> Thanks, I'll put it to good use.  Are you planning to upstream it?  Not 
> for 2.6.21, presumably ;)

I think Pavel wants it triggerable through /sys/power/state:
http://lkml.org/lkml/2007/1/25/99

-- 
MST
