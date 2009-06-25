Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZFYWBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZFYWBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFYWBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:01:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZFYWBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:01:16 -0400
Date: Thu, 25 Jun 2009 15:00:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       chrisw@redhat.com, akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
In-Reply-To: <1245966743.30355.42.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.01.0906251459320.3605@localhost.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com>  <20090625095643F.fujita.tomonori@lab.ntt.co.jp>  <20090625041605.GA9330@linux-os.sc.intel.com>  <20090625134827W.fujita.tomonori@lab.ntt.co.jp>  <1245913886.17089.91.camel@macbook.infradead.org>
 <1245966743.30355.42.camel@macbook.infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, David Woodhouse wrote:

> On Thu, 2009-06-25 at 08:11 +0100, David Woodhouse wrote:
> > It raises the question: Why are we using firmware-specific interfaces to
> > list the available memory -- can't we get that from somewhere _generic_?
> > 
> > The less we tie our code to these crappy BIOS, EFI and ACPI interfaces,
> > the better off we'll be.
> 
> Does this work everywhere... ?

Whimper.

Please pleas please please.. Pretty please, let this work (instead of 
duplicating the insanity).

		Linus


