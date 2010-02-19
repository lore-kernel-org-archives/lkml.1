Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0BSPsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:48:54 -0500
Received: from www.tglx.de ([62.245.132.106]:40527 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0BSPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:48:53 -0500
Date: Fri, 19 Feb 2010 16:46:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
In-Reply-To: <20100219121734.GA8300@basil.fritz.box>
Message-ID: <alpine.LFD.2.00.1002191423480.2811@localhost.localdomain>
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain>
 <20100219121734.GA8300@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Fri, 19 Feb 2010, Andi Kleen wrote:
> > and integrate it
> > into perf as the suitable event logging mechanism.
> 
> The main reason I didn't react to that proposal is
> I don't see a clear path to make perf a good error mechanism.

Thanks for confirming the main problem here:

  _You_ do not react, because _you_ do not see a clear path.
 
So _you_ ignore any request for a major cleanup of that whole MCE mess
and just keep on tinkering with the existing crap.

And you really expect us to tolerate your ignorance forever and just
apply happily more crap to something which should have never been
merged in the first place.

<snip>

> The patch above was simply intended to solve a specific problem on a specific 
> chip.  I don't claim the interface is the best I ever did (definitely not), 
> but at least it solves an existing problem in a relatively straight forward
> way and I claim there's no clear better solution with today's infrastructure.

The patch does not solve a specific problem. It merily adds extra info
retrieved from this specific chip. This is simply a new feature which
you hacked into the existing mce code.

There will always be a next generation chip with a specific new
feature and it does _NOT_ matter at all whether support for such a new
feature is straight forward in your opinion or not. Straight forward
crap is still crap.

The whole point is that we are not longer accepting whacky addons to
MCE w/o seing any collaborative reaction from your side on our
technical requests to fix up the whole thing for real.

You can point me to as many PDFs as you want. I'm not interested in
stuff you are breeding on your own w/o talking to EDAC folks and
trying to address the concerns which were raised by Ingo, myself and
others.

Thanks,

	tglx
