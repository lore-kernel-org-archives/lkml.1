Return-Path: <linux-kernel-owner+w=401wt.eu-S938335AbXG0Xu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938335AbXG0Xu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937983AbXG0XuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:50:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:47610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762431AbXG0XuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:50:09 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Dittmer <jdi@l4x.org>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
References: <200707251238.50218.lenb@kernel.org> <46A98FF9.8060801@l4x.org>
X-Yow: ..  I wonder if I ought to tell them about my PREVIOUS LIFE
 as a COMPLETE STRANGER?
Date: Sat, 28 Jul 2007 01:50:06 +0200
In-Reply-To: <46A98FF9.8060801@l4x.org> (Jan Dittmer's message of "Fri\, 27 Jul
	2007 08\:26\:01 +0200")
Message-ID: <je8x91flu9.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Dittmer <jdi@l4x.org> writes:

> Len Brown wrote:
>> Hi Linus,
>>
>> please pull from: 
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>
> This seems to break ia64 defconfig:
>
>   Building modules, stage 2.
>   MODPOST 157 modules
> FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=144.

Are you cross-compiling?  The definition of kernel_ulong_t won't work on
x86.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
