Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbYCDPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbYCDPRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYCDPRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:17:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845AbYCDPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:17:10 -0500
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080304144915.GA4457@elte.hu>
References: <20080225170134.GA15839@elte.hu>
	 <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
	 <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>
	 <1204310323.24514.1239870063@webmail.messagingengine.com>
	 <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>
	 <1204631082.16613.7.camel@muff>  <20080304144915.GA4457@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 15:16:12 +0000
Message-Id: <1204643772.2774.9.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 15:49 +0100, Ingo Molnar wrote:
> * Mark McLoughlin <markmc@redhat.com> wrote:
> 
> > > This is the second attempt at a i386-version of the ebda patch. I 
> > > hope that one of the Xen people will be able to check that this does 
> > > not break their setups, but I think it will be fine after their 
> > > patch to exclude the 0x9f000- 0x100000 area explicitly in their 
> > > setup.
> > 
> > Confirmed that with Ian's e820 map patch and your patch, Xen DomU 
> > boots fine.
> 
> hm, for now i've only got the patch below queued up for v2.6.25.
> 
> Could you check whether just the patch below ontop of -rc3-ish upstream 
> solves the problem too? The EBDA patch would be a bit risky now - it's 
> queued up for v2.6.26 at the moment.

Sorry, perhaps I wasn't clear.

Ian's patch to add a hole in the e820 map fixes the problem without any
other patch.

I was just confirming to Alexander that his EBDA patch didn't break
anything further.

Thanks,
Mark.

