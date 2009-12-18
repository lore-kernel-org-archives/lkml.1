Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbZLRTax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbZLRTax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZLRTaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:30:52 -0500
Received: from www.sr71.net ([198.145.64.142]:53839 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZLRTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:30:51 -0500
Subject: Re: -tip: origin tree boot crash
From: Dave Hansen <dave@sr71.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091218170622.GA1354@elte.hu>
References: <20091218164509.GA14574@elte.hu>
	 <1261155689.27372.1444.camel@nimitz>  <20091218170622.GA1354@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 11:30:50 -0800
Message-Id: <1261164650.27372.1742.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:06 +0100, Ingo Molnar wrote:
> * Dave Hansen <dave@sr71.net> wrote:
> I just double-checked it again on a couple of my systems and it seems to 
> > deny loading the module correctly.
> > 
> > What kind of hardware is this?  Could you send me 'dmidecode' output?
> > 
> > I'm wondering if your hardware matched the "Intel" string somehow and the 
> > dmi code didn't bother to check anything else.  I'll also go try and run on 
> > a few more pieces of hardware and see if I can get it to trigger.
> 
> It's an Athlon64 whitebox PC - a pretty old one - and nothing special.
> 
> Also note the crash signature - it crashes in the DMI code. Note, this is a 
> built-in-driver (not a modular driver) bootup.

I figured as much since you said it was a real bootup problem.  I've
been testing the same way.

I've tried a few other pieces of hardware that I have sitting around and
can't seem to recreate this.  I've also double-checked the code to look
for any obvious bugs.  No luck on either front.  You didn't see any
other dmesg output from these, did you?

                pr_info("skipping hardware autodetection\n");
                pr_info("Please send 'dmidecode' output to dave@sr71.net\n");


-- Dave

