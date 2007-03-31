Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXCaICo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXCaICo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXCaICn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:02:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42347 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXCaICU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:02:20 -0400
Date: Sat, 31 Mar 2007 01:02:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
Message-Id: <20070331010213.b7aa4656.akpm@linux-foundation.org>
In-Reply-To: <460E1FC7.5030107@vmware.com>
References: <460E1FC7.5030107@vmware.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 00:45:59 -0800 Zachary Amsden <zach@vmware.com> wrote:

> +static void vmi_set_lazy_mode(int new_mode)
> +{
> +	static DEFINE_PER_CPU(int, mode);
> +	static DEFINE_PER_CPU(unsigned long, flags);
> +	int cpu = smp_processor_id();

That will cause upset if CONFIG_PREEMPT=y?
