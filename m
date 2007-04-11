Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXDKCen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXDKCen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXDKCen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:34:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56365 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbXDKCem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:34:42 -0400
Date: Tue, 10 Apr 2007 19:34:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?B?VuF6cXVleg==?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Build error : 2.6.21-rc6-mm1 on sparc64
Message-Id: <20070410193429.ffbfa33c.akpm@linux-foundation.org>
In-Reply-To: <1176257739.19452.13.camel@sebastian.intellilink.co.jp>
References: <20070411004838.GD15262@Krystal>
	<20070410181854.7d532c59.akpm@linux-foundation.org>
	<1176257739.19452.13.camel@sebastian.intellilink.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 11:15:39 +0900 Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> The problem is that to use hard_smp_processor_id in UP kernels just
> including linux/smp.h does not suffice anymore. Now
> hard_smp_processor_id is architecture specific code and consequently
> asm/smp.h should be included explicitly.

yeah.  The fact that linux/smp.h only exposes asm/smp.h if CONFIG_SMP hits
us again and again and again.  It would be good to fix that up, I guess by
including asm/smp.h unconditionally from within linux/smp.h.

But that's a separate little project.

> Mathieu, does the (untested) patch below fix this issue?

I'll test it.
