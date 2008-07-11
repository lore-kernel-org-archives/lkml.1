Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYGKK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYGKK2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYGKK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:28:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYGKK2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:28:39 -0400
Date: Fri, 11 Jul 2008 12:28:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       jeremy@goop.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080711102814.GA17938@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710215617.GM1678@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, Jul 10, 2008 at 12:53:20PM -0700, Ingo Molnar wrote:
> > 
> > Btw., i threw it at the -tip test-cluster and got back a quick build
> > bugreport:
> > 
> > arch/x86/xen/enlighten.c: In function 'xen_patch':
> > arch/x86/xen/enlighten.c:1084: warning: label 'patch_site' defined but not used
> > arch/x86/xen/enlighten.c: At top level:
> > arch/x86/xen/enlighten.c:1272: error: expected identifier before '(' token
> > arch/x86/xen/enlighten.c:1273: error: expected '}' before '.' token
> > arch/x86/kernel/paravirt.c:376:2: error: invalid preprocessing directive
> > #ifndedarch/x86/kernel/paravirt.c:384:2: error: #endif without #if
> > 
> > with this config:
> > 
> >   http://redhat.com/~mingo/misc/config-Thu_Jul_10_21_43_28_CEST_2008.bad
> 
> Ingo, that was my stupid typo. Please apply this patch. BTW, we
> need some more xen64 paravirt fixes in this area. I will look at it
> as soon as possible.

applied to tip/x86/x2apic - thanks Suresh.

	Ingo
