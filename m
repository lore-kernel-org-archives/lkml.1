Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbYDZNk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbYDZNk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYDZNkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:40:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:42261 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYDZNkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=xzpjhLMabs0JoppLYsjG+vQMALckpvDhd89oFALmIU3utAyk5Ot6ybbP0hHjFnG83OqiTSLcvcReOQeI8iCkGh7mxbBh6GjZwOG0S0MHw7bS1xQfPzTJCiNt9zqr+p9OKFD4b0MTYDfbC5SQHTx2rWZWmIBR+o/itvaWCTLHXlU=
Message-ID: <481330C6.7040109@googlemail.com>
Date: Sat, 26 Apr 2008 15:40:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
References: <20080424225625.GB8717@elte.hu>
In-Reply-To: <20080424225625.GB8717@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Linus, please pull the x86-pat git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-pat.git for-linus
> 
> this adds the second (and final) phase of the x86 PAT changes. Due to 
> generic impact (the drivers/char/mem.c and include/asm-generic/iomap.h 
> changes) this is offered as a separate tree.
> 
> The new CONFIG_NONPROMISC_DEVMEM defaults to disabled so PAT will be 
> disabled, to stay compatible and to be a bit cautious/gradual.
> 

Hi Ingo,

When using an 64bit ( didn't got time to test 32bit now ) kernel[1] with PAT enabled , kvm-intel
does not work anymore. 

When modprobing kvm-intel , kvm is saying VT extension is disable by BIOS which isn't true.
When disabling PAT again ( no changes to BIOS ) kvm-intel works again here.

Is that an known problem ?

If you need more infos just let me know.

Gabriel

[1]  2.6.25-05096-gb1721d0-dirty
     with following patches :
     http://lkml.org/lkml/2008/4/26/37
     http://lkml.org/lkml/2008/4/26/24
     http://lkml.org/lkml/2008/4/25/107


