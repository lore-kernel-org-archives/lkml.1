Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXCaC40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXCaC40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933539AbXCaC40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:56:26 -0400
Received: from ozlabs.org ([203.10.76.45]:52886 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933425AbXCaC4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:56:25 -0400
Subject: Re: [patch 0/6] i386 gdt and percpu cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070331020042.003398870@goop.org>
References: <20070331020042.003398870@goop.org>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 12:56:01 +1000
Message-Id: <1175309761.12230.422.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  - some improvements to asm-i386/percpu.h to make asm access to percpu
>    variables easy

One nitpick: I'd really like PER_CPU() renamed to PER_CPU_ADDR().
That's a separate patch, but I think would be far clearer.

Thanks,
Rusty.


