Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYC0MJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYC0MJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYC0MIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:08:54 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:42899 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbYC0MIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:08:53 -0400
Date: Thu, 27 Mar 2008 13:08:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>, "Huang, Ying" <ying.huang@intel.com>,
       hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] x86_64 boot: Add free_early to early reservation machanism
Message-ID: <20080327120850.GC6589@basil.nowhere.org>
References: <1206601746.3067.21.camel@caritas-dev.intel.com> <20080327063411.8611cd8f.pj@sgi.com> <20080327115851.GD13538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327115851.GD13538@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Mar 2008 12:02:13.0027 (UTC) FILETIME=[647C6F30:01C89002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 12:58:51PM +0100, Ingo Molnar wrote:
> 
> * Paul Jackson <pj@sgi.com> wrote:
> 
> > Huang wrote:
> > > +		panic("free_early on not reserved area: %lx-%lx!", start, end);
> > 
> > Should that be 'early_panic', not 'panic' ?
> > 
> > (I see a couple more panics in that file, which I wonder
> > if should be early_panic as well ?)
> 
> this should be fixed properly btw: panic() should self-select whether it 
> does an early_panic() or a real panic().

There's also need of a EARLY_BUG, but self selection would be a little
tricky here.

I still have an old patch for this, but I haven't gotten around to submit it
because it turned out the first user of it wasn't a good idea.

-Andi
