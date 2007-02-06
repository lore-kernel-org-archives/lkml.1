Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXBFM3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXBFM3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXBFM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:29:19 -0500
Received: from colin.muc.de ([193.149.48.1]:3888 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbXBFM3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:29:18 -0500
Date: 6 Feb 2007 13:29:17 +0100
Date: Tue, 6 Feb 2007 13:29:17 +0100
From: Andi Kleen <ak@muc.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 6/11] Vmi timer no idle hz fixes.patch
Message-ID: <20070206122917.GD47229@muc.de>
References: <200702060353.l163r9ec000751@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702060353.l163r9ec000751@zach-dev.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -#ifdef CONFIG_S390
> -#ifdef CONFIG_MATHEMU
> -	{
> -		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
> -		.procname	= "ieee_emulation_warnings",
> -		.data		= &sysctl_ieee_emulation_warnings,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= &proc_dointvec,
> -	},

I think there needs to be a way to have this syctl only
when it's really implemented for the paravirt ops.

I suppose you should move it to dynamic registration on demand.

-Andi
