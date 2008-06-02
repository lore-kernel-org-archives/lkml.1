Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYFBB6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYFBB6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFBB6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:58:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57526 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYFBB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:58:11 -0400
Date: Sun, 1 Jun 2008 18:56:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Guntsche Michael <mike@it-loops.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Message-ID: <20080601185643.3d3db64f@infradead.org>
In-Reply-To: <E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com>
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com>
	<20080530065717.44cf7414@infradead.org>
	<F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com>
	<E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 23:57:14 +0200
Guntsche Michael <mike@it-loops.com> wrote:

> 
> On May 30, 2008, at 16:07, Guntsche Michael wrote:
> 
> >
> > I am most interested in keeping the temperature of my CPU down,  
> > which means slower fans, which means less noise.
> > The main "problem" I have is that I do not know if this is a
> > simple display issue or if I am having a more fundamental problem
> > here.
> 
> Just FYI I found out the cause of my problem.
> 
> Reverting
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ed9cbcd40004904dbe61ccc16d6106a7de38c998
> this patch resultsin the correct numbers for me.
> 
> <cpuinfo snip>
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 1
> model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
> stepping	: 2
> cpu MHz		: 637.500
> <snip>
> 
> This patch was reverted because other people seem to have problems  
> with it, reverting the revert does not look like a good idea either.
> But since I know now, that this is just a "display" problem and  
> everything is working otherwise, I'll just patch this locally for my  
> machine here.
> 

just as a side note.. you do realize that with p4-clockmod, your cpu is
still running at 1.7 GHz right? (it's just doing less work '-)
