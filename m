Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZIXDYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZIXDYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZIXDYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:24:11 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21576 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZIXDYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:24:11 -0400
Subject: Re: fixing "pci=use_crs"
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440909231628t6b35aae4u706c0c35590bc0d3@mail.gmail.com>
References: <200909161715.24376.bjorn.helgaas@hp.com>
	 <200909211520.56800.bjorn.helgaas@hp.com> <4AB95F41.1070500@lwfinger.net>
	 <200909231723.31786.bjorn.helgaas@hp.com>
	 <86802c440909231628t6b35aae4u706c0c35590bc0d3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 21:21:42 -0600
Message-Id: <1253762502.12653.4.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 16:28 -0700, Yinghai Lu wrote:
> On Wed, Sep 23, 2009 at 4:23 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> > P.S.  Yinghai, you posted some patches earlier dealing with "only one
> > HT chain."  You apparently have some insight into what's going on here,
> > but unfortunately, the changelogs mean absolutely nothing to me.  Can
> > you give me any clues?
> 
> which commit?
> 
> normally we only need to have split root resource into several pieces
> when we have two HT chains or other io chains...

I meant the patches here:
  http://lkml.org/lkml/2009/6/24/557

My opinion is that ACPI is there to give us an abstract description of
the machine, and we shouldn't have to introduce knowledge like "this
machine has two HT chains" or add checks in amd_bus.c about
"pci_root_num <= 1".

But maybe if I knew what an HT chain was and why you think it affects
the description returned by _CRS, it would give me a clue about how to
deal with this in a generic way.

Bjorn

