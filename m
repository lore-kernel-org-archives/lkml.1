Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZLBINv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZLBINv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZLBINv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:13:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZLBINu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:13:50 -0500
Date: Wed, 2 Dec 2009 09:13:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] perf tools: allow cross compiling of perf tools
Message-ID: <20091202081337.GB16218@elte.hu>
References: <1259698310-11025-1-git-send-email-jamie@jamieiles.com>
 <1259699050.4003.15.camel@laptop>
 <1259699428.4003.23.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259699428.4003.23.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-12-01 at 21:24 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-12-01 at 20:11 +0000, Jamie Iles wrote:
> > > For embedded systems we need to cross compile applications on
> > > the build machine. Use the CROSS_COMPILE variable like the kernel
> > > itself.
> > > 
> > > Additionally, we can't use uname to determine whether we should
> > > build for 64 bit. Use the -dumpmachine flag of GCC to determine
> > > the target arch.
> > 
> > Hmm, and here I though Michael already send something similar to this..
> > but apparently I can't really find it
> 
> Ah, I'm turning senile, was looking at the wrong kernel tree.
> 
> Your patch is against something ancient too ;-)

yep. Jamie, you can find the latest perf code at:

  http://people.redhat.com/mingo/tip.git/README

mind checking it?

Thanks,

	Ingo
