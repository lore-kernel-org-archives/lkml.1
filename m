Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXCPJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXCPJcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXCPJcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:32:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXCPJcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:32:05 -0400
Date: Fri, 16 Mar 2007 10:31:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap slot
Message-ID: <20070316093145.GR23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232526.730138638@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232526.730138638@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Allocate a fixmap slot for use by a paravirt_ops implementation.  This 
> is intended for early-boot bootstrap mappings.  Once the zones and 
> allocator have been set up, it would be better to use get_vm_area() to 
> allocate some virtual space.
> 
> Xen uses this to map the hypervisor's shared info page, which doesn't 
> have a pseudo-physical page number, and therefore can't be mapped 
> ordinarily.  It is needed early because it contains the vcpu state, 
> including the interrupt mask.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
