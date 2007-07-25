Return-Path: <linux-kernel-owner+w=401wt.eu-S935365AbXGYSt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935365AbXGYSt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935233AbXGYStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:49:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935141AbXGYStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:49:06 -0400
Date: Wed, 25 Jul 2007 11:48:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707251238.50218.lenb@kernel.org>
Message-ID: <alpine.LFD.0.999.0707251147130.3607@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2007, Len Brown wrote:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> 
> Fixes regressions -- a build failure, an oops, some dmesg spam.
> Also fixes some D-state issues and adds ACPI module auto-loading.
> Yes, I'd hoped to get the last two in before rc1.
> I'm hopeful that a couple-days into rc2 is sufficiently early for them.

I hate pulling this, but I did. However, what I hate even more after 
having done so is that ACPI now seems to select CPU hotplug. Why?

That is just *broken*. Sure, if you select STR or hibernation, we need CPU 
hotplug, but just for picking ACPI? Why?

		Linus
