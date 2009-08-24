Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbZHXIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbZHXIsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZHXIsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:48:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53492 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZHXIsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:48:41 -0400
Date: Mon, 24 Aug 2009 10:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH] intel_txt: fix the build errors of intel_txt patch on
	non-X86 platforms
Message-ID: <20090824084821.GA29804@elte.hu>
References: <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com> <20090820161038.GA29994@basil.fritz.box> <4A8E9B3C.5070604@intel.com> <20090821135050.GA30346@elte.hu> <4A8EBBF6.3020505@intel.com> <20090821161204.GB17731@elte.hu> <4A8ED800.30901@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EC3ABB56@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EC3ABB56@pdsmsx502.ccr.corp.intel.com>
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


* Wang, Shane <shane.wang@intel.com> wrote:

> >> 
> >> If then these should be dummy inlines - but in any case, do you
> >> expect tboot to be used by non-x86 too?
> >> 
> > 
> > It would have to be IA64 ... I can't ask Tony since he's out, but I
> > would assume it is x86-specific at this point.
> > 
> > 	-hpa
> 
> Yes, to my knowledge, it is x86 at this point. TXT-SX is the 
> server extension also for ia32 only.

Then i'd suggest to keep it simple and clean for now and move those 
very few lines to arch/x86 files only. It will be easy to generalize 
it later on, should the need arise.

	Ingo
