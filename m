Return-Path: <linux-kernel-owner+w=401wt.eu-S1762556AbXLUCRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762556AbXLUCRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762481AbXLUCRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:17:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761554AbXLUCRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:17:20 -0500
Date: Thu, 20 Dec 2007 18:15:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Whitcroft <apw@shadowen.org>,
       Joe Perches <joe@perches.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-Id: <20071220181532.f31cdcaa.akpm@linux-foundation.org>
In-Reply-To: <200712210243.35240.elendil@planet.nl>
References: <474E6BD0.20103@cn.fujitsu.com>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<200712210243.35240.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 02:43:33 +0100 Frans Pop <elendil@planet.nl> wrote:

> On Thursday 20 December 2007, Alan Cox wrote:
> > The kernel printk messages are sentences.
> 
> I'm afraid that I completely and utterly disagree. Kernel messages are _not_ 
> sentences. The vast majority is not well-formed and does not contain any of 
> the elements that are required for a proper sentence.
> 
> The most kernel messages can be compared to is a rather diverse and sloppy 
> enumeration. And enumerations follow completely different rules than 
> sentences. It can better be characterized as a "semi-random sequence of 
> context-sensitive technical messages".
> 
> IMHO the existing rule that "Kernel messages do not have to be terminated 
> with a period." is completely justified, though it does need some minor 
> clarification on the cases in which proper punctuation _should_ be 
> followed.

No-period is a kernel idiom, produces perfectly readable output, I have
never ever heard of anyone expressing the least concern over a lack of dots
at the end of their printks and 91% of kernel code agrees.

otoh the place where no-dots comes horridly unstuck is if a single printk
contains two sentences:

	printk("My computer caught on fire.  I hope yours does too\n");

that's really daft.  It's very rare though.


Of course one could always patch syslogd to add the dots, or change printk
and add an i_am_anal=1 kernel boot option.


Andy, please have an accident with that checkpatch change and let's hope
like hell that nobody starts trying to "fix" any of this.
