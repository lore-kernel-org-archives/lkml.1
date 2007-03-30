Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXC3Vks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXC3Vks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXC3Vks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:40:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:52050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbXC3Vkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:40:47 -0400
Date: Fri, 30 Mar 2007 14:38:50 -0700
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Mathieu B??rard <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [1/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070330213850.GA5564@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070330213209.GM14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330213209.GM14134@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 11:32:09PM +0200, Adrian Bunk wrote:
> Subject    : hung bootup in various drivers
> References : http://lkml.org/lkml/2007/3/30/68
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Handled-By : Ingo Molnar <mingo@elte.hu>
>              Greg KH <gregkh@suse.de>
>              Kay Sievers <kay.sievers@vrfy.org>
> Status     : problem is being discussed

Note, this should probably read:
	hung bootup for drivers built into the kernel, that fail their
	module_init() call.

A much smaller minority of cases :)

thanks,

greg k-h
