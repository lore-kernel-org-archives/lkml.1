Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYDTPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYDTPmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 11:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYDTPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 11:42:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYDTPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 11:42:04 -0400
Date: Sun, 20 Apr 2008 08:41:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420084127.2fc324ec@laptopd505.fenrus.org>
In-Reply-To: <480B4DB4.8070107@sandeen.net>
References: <20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
	<20080420080901.GF1595@cs181133002.pp.htv.fi>
	<20080420090623.7b173ef1@the-village.bc.nu>
	<20080420085104.GG1595@cs181133002.pp.htv.fi>
	<20080420103611.2c0d3519@the-village.bc.nu>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<20080420120250.4f496861@the-village.bc.nu>
	<20080420115455.GJ1595@cs181133002.pp.htv.fi>
	<20080420123731.7282bb16@the-village.bc.nu>
	<20080420121803.GK1595@cs181133002.pp.htv.fi>
	<480B4DB4.8070107@sandeen.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 09:05:40 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> 
> 4K just happens to be the page size; other than that it's really just
> some random/magic number picked, and now dictated that if you (and
> everyting around you) doesn't fit, you're broken.

it wasn't randomly picked; it was based on 2.4 kernels
(where we had 8kb, but that was roughly 2.5Kb or so for the task struct,
which was on stack back then, then 4Kb for user context and 2Kb for IRQ context)

> 
> That bugs me.
> 

yes. Adrian is waay off in the weeds on this one. Nobody but him is suggesting to remove
8Kb stacks. I think everyone else agrees that having both options is valuable; and there
are better ways to find+fix stack bloat than removing this config option.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
