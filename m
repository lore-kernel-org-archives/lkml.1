Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZCRMZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZCRMZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZCRMY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:24:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40576 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZCRMY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:24:58 -0400
Date: Wed, 18 Mar 2009 17:55:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Kprobes: Fix locking imbalance in kretprobes
Message-ID: <20090318122500.GC4129@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090318113621.GB4129@in.ibm.com> <20090318115158.GF32233@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318115158.GF32233@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:51:58PM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > Fix locking imbalance in kretprobes:
> > 
> > =====================================
> > [ BUG: bad unlock balance detected! ]
> > -------------------------------------
> > kthreadd/2 is trying to release lock (&rp->lock) at:
> > [<c06b3080>] pre_handler_kretprobe+0xea/0xf4
> 
> Applied it to tip:tracing/kprobes, thanks Ananth!
> 
> The bug has been introduced in v2.6.27-rc1 so i've marked it for a 
> -stable backport for .27.x, 28.x and 29.x.

Sure, thanks Ingo!
