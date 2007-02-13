Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXBMWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXBMWUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXBMWUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:20:46 -0500
Received: from mail.suse.de ([195.135.220.2]:49378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXBMWUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:20:45 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eranian@hpl.hp.com, linux-ia64@vger.kernel.org,
       perfctr-devel@lists.sourceforge.net, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Subject: Re: 2.6.20 new perfmon code base + libpfm + pfmon
References: <20070213184839.GC10031@frankl.hpl.hp.com>
	<20070213140533.a5ca27ad.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Feb 2007 00:20:56 +0100
In-Reply-To: <20070213140533.a5ca27ad.akpm@linux-foundation.org>
Message-ID: <p737iulhcfb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> > On Tue, 13 Feb 2007 10:48:39 -0800 Stephane Eranian <eranian@hpl.hp.com> wrote:
> > I have released another version of the perfmon new code base package.
> 
> Can we have a bug push to get this merged up please?

Yes, there certainly seems to be user interest in this.

I've been merging the x86 specific infrastructure Stephane sent.
So hopefully the basics are there already.

The big open question was still the review of the syscall interface.
Probably needs some determined reviewers.

I did a review of some of the basic low level code some time ago;
there were some issues but I believe they are probably all resolved
by now (but I haven't verified that recently) 

-Andi
