Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYKTQcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYKTQcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYKTQcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:32:17 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2862 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYKTQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:32:17 -0500
Date: Thu, 20 Nov 2008 17:29:24 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving out of the macros
Message-ID: <20081120162924.GA4243@mailshack.com>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081120155744.GA4130@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120155744.GA4130@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 20 Nov 2008 17:31:44 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.34; VDF: 7.1.0.115; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 04:57:44PM +0100, Alexander van Heukelum wrote:
> On Thu, Nov 20, 2008 at 04:39:54PM +0100, Ingo Molnar wrote:
> > > > Note, i did a small rename:
> > > > 
> > > >     cfi_pushq  =>  pushq_cfi
> > > >     cfi_popq   =>  popq_cfi
> > > >     cfi_store  =>  movq_cfi
> 
> Does not work... But if you are attached to the underscores, I
> think we can force it to work by using CPP to convert it to
> something the assembler does parse right:

Hi Ingo,

False alarm. It's happily building at the moment. Does it still
fail for you?

Greetings,
	Alexander

> #define pushq_cfi pushq.cfi
> 
> etc?
> 
> Or is that just too ugly?
> 
> Alexander
