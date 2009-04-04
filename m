Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZDDGlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZDDGlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 02:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZDDGk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 02:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:47870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZDDGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 02:40:55 -0400
Subject: Re: [PATCH] x86: make mtrr code could use debugpat
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090404011805.GA19492@elte.hu>
References: <alpine.LFD.2.00.0903291553210.3948@localhost.localdomain>
	 <1238434120.4529.783.camel@localhost.localdomain>
	 <20090403175555.GH6295@elte.hu>
	 <alpine.LFD.2.00.0904031203400.4015@localhost.localdomain>
	 <20090403212152.GA3493@linux-os.sc.intel.com>
	 <alpine.LFD.2.00.0904031443340.7007@localhost.localdomain>
	 <alpine.LFD.2.00.0904031521460.3915@localhost.localdomain>
	 <20090403222928.GA6446@elte.hu> <49D68F4B.9010808@kernel.org>
	 <alpine.LFD.2.00.0904031737030.3915@localhost.localdomain>
	 <20090404011805.GA19492@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 12:09:36 +0530
Message-Id: <1238827176.4068.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 03:18 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, 3 Apr 2009, Yinghai Lu wrote:
> > > 
> > > only print out get_mtrr when debugpat
> > 
> > Is that get_mtrr message really so interesting that it needs to be 
> > printed out at all? Even with debugpat?
> 
> With debugpat it's probably interesting - i think only a very small 
> fraction of users will enable it, and if they do we really want to 
> track all MTRR state.
> 
> Since old MTRR state gets destroyed by new settings we better have a 
> clear idea how the BIOS set it, that might give us clues about 
> quirks, etc.
> 
> Based on MTRR bugreport patterns i was the one who asked Yinghai 
> during the development cycle to add more debugging there - so i'm to 
> blame for those printouts. We had several cases where it would have 
> been useful had we known the precise history of MTRR settings.
> 
> I was under the impression that KERN_DEBUG would only show up on the 
> console if 'debug' is passed in on the boot command line - but your 
> bootlog didnt have 'debug' in it and i guess having it so frequently 
> in the dmesg is confusing as well. It might even be there for every 
> Xorg startup.
> 
> Anyway ... the x86/urgent pull request i sent removes the printk 
> altogether.
> 

Thanks for removing those annoying lines.

--
JSR

