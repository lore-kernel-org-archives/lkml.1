Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYGJUXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYGJUXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYGJUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:22:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:10397 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYGJUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,340,1212390000"; 
   d="scan'208";a="11610359"
Date: Thu, 10 Jul 2008 13:22:46 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080710202246.GK1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710195320.GA23322@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:53:20PM -0700, Ingo Molnar wrote:
> quite some stuff!
> 
> For review and testing purposes i've created a new topic branch for
> this: tip/x86/x2apic and have picked up your patches into it.
> 
> I've pushed it out, but it's not merged into tip/master yet (obviously,
> you sent this just a few minutes ago :)
> 
> It integrates fine with tip/master. If you do this:
> 
>   git-checkout tip/master
>   git-merge tip/x86/x2apic
> 
> you'll get a clean merge.
> 
> Btw., i threw it at the -tip test-cluster and got back a quick build
> bugreport:
> 
> arch/x86/xen/enlighten.c: In function 'xen_patch':
> arch/x86/xen/enlighten.c:1084: warning: label 'patch_site' defined but not used
> arch/x86/xen/enlighten.c: At top level:
> arch/x86/xen/enlighten.c:1272: error: expected identifier before '(' token
> arch/x86/xen/enlighten.c:1273: error: expected '}' before '.' token
> arch/x86/kernel/paravirt.c:376:2: error: invalid preprocessing directive
> #ifndedarch/x86/kernel/paravirt.c:384:2: error: #endif without #if
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Thu_Jul_10_21_43_28_CEST_2008.bad

Yes. It is conflicting with Jermey's recent changes. I will post the fixes
soon, meanwhile everything should be ok with !CONFIG_PARAVIRT

thanks,
suresh
