Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbZE3Uck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbZE3Uck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZE3Ucb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 16:32:31 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:52970 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZE3Ucb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 16:32:31 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
Date: Sat, 30 May 2009 15:32:28 -0500
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <200905300713.23741.lkml@morethan.org> <4A2187BF.1070205@zytor.com>
In-Reply-To: <4A2187BF.1070205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905301532.30450.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 30 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > On Sat May 30 2009, Pavel Machek wrote:
> >> Hi!
> >>
> >>> --- a/Documentation/kernel-parameters.txt
> >>> +++ b/Documentation/kernel-parameters.txt
> >>> @@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
> >>>  			register save and restore. The kernel will only save
> >>>  			legacy floating-point registers on task switch.
> >>>  
> >>> +	noxsave		[BUGS=X86] Disables x86 extended register state save
> >>> +			and restore using xsave. The kernel will fallback to
> >>> +			enabling legacy floating-point and sse state.
> >>> +
> >> Does that mean apps using sse8 will see their registers corrupted if
> >> this option is used? Or are new registers sets always added in a way
> >> that kernel has to enable them first?
> 
> New register sets always require enabling.
> 
> > Has this change been tested on the processors that have independent ftp&sse
> > units, without the shared registers?  Such as the VIA C7-M?
> 
> x87 and SSE are always separate.  Whether or not register sets are
> separate is an architectural issue, and isn't subject to variation
> across CPUs.
> 

In this case they are but I am glad to hear that Intel and VIA Tech.
are working this closely together.  It simplifies the support issues.

Mike
> 	-hpa
> 


