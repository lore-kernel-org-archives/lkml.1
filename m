Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYGMQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYGMQPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYGMQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 12:15:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:6591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYGMQPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 12:15:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,354,1212390000"; 
   d="scan'208";a="313176905"
Date: Sun, 13 Jul 2008 09:15:42 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make 64bit have get_apic_id
Message-ID: <20080713161542.GH1678@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com> <200807111844.17084.yhlu.kernel@gmail.com> <200807120101.20554.yhlu.kernel@gmail.com> <20080713062802.GC2534@elte.hu> <20080713065917.GA29634@elte.hu> <86802c440807130005x721b781dy6d4b569f4c736a22@mail.gmail.com> <20080713092324.GA12749@elte.hu> <20080713092823.GA21306@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080713092823.GA21306@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 02:28:23AM -0700, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > Yinghai, you had that x86/x2apic crash - do you think we can now
> > > > try it again in tip/master?
> > >
> > > Yes. it looks good now. I test it for two days already. no problem
> > > found.
> >
> > ok, thanks - i've merged it into tip/master and will do some more
> > testing myself as well.
> 
> the paravirt build is still broken:
> 
>  arch/x86/kernel/paravirt.c:377: error: expected identifier before ‘(' token
>  arch/x86/kernel/paravirt.c:378: error: expected ‘}' before ‘.' token
> 
> with:
> 
>   http://redhat.com/~mingo/misc/config-Sun_Jul_13_11_25_20_CEST_2008.bad

That's because of the Yinghai's, apic_ops patch for 32bit aswell.

Yinghai, we need to fix CONFIG_PARAVIRT aswell.

thanks,
suresh
