Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYHSM5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYHSM5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYHSM5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:57:03 -0400
Received: from saeurebad.de ([85.214.36.134]:53653 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYHSM5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:57:00 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
	<48AA1E42.6070802@linux.intel.com>
	<19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com>
	<20080819094905.GA20590@elte.hu> <48AAB8B6.3020802@linux.intel.com>
Date: Tue, 19 Aug 2008 14:56:37 +0200
In-Reply-To: <48AAB8B6.3020802@linux.intel.com> (Andi Kleen's message of "Tue,
	19 Aug 2008 14:12:38 +0200")
Message-ID: <87skt16u4a.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

> Ingo Molnar wrote:
>> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>
>>> This gets rid of the suspend warnings, so it looks to be a step in
>>> the right direction! FWIW, you may add my Tested-by to the patch.
>>
>> i've queued it up in tip/x86/oprofile - thanks guys.
>
> I would have thought Robert would take them? He's oprofile
> maintainer after all.
>
>>
>> Andi, another issue: your patch had 5 spurious whitespace
>> errors. This is a reoccuring, many years pattern of behavior from
>> you and you need to fix your workflow to send less sloppy patches. 
>
> Yes I forgot you define patch cleanness based on white space.
>
> Seriously, It's actually new -- i did this one in git directly instead of
> quilt and git-commit doesn't seem to know how to drop them. In my older quilt
> workflow they were always automatically dropped since many years. Both emacs
> and vim add them and I don't plan to switch editors, sorry.

You probably misconfigured emacs then.  I ran checkpatch over your patch
and don't see how and why emacs would add trailing whitespace after a
opening brace.

You can use this to be on the safe side:

(add-hook 'before-save-hook 'delete-trailing-whitespace)

	Hannes
