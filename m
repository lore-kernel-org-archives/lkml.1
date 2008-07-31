Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYGaVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYGaVwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYGaVwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:52:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772AbYGaVwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:52:14 -0400
Date: Thu, 31 Jul 2008 23:51:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Eduardo Habkost <ehabkost@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] paravirt_ops: Use unsigned long instead of u32 for
	alloc_p*() pfn args
Message-ID: <20080731215158.GA23801@elte.hu>
References: <1217453547-22231-1-git-send-email-ehabkost@redhat.com> <4890E251.1090008@goop.org> <1217455193.30348.341.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217455193.30348.341.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> On Wed, 2008-07-30 at 14:51 -0700, Jeremy Fitzhardinge wrote:
> > Eduardo Habkost wrote:
> > > This patch changes the pfn args from 'u32' to 'unsigned long'
> > > on alloc_p*() functions on paravirt_ops, and the corresponding
> > > implementations for Xen and VMI. The prototypes for CONFIG_PARAVIRT=n
> > > are already using unsigned long, so paravirt.h now matches the prototypes
> > > on asm-x86/pgalloc.h.
> > >
> > > It shouldn't result in any changes on generated code on 32-bit, with
> > > or without CONFIG_PARAVIRT. On both cases, 'codiff -f' didn't show any
> > > change after applying this patch.
> > >
> > > On 64-bit, there are (expected) binary changes only when CONFIG_PARAVIRT
> > > is enabled, as the patch is really supposed to change the size of the
> > > pfn args.
> > >
> > > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> > >
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > Cc:ing Zach, since it touches vmi.
> 
> Thanks, looks good to me.  I always thought u32 is ugly type name anyway.
> 
> Acked-by: Zachary Amsden <zach@vmware.com>

thanks, queued it up into tip/x86/paravirt.

	Ingo
