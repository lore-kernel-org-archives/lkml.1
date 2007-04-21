Return-Path: <linux-kernel-owner+w=401wt.eu-S1030690AbXDULH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030690AbXDULH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDULH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:07:57 -0400
Received: from 1wt.eu ([62.212.114.60]:2062 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030690AbXDULH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:07:56 -0400
Date: Sat, 21 Apr 2007 13:07:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070421110748.GA6383@1wt.eu>
References: <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu> <20070419184534.GA29096@1wt.eu> <20070421103129.GA12621@elte.hu> <20070421104522.GA17856@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421104522.GA17856@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'm replying to your 3 mails at once.

On Sat, Apr 21, 2007 at 12:45:22PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > It could become a useful scheduler benchmark !
> > 
> > i just tried ocbench-0.3, and it is indeed very nice!

So as you've noticed just one minute after I put it there, I've updated
the tool and renamed it ocbench. For others, it's here :

    http://linux.1wt.eu/sched/

Useful news are proper positionning, automatic forking, and more visible
progress with smaller windows, which eat less of X ressources.

Now about your idea of making it report information on stdout, I don't
know if it would be that useful. There are many other command line tools
for this purpose. This one's goal is to eat CPU with a visual control of
CPU distribution only.

Concerning your idea of using a signal to resync every process, I agree
with you. Running at 8x8 shows a noticeable offset. I've just uploaded
v0.4 which supports your idea of sending USR1.

> another thing i noticed: when using a -y larger then 1, then the window 
> title (at least on Metacity) overlaps and thus the ocbench tasks have 
> different X overhead and get scheduled a bit assymetrically as well. Is 
> there any way to start them up title-less perhaps?

It has annoyed me a bit too, but I'm no X developer at all, so I don't
know at all if it's possible nor how to do this. I know that my window
manager even adds title bars to xeyes, so I'm not sure we can do this.

Right now, I've added a "-B <border size>" argument so that you can
skip the size of your title bar. It's dirty but it's not my main job :-)

Thanks for your feedback
Willy

