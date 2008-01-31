Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbYAaIuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbYAaIuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbYAaIuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:50:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760045AbYAaIub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:50:31 -0500
Date: Thu, 31 Jan 2008 09:50:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: travis@sgi.com, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/6] s390: Use generic percpu linux-2.6.git
Message-ID: <20080131085013.GB1585@elte.hu>
References: <20080130180940.022172000@sgi.com> <20080130180940.921597000@sgi.com> <20080130215339.GC28242@elte.hu> <1201768346.18221.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201768346.18221.5.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Wed, 2008-01-30 at 22:53 +0100, Ingo Molnar wrote:
> > * travis@sgi.com <travis@sgi.com> wrote:
> > 
> > > Change s390 percpu.h to use asm-generic/percpu.h
> > 
> > do the s390 maintainer agree with this change (Acks please), and has it 
> > been tested on s390?
> 
> Now I'm confused. The patch has been acked a few weeks ago and the 
> last 5+ version of the patch had the acked line. The lastest version 
> dropped it for a reason I don't know. And more, the patch is already 
> upstream with the (correct) acked line, see git commit 
> f034347470e486835ccdcd7a5bb2ceb417be11c4. So, what is the problem ?

the latest patch was sent without your acked line and i asked about 
that. But later on Mike told me that you acked it - so i restored the 
ack and the patch, Linus pulled the fixes and it now all is upstream and 
all architectures should be fine again now.

	Ingo
