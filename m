Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYHKX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYHKX7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbYHKX6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:58:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbYHKX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:58:19 -0400
Date: Mon, 11 Aug 2008 16:58:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811165816.679cfdb9@infradead.org>
In-Reply-To: <20080811193316.GA16631@isilmar.linta.de>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	<200808081430.43012.trenn@suse.de>
	<aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<20080811042244.469f8e1d@infradead.org>
	<20080811140206.GB3338@cs181140183.pp.htv.fi>
	<20080811071128.0165be50@infradead.org>
	<20080811193316.GA16631@isilmar.linta.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 21:33:17 +0200
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi,
> 
> On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> > 1) when the cpu is idle (as in "idle loop C states/hlt"; p4_clockmod
> > doesn't mean anything.. the clock is stopped not just skipped.
> > 2) when the cpu is executing code (eg non-idle), it takes more power
> > for a unit of time than it takes when it's idle
> 
> This statement might be true, but might also be wrong:
> 	a) on systems where only C1 is exported, p4-clockmod most
> often equals the state the CPU is in when in C1[*], 

that's.. not entirely true btw.

>so we're in a 
> 	   win-win, or lose-lose situation.

even if it were EXACTLY identical (which it isn't).. you would be at
BEST a tie... not a savings. so it's lose-lose or tie-tie, but never win


> 	b) IIRC 50% throttling is not "execute-one-statement
> 	   skip-one-statement execute-one-statement, etc." but instead
> 	   work for N us, skip for N us, work for N us, etc.
> Therefore, the situation is a bit more compilcated.

doesn't change the fundamental math though.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
