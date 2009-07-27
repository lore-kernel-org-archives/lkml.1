Return-Path: <linux-kernel-owner+w=401wt.eu-S1750963AbZG0OHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbZG0OHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZG0OHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:07:22 -0400
Received: from wayne.mcbone.net ([62.104.198.72]:42910 "EHLO wayne.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZG0OHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:07:21 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 10:07:20 EDT
Date: Mon, 27 Jul 2009 16:00:39 +0200
From: Jens Rosenboom <jens.rosenboom@freenet.ag>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
Message-ID: <20090727140039.GC13577@bo.mcbone.net>
References: <1248681637.7279.12.camel@fnki-nb00130> <1248694266.6987.1594.camel@twins> <1248697004.7279.31.camel@fnki-nb00130> <1248697409.6987.1617.camel@twins> <1248698755.7279.47.camel@fnki-nb00130> <1248701812.6987.1637.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248701812.6987.1637.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 03:36:52PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-27 at 14:45 +0200, Jens Rosenboom wrote:
> 
> > Good question, but as this happens on a production machine, I cannot
> > easily change the installation to check this.
> 
> Uhm, but you do run .31-rc4 on it? :-)

In the hope of verifying a patch, yes. Before that we had 2.6.29.4
for some time.

> > Attaching an strace to the process gives just
> > 
> > # strace -p 12886
> > Process 12886 attached - interrupt to quit
> > 
> > and nothing further.
> 
> Bugger.. how easy it is to reproduce?

There is a lot of stuff happening on this machine, I'm not sure
what part of it is necessary to trigger the bug. Currently it
takes anything from a couple of hours to a couple of days for
the first stuck ps to appear.
