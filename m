Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXJYUST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXJYUST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXJYUSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:18:05 -0400
Received: from www.tglx.de ([62.245.132.106]:50405 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXJYUSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:18:01 -0400
Date: Thu, 25 Oct 2007 22:17:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
References: <20071025195644.GA14501@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Thu, 25 Oct 2007, Sam Ravnborg wrote:
> This series kill the old i386 and x86_64 directories.
> The relevant files are moved and adapted and
> Kconfig.debug was consolidated (thanks to Randy).
> 
> I had to modify both the top-lvel Makefile and the kconfig
> Makefile to accomplish this. It was done in such a way that
> it is trivial for other archs to use the same mechanism
> should they have the need.
> 
> To solve the defconfig issue (i386 and x86_64 cannot share one)
> the arch/x86/configs/ directory were introduced. This has
> been used by other archs for some time now but x86 had not had
> the need until now.
> 
> The Kconfig files could be consolidated much more - I only
> did the minimal changes to make it work in the new place.

Thanks for doing this.

I think the last remaining bit to cleanup is the symlink from
arch/x86/boot/bzImage. Now that the old directories are gone it does
not make much sense to keep them alive. Andrew will survive it :)

Please send it Linus wards and feel free to add my Acked-by to all of
them.

Thanks,

	tglx

