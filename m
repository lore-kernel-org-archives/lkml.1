Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZHQPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZHQPyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZHQPyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:54:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39538 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbZHQPya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:54:30 -0400
Date: Mon, 17 Aug 2009 17:53:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joseph Cihula <joseph.cihula@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Shane Wang <shane.wang@intel.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, andi@firstfloor.org,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com
Subject: Re: [RFC v6][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt
	shutdown support
Message-ID: <20090817155348.GA2254@elte.hu>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817154055.GA12985@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > +	tboot_create_trampoline();
> > +
> >  	/* Do the rest non-__init'ed, we're now alive */
> >  	rest_init();
> >  }
> 
> hm, this breaks the kernel build on every non-x86 architecture - 
> none of which has asm/tboot.h.

also, tboot modifies kernel/cpu.c (and that too breaks the build) - 
why? I've excluded x86/txt from tip:master for now.

	Ingo
