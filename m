Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXCWWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXCWWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934331AbXCWWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:25:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:57838 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXCWWZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:25:51 -0400
Date: Fri, 23 Mar 2007 23:25:49 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
Message-ID: <20070323222549.GA19772@strauss.suse.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>
References: <20070323164447.659982000@strauss.suse.de> <Pine.LNX.4.60.0703232312180.5971@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0703232312180.5971@poirot.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-23 23:15]:
> On Fri, 23 Mar 2007, Bernhard Walle wrote:
> 
> > irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
> > interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.
> 
> emn, please, cannot we come up with a better name - one that doesn't have 
> "IRQ" 3 (!) times in it?...

Well, it was suggested by Andrew. What's your suggestion?


Thanks,
   Bernhard
