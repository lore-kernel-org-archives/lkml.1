Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXAXJbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXAXJbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXAXJbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:31:36 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38279 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXAXJbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:31:35 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070124070701.GA17654@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 01:30:16 -0800
Message-Id: <1169631016.19471.175.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 08:07 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > To lessen Andrews burden it would be wise to integrate the two trees 
> > prior to anything going into -mm .. [...]
> 
> i disagree. Thomas' tree has been tested in -rt for some time already, 
> and he's the author of this code so as far as i'm concerned he calls the 
> shots of what to do and in what order to do. He did the overwhelming 
> majority of regression fixes of dynticks/hrt stuff both in -mm and in 
> -rt. So why should i not take his queue over yours? Last i checked your 
> queue didnt really do anything substantial to the code - other than 
> shuffling around wast amounts of code around. Even this latest iteration 
> from Thomas that is now in -rt is working well on the target platform we 
> are aiming for currently (i686). (and it's working on x86_64 as well in 
> -rt)
> 
> 	Ingo

The majority of the new code was added yesterday in -rt8. Here is the
interdiff between -rt7 and -rt7

ftp://source.mvista.com/pub/dwalker/rt-interdiffs/patch-2.6.20-rc5-rt7-patch-2.6.20-rc5-rt8.patch

Since this new release has a fair amount of new code it's not totally
fair to says "it's been in -rt for a while".

My queue has always been 90% clean up, some of that is moving code
around. That's not all it does, and you can make an apples to apples
comparison between my tree and parts of this _new_ high res/dynamic tick
queue. 

If stability is a question, -rt10 does currently compile for my test
config, due to this new HRT introduction. I know from experience it's
going to take Thomas at least a few days just to make this new code
compile in all configs. This also means there are number of fairly
simple configs which this new HRT has not been tested in.

My patch set has been stable for months, and reviewed and tested by John
and I constantly (With you and Thomas on the CC list each release)..
It's a completely safe bet, IMO .

Daniel

