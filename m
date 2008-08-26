Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYHZTfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYHZTfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbYHZTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:35:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44077 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758956AbYHZTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:35:18 -0400
Message-ID: <48B45AF4.8040101@sgi.com>
Date: Tue, 26 Aug 2008 12:35:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <48B452F3.9040304@sgi.com> <alpine.LFD.1.10.0808261205530.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808261205530.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 26 Aug 2008, Mike Travis wrote:
>> The need to allow distros to set NR_CPUS=4096 (and NODES_SHIFT=9) is
>> critical to our upcoming SGI systems using what we have been calling
>> "UV".
> 
> That's fine. You can do it. The default kernel will not, because it's 
> clearly not safe.
> 
> I really don't care what you do to _your_ images. But I will not 
> distribute a known-broken kernel, and I will not debug random stack 
> overflows that happen in it.
> 
> If you want the default kernel to support 4k cores, we'll need to fix the 
> stack usage.  I don't think that is impossible, but IT IS NOT GOING TO 
> HAPPEN for 2.6.27.
> 
> And quite frankly, if some vendor like RedHat enables NR_CPUS=4096 by 
> default, they are totally and utterly crazy.
> 
> But some SGI-specific binary that is meant for SGI machines only, and has 
> been extensively tested with the setup used on SGI machines is a different 
> thing.
> 
> 			Linus

Ok, thanks for the reply, and looking into this issue.  We will "strongly
encourage" our distros to base the relevant releases on 2.6.28. :-)  

[Supplying an SGI-specific kernel would not be acceptable to many of our
customers because of the certification issues I mentioned.] 

Mike
