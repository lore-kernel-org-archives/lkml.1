Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXBFMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXBFMc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXBFMc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:32:58 -0500
Received: from colin.muc.de ([193.149.48.1]:3448 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXBFMc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:32:58 -0500
Date: 6 Feb 2007 13:32:56 +0100
Date: Tue, 6 Feb 2007 13:32:56 +0100
From: Andi Kleen <ak@muc.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/11] Sched clock paravirt op
Message-ID: <20070206123256.GF47229@muc.de>
References: <200702060352.l163qeAf000727@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702060352.l163qeAf000727@zach-dev.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  	.write_msr = native_write_msr,
>  	.read_tsc = native_read_tsc,
>  	.read_pmc = native_read_pmc,
> +	.get_scheduled_cycles = native_read_tsc,
> +	.get_cpu_khz = native_calculate_cpu_khz,
>  	.load_tr_desc = native_load_tr_desc,
Description missing? 

Please write at least two paragraphs or more on each new hook
you want to add.

My feeling is that rdtsc should work fine here. If not please explain.

-Andi

