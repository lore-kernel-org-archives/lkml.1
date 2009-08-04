Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZHDOc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZHDOc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbZHDOc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:32:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:57404 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbZHDOc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:32:26 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1454K1432R98dN10d1Izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNUWCX-03-KYV-01
Date: Tue, 4 Aug 2009 16:31:50 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sachin Sant <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090804143150.GC1870@aftab>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
 <4A718338.6050907@in.ibm.com>
 <20090730135623.GB16659@aftab>
 <20090803093144.GC9074@elte.hu>
 <20090803101401.GA14442@aftab>
 <20090803120739.GA29156@elte.hu>
 <20090803125059.GB14442@aftab>
 <20090804135029.GA6775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090804135029.GA6775@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Aug 2009 14:31:47.0090 (UTC) FILETIME=[4BEC0720:01CA1510]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:50:29PM +0200, Ingo Molnar wrote:
> > > Mind preparing a separate branch for it (.31-rc5 based) and send me 
> > > a pull request so that we can share the commit between the EDAC tree 
> > > and the x86 tree?
> > 
> > Well, Andreas says the patches need a little polishing and he'll 
> > be sending updated versions soon so you can pick them up. And 
> > since the EDAC MCE stuff might still change before .32 merge 
> > window opens, let's synchronize our pull requests instead. In the 
> > meantime, I'll be rediffing the EDAC stuff against -tip for 
> > linux-next.
> 
> Would you rebase just due to this commit?

No, I wanted to keep the opportunity to be able to rebase the whole
series until the very last minute before the merge window, should
anything need to be changed...

> No need for that, feel free to carry it until Andreas sends an updated
> version. Then i can put it into a separate .31-rc5 based topic that
> you can pull into the EDAC tree.

... and this is basically what I had in mind: After you pull them in,
I'll rebase my branch against yours for linux-next. I see that Stephen
pulls edac before -tip in linux-next so I'll ask him nicely to reorder
those. This approach makes most sense anyways since edac relies on a
bunch of x86 facilities (topology bits, rd/wrmsr_on_cpus, mcheck etc)
and it is only natural that it goes second in linux-next, right?

Then the pull requests will go out in the same order during the merge
window and we should be fine.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

