Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320Ab0ADKhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0ADKhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184Ab0ADKhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:37:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0ADKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:37:32 -0500
Subject: Re: [tip:sched/urgent] sched: might_sleep(): Make file parameter
 const char *
From: Peter Zijlstra <peterz@infradead.org>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100104104904.65f57a24@marrow.netinsight.se>
References: <20091223110818.442d848e@marrow.netinsight.se>
	 <tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
	 <1262088708.7135.133.camel@laptop>
	 <20100104104904.65f57a24@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 11:36:25 +0100
Message-ID: <1262601385.6408.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 10:49 +0100, Simon Kagstrom wrote:
> (Back from vacation, hence the delayed response)
> 
> On Tue, 29 Dec 2009 13:11:48 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-12-28 at 10:10 +0000, tip-bot for Simon Kagstrom wrote:
> > 
> > > Fixes a warning when building with g++:
> > 
> > However did you manage to build stuff with g++? The kernel very
> > frequently uses C++ keywords for other things.
> 
> I expected this question :-)
> 
> Yes, there are some workarounds we have to make to get it compiling
> (like #define new NEW prior to including the headers), but it works
> out. I know this is something you shouldn't do, and I debated whether
> to mention C++ at all. 
> 
> 
> Anyway, I think the change itself makes sense for plain C as well. The
> comment just described the context where it showed up for us.

Oh sure, the change is fine, just wondering what specific drug you were
using as it was not the regular kernel kind ;-)

