Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZK3LFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZK3LFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZK3LFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:05:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZK3LFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:05:35 -0500
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
In-Reply-To: <1259578793.20516.130.camel@laptop>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
	 <1258985167-29178-11-git-send-email-gleb@redhat.com>
	 <1258990455.4531.594.camel@laptop> <20091123155851.GU2999@redhat.com>
	 <alpine.DEB.2.00.0911231128190.785@router.home>
	 <20091124071250.GC2999@redhat.com>
	 <alpine.DEB.2.00.0911240906360.14045@router.home>
	 <20091130105612.GF30150@redhat.com>  <20091130105812.GG30150@redhat.com>
	 <1259578793.20516.130.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 12:05:14 +0100
Message-ID: <1259579114.20516.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 11:59 +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-30 at 12:58 +0200, Gleb Natapov wrote:
> > On Mon, Nov 30, 2009 at 12:56:12PM +0200, Gleb Natapov wrote:
> > > On Tue, Nov 24, 2009 at 09:14:03AM -0600, Christoph Lameter wrote:
> > > > On Tue, 24 Nov 2009, Gleb Natapov wrote:
> > > > 
> > > > > On Mon, Nov 23, 2009 at 11:30:02AM -0600, Christoph Lameter wrote:
> > > > > > This adds significant overhead for the !PREEMPT case adding lots of code
> > > > > > in critical paths all over the place.
> > > > > I want to measure it. Can you suggest benchmarks to try?
> > > > 
> > > > AIM9 (reaim9)?
> > > Below are results for kernel 2.6.32-rc8 with and without the patch (only
> > > this single patch is applied).
> > > 
> > Forgot to tell. The results are average between 5 different runs.
> 
> Would be good to also report the variance over those 5 runs, allows us
> to see if the difference is within the noise.

Got pointed to the fact that there is a stddev column right there.

Must be Monday or something ;-)

