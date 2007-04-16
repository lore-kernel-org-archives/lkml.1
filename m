Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXDPFtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXDPFtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXDPFtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:49:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:4982 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbXDPFtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=b7Q+VijoARv3IyCLuW3QkVRJy6RPVef+WbPjhq7q6FaGbfvDM/yKIxOrjqOMUFuK/iRk6Teq86MdmjVmHzuxfwWL+LJm8AY1HhaE4jINecgUgYlDreNXRu6amAj2SByn4HOB3/4rK880kuVfDoOtZhBAaxjg0Ezn3NvccR+I0U4=
Organization: Organization? Not detectable
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 01:48:58 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <20070415150536.GA6623@elte.hu> <200704161516.12746.kernel@kolivas.org>
In-Reply-To: <200704161516.12746.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704160148.59435.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007, Con Kolivas wrote:

And I snipped, Sorry fellas.

Con's original submission was to me, quite an improvement.  But I have to say 
it, and no denegration of your efforts is intended Con, but you did 'pull the 
trigger' and get this thing rolling by scratching the itch & drawing 
attention to an ugly lack of user interactivity that had crept into the 2.6 
family.  So from me to Con, a tip of the hat, and a deep bow in your 
direction, thank you.  Now, you have done what you aimed to do, so please get 
well.

I've now been through most of an amanda session using Ingo's "CFS" and I have 
to say that it is another improvement over your 0.40 that's is just as 
obvious as your first patch was against the stock scheduler.  No other 
scheduler yet has allowed the full utilization of the cpu, and maintained 
user interactivity as well as this one has,  my cpu is running about 5 
degrees F hotter just from this effect alone.  gzip, if the rest of the 
system is in between tasks, is consistently showing around 95%, but let 
anything else stick up its hand, like procmail etc, and gzip now dutifully 
steps aside, dropping into the 40% range until procmail and spamd are done, 
at which point there is no rest for the wicked and the cpu never gets a 
chance to cool.

There was, just now, a pause of about 2 seconds, while amanda moved a tarball 
from the holding disk area on /dev/hda to the vtapes disk on /dev/hdd, so 
that would have been an I/O bound situation.

This one Ingo, even without any other patches and I think I did see one go by 
in this thread which I didn't apply, is a definite keeper.  Sweet even.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
A word to the wise is enough.
		-- Miguel de Cervantes
