Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXB0KS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXB0KS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbXB0KS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:18:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXB0KS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:18:56 -0500
Date: Tue, 27 Feb 2007 11:11:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap slot
Message-ID: <20070227101143.GC10827@elte.hu>
References: <20070227081337.434798469@goop.org> <20070227081631.122933982@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227081631.122933982@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.1.7
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4067]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Allocate a fixmap slot for use by a paravirt_ops implementation.  Xen 
> uses this to map the hypervisor's shared info page, which doesn't have 
> a pseudo-physical page number, and therefore can't be mapped 
> ordinarily.

why not vmalloc it on the guest side? fixmaps are bad for this purpose 
for a general paravirt implementation, it limits the size of the shared 
info page, etc.

	Ingo
