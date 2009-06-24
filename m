Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZFXHDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZFXHDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZFXHDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:03:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55064 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZFXHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:03:07 -0400
Date: Wed, 24 Jun 2009 16:02:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 2.6.31-rc1, part 3.
Message-ID: <20090624070205.GA2079@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090623184032.GA713@linux-sh.org> <20090624013137.GC3101@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624013137.GC3101@bombadil.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:31:37PM -0400, Kyle McMartin wrote:
> On Wed, Jun 24, 2009 at 03:40:33AM +0900, Paul Mundt wrote:
> >       sh: Fix up HAVE_PERF_COUNTERS typo.
> > 
> 
> just fyi while wiring this up myself...
> 
> Your set_perf_counter_pending when CONFIG_PERF_COUNTERS=y is wrong,
> as it's a extern in <linux/perf_counters.h>, you'll probably want to
> make it a static inline. (Yeah, I blagged your header. ;-)
> 
Figures, I copied it from an earlier x86 version ;-)

I'll fix it up, thanks for the note.
