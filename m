Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbZHUXoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbZHUXoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZHUXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:44:10 -0400
Received: from www.tglx.de ([62.245.132.106]:60750 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbZHUXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:44:09 -0400
Date: Sat, 22 Aug 2009 01:42:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [RFC patch 16/32] x86: Replace ARCH_SETUP by a proper platform
 function
In-Reply-To: <4A8F1FEA.1060706@goop.org>
Message-ID: <alpine.LFD.2.00.0908220139390.1769@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205602.584376844@linutronix.de> <4A8F1FEA.1060706@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Jeremy Fitzhardinge wrote:

> On 08/21/09 14:30, Thomas Gleixner wrote:
> > ARCH_SETUP is a horrible hack of paravirt/xen which is way nicer to
> > read as a platform setup function.
> >   
> 
> Not really correct; its a left-over from the old subarch stuff.  But it
> was certainly never very pretty.

Oops. Sorry, I squeezed the history out of my brain and my
subconscious mind attributed it to paravirt/xen :)

Will fix the comment.

Thanks,

	tglx
