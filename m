Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbYBHSq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbYBHSq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbYBHSqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:46:49 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45759 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbYBHSqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:46:48 -0500
Date: Fri, 8 Feb 2008 19:46:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080208184651.GA30729@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz> <20080207160557.GB28435@flint.arm.linux.org.uk> <20080207202329.GA21949@uranus.ravnborg.org> <1202461453.5469.217.camel@pmac.infradead.org> <1202468309.5469.248.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202468309.5469.248.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:58:29AM +0000, David Woodhouse wrote:
> On Fri, 2008-02-08 at 09:04 +0000, David Woodhouse wrote:
> > We could add get_unaligned() in certain places in the code, but that
> > isn't ideal for the majority of architectures.
> 
> Actually, we already did that, despite the fact that it isn't optimal.
> So there's no need to omit anything MTD-related from ARM builds whether
> we have alignment fixup support or not.
Just so I do not get you wrong...
What you say above is that the following code:

if ALIGNMENT_TRAP || !CPU_CP15_MMU
source "drivers/mtd/Kconfig"
endif

Here we do not need to have the "if ..."
and can source drivers/mtd/Kconfig unconditional for arm?

	Sam
