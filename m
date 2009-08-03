Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZHCMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZHCMvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZHCMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:51:09 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37712 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbZHCMvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:51:08 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R15bfO98dNzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNSX0W-02-00S-02
X-M-MSG: 
Date: Mon, 3 Aug 2009 14:50:59 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sachin Sant <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090803125059.GB14442@aftab>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
 <4A718338.6050907@in.ibm.com>
 <20090730135623.GB16659@aftab>
 <20090803093144.GC9074@elte.hu>
 <20090803101401.GA14442@aftab>
 <20090803120739.GA29156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090803120739.GA29156@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Aug 2009 12:50:57.0157 (UTC) FILETIME=[0B77C350:01CA1439]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Aug 03, 2009 at 02:07:39PM +0200, Ingo Molnar wrote:
> The thing that was blocking this commit is really the insufficient 
> sched-domains integration of said NUMA bits. I think the NUMA bits 
> look good and if the EDAC tree makes use of it we can merge it in 
> .32.
>
> Mind preparing a separate branch for it (.31-rc5 based) and send me 
> a pull request so that we can share the commit between the EDAC tree 
> and the x86 tree?

Well, Andreas says the patches need a little polishing and he'll be
sending updated versions soon so you can pick them up. And since the
EDAC MCE stuff might still change before .32 merge window opens,
let's synchronize our pull requests instead. In the meantime, I'll be
rediffing the EDAC stuff against -tip for linux-next.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

