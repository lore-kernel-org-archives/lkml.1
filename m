Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZBXQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZBXQbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBXQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:31:07 -0500
Received: from www.tglx.de ([62.245.132.106]:41629 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbZBXQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:31:06 -0500
Date: Tue, 24 Feb 2009 17:30:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc6-rt2
In-Reply-To: <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain> <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Thomas Gleixner wrote:
> >  [<c0440ef1>] internal_add_timer+0x88/0x8c
> 
> Can you try to enable the following config options:
> 
> CONFIG_DEBUG_OBJECTS
> CONFIG_DEBUG_OBJECTS_FREE
> CONFIG_DEBUG_OBJECTS_TIMERS
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT

Don't bother. Just noticed that this is nf_conntrack context. Working
on that right now.

Thanks,

	tglx
