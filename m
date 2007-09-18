Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXIRSVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXIRSVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXIRSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:21:22 -0400
Received: from mail.suse.de ([195.135.220.2]:38330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXIRSVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:21:22 -0400
To: Robby Workman <rw@rlworkman.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CPU too old panic on Centrino proc - 2.6.22.6
References: <46EFF173.4010104@rlworkman.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 Sep 2007 20:21:20 +0200
In-Reply-To: <46EFF173.4010104@rlworkman.net>
Message-ID: <p73sl5bx2an.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robby Workman <rw@rlworkman.net> writes:

> On booting a 2.6.22.6 kernel with SMP support, I get a panic
> immediately:
>   PANIC: CPU too old for this kernel
> This panic does not occur on a non-SMP kernel having almost
> identical configuration.
> 
> This is on a Thinkpad T41:
>   /proc/cpuinfo --> http://rlworkman.net/cpuinfo
>   dmesg --> http://rlworkman.net/dmesg
>   kernel config --> http://rlworkman.net/config-2.6.22.6
> 
> The 2.6.21.5 SMP kernels from Slackware 12.0 all boot properly, and
> the config for this 2.6.22.6 SMP kernel is based on the one from 12.0.
> 
> I'm basically reaching for clues at this point -- is this a PEBKAC on
> my part?  What other information would be useful?

Most likely you enabled CONFIG_HIGHMEM64G. Banias didn't support 
PAE.

-Andi
