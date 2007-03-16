Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXCPJVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXCPJVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXCPJVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:21:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbXCPJVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:21:53 -0400
Date: Fri, 16 Mar 2007 10:20:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [patch 14/26] Xen-paravirt_ops: add common patching machinery
Message-ID: <20070316092054.GK23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232528.055105942@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232528.055105942@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Implement the actual patching machinery.  paravirt_patch_default() 
> contains the logic to automatically patch a callsite based on a few 
> simple rules:
> 
>  - if the paravirt_op function is paravirt_nop, then patch nops
>  - if the paravirt_op function is a jmp target, then jmp to it
>  - if the paravirt_op function is callable and doesn't clobber too much
>     for the callsite, call it directly
> 
> paravirt_patch_default is suitable as a default implementation of 
> paravirt_ops.patch, will remove most of the expensive indirect calls 
> in favour of either a direct call or a pile of nops.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
