Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbYGPN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbYGPN4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYGPN4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:56:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:22518 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYGPN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=v7lXPZIUDbm8BOM/hKHamneR1njN76VXlS7V5wTWKJ1IErQC65d67LMVB5IJC4p830
         oPUM5uTbs22f8kbXv81s21+KnAzDeQ6a6rkYMl9Ay9Y3h7KUEk3YJ50NdwbjTobyp075
         hSsmBX3o596PrWt97J7FCOPpTn0cwU3+M+TTU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] x86 changes for v2.6.27
Date: Wed, 16 Jul 2008 15:52:53 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080714135034.GA7013@elte.hu>
In-Reply-To: <20080714135034.GA7013@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807161552.53427.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 14 July 2008, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/for-linus
> 
> this is our first merge window since we migrated over to a pure Git 
> based patch management setup and integrated x86.git into the -tip tree. 
> Going from Quilt to Git was quite hard for this 
> 1000-patches-per-kernel-cycle tree, so please bear with us :-)

I see that fix patches are no longer folded into the guilty patch
and it makes me a bit worried about kernel bisectability (on which
many people depend on for hunting regressions)...

Random example (amongst many others) of what I mean:

[...]

>       x86: introduce max_low_pfn_mapped for 64-bit
>       x86: max_low_pfn_mapped fix, #1
>       x86: max_low_pfn_mapped fix, #2
>       x86: max_low_pfn_mapped fix, #3

There is also a _ton_ of build fixes which could have been easily
folded into guilty patches.

Could you please consider adding this additional step into your
development process before push to Linus?

Thanks,
Bart
