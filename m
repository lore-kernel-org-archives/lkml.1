Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZGEGD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZGEGD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZGEGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:03:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZGEGDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:03:46 -0400
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090705002709.GA28424@elte.hu>
References: <20090703164225.GA21447@elte.hu>
	 <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>
	 <4A4FC5D0.6090000@kernel.org>  <20090705002709.GA28424@elte.hu>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 11:32:57 +0530
Message-Id: <1246773777.2325.113.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 02:27 +0200, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > >  static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
> > > +
> > >  static int __initdata debug_print;
> > > +#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
> > > +
> > > +
> > 
> > two blank lines?
> 
> ah, yes - i moved them around.
> 
> > > +#define BIOS_BUG_MSG KERN_WARNING \
> > > +	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
> > 
> > No user for this
> 
> yeah. Mind sending a patch for these? (and any other things you 
> might notice)
> 

But why you did this stupidity.

I clearly specified that these are trivial clean-ups, if you found any
issue in the patch you should ping me. Instead of adding crap from your
side.

Thanks,
--
JSR

