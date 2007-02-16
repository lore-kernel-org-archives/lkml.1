Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbXBPMRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbXBPMRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXBPMRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:17:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:55038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbXBPMRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:17:03 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Fri, 16 Feb 2007 13:16:41 +0100
User-Agent: KMail/1.9.5
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161316.41237.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I expect the most it makes sense to aim for 2.6.22 are the genirq
> changes so the internal arch code is passing struct irq_desc
> everywhere internally. 

Are there any livetime issues with passing pointers around? 
e.g. what happens on APIC hotunplug etc.? We don't necessarily
support that yet, but for a big interface change it should 
be probably kept in mind first.

-Andi
