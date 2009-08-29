Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZH2RBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZH2RBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 13:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZH2RB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 13:01:29 -0400
Received: from www.tglx.de ([62.245.132.106]:36805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZH2RB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 13:01:29 -0400
Date: Sat, 29 Aug 2009 18:59:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Subject: Re: [RFC PATCH 0/7] x86/boot: Moorestown patch set based on platform_set
 abstraction
In-Reply-To: <43F901BD926A4E43B106BF17856F07556A5EA86F@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908291858400.19335@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org> <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain> <43F901BD926A4E43B106BF17856F07556A5EA86F@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Pan, Jacob jun wrote:

> Based on platform_setup patchset posted by tglx (http://lkml.org/lkml/2009/8/21/358)
> 
> These Moorestown patches have become much simplified once ported to the new
> platform_setup layer. 
> 
> Now the platform feature flags are less useful, in fact they
> are only used in separating ioapic and 8259 now, so once the interrupt
> controller code is drivernized, we would not need the platform feature flags
> in the core.

I don't think that we need big changes in the ioapic code. All you
need can be done with way simpler tweaking.

Thanks,

	tglx


