Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXFVPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXFVPcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbXFVPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:32:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbXFVPcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:32:46 -0400
Date: Fri, 22 Jun 2007 17:32:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622153232.GA31848@elte.hu>
References: <20070622080634.GP3723@sequoia.sous-sol.org> <20070622083330.GB19382@elte.hu> <20070622152915.GQ3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622152915.GQ3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> > thanks! I ran into this before and asked for the fastcalls to not be 
> > removed from upstream paravirt.c but to no avail it seems. It does 
> > no harm to anyone to keep the 'fastcall' declarations and 
> > definitions for places where _actual assembly code_ depends on the 
> > calling convention. Could someone please send this upstream-wards 
> > too?
> 
> Yes, I agree, it's actually documenting the subtlety of the calling 
> convention, not just noise in the source.  The upstream patch is 
> different, I'll sort one out.

great!

	Ingo
