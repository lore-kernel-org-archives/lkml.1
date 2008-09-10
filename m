Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIJSYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIJSYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYIJSYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:24:00 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:56269 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751763AbYIJSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:24:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GcmtdPp6NMUSsVVg5i57e9rsommfo+kbCq/m3xeOcFP9Xf/a7SWQE2lTReW+XnY2yhkDXu0xYM6qKjH+ZUiiNR++RulML8lMKv6avq7UPz7G/mzmQpBki0ZywEJUeBuB;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Date: Wed, 10 Sep 2008 11:23:46 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com> <200809101048.57119.jbarnes@virtuousgeek.org> <20080910180821.GA6864@elte.hu>
In-Reply-To: <20080910180821.GA6864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101123.46618.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2008 11:08 am Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Wednesday, September 10, 2008 1:44 am Ingo Molnar wrote:
> > > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > > print out for Device BAR address before kernel try to update them.
> > > >
> > > > also change it to KERN_DEBUG instead...
> > > >
> > > > v2: update to linux-pci next
> > > >    also add (unsigned long long) cast
> > > >
> > > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >
> > > Jesse, if you want to pick it up, could we please do this via git
> > > methods (git-pull and stuff)? The commit below is the one in -tip -
> > > should i separate it out?
> >
> > Sure, though I'm not sure why I shouldn't just be applying this stuff
> > to my tree first... Seems weird to pull from you only to then ask
> > Linus to pull.
>
> sure - it's just that it all happened weeks ago so it's intermixed. As
> long as you dont mind the duplicate commit (git will sort it out fine)
> we can apply it to both trees.

Ah I see, sure I can pull your bits.  /me gets out his breadcrumbs in 
preparation for entering the x86 forest.  Does your -tip just contain stuff 
you're sending to Linus for 2.6.27?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
