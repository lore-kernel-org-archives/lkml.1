Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbYGOTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbYGOTZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYGOTZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:25:42 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:49913 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbYGOTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:25:41 -0400
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440807151222o541514c5n33c4179b84457637@mail.gmail.com>
References: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
	 <20080715185123.GA31445@linux-os.sc.intel.com>
	 <86802c440807151222o541514c5n33c4179b84457637@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:24:41 -0700
Message-Id: <1216149881.6620.197.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 12:22 -0700, Yinghai Lu wrote:
> On Tue, Jul 15, 2008 at 11:51 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > On Tue, Jul 15, 2008 at 11:38:50AM -0700, Zachary Amsden wrote:
> >>
> >> Nacked-by: Zachary Amsden <zach@vmware.com>
> >>
> >> What are you doing here and why aren't you cc-ing the maintainers?
> >
> > Sorry. I was about to bring you into the loop.
> >
> > Yinghai posted 32bit native apic_ops(similar to my 64bit apic ops patch, which
> > is different from pv_apic_ops) which is in tip/x86/x2apic and proposed a fix
> > for VMI case aswell.
> >
> > Based on my understanding, tip/x86/x2apic git commit
> > 94a8c3c2437c8946f1b6c8e0b2c560a7db8ed3c6 is wrong and it should be fixed with
> > something like
> > http://marc.info/?l=linux-kernel&m=121614328831237&w=2
> >
> > Can you please check and Ack/Nack this fix?
> 
> how about xen pv with icr related?

Xen doesn't have an APIC; they should be fine as is I think.

Zach

