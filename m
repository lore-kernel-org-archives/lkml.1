Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYHSMMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYHSMMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYHSMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:12:41 -0400
Received: from mga05.intel.com ([192.55.52.89]:46265 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbYHSMMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:12:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,235,1217833200"; 
   d="scan'208";a="607916147"
Message-ID: <48AAB8B6.3020802@linux.intel.com>
Date: Tue, 19 Aug 2008 14:12:38 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com> <20080819094905.GA20590@elte.hu>
In-Reply-To: <20080819094905.GA20590@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
>> This gets rid of the suspend warnings, so it looks to be a step in the 
>> right direction! FWIW, you may add my Tested-by to the patch.
> 
> i've queued it up in tip/x86/oprofile - thanks guys.

I would have thought Robert would take them? He's oprofile
maintainer after all.

> 
> Andi, another issue: your patch had 5 spurious whitespace errors. This 
> is a reoccuring, many years pattern of behavior from you and you need to 
> fix your workflow to send less sloppy patches. 

Yes I forgot you define patch cleanness based on white space.

Seriously, It's actually new -- i did this one in git directly instead of
quilt and git-commit doesn't seem to know how to drop them. In my older quilt
workflow they were always automatically dropped since many years. Both emacs
and vim add them and I don't plan to switch editors, sorry.

> I fixed up the problems of this patch, no need to resend.

I hope you fixed the typos in the commit log too (it really was just
a RFC test patch)

-Andi
