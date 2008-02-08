Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbYBHKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbYBHKei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933175AbYBHKe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:34:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38163 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbYBHKe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:34:27 -0500
Date: Fri, 8 Feb 2008 10:23:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080208102347.GD21852@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz> <20080207160557.GB28435@flint.arm.linux.org.uk> <20080207202329.GA21949@uranus.ravnborg.org> <1202461453.5469.217.camel@pmac.infradead.org> <20080208094538.GC21852@flint.arm.linux.org.uk> <1202465911.5469.240.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202465911.5469.240.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:18:31AM +0000, David Woodhouse wrote:
> But still, it's HAVE_UNALIGNED_ACCESS which we want to depend on, not a
> newly-invented HAVE_MTD. And there are other places we really ought to
> be depending on HAVE_UNALIGNED_ACCESS too.

That would be misleading though - !CPU_CP15_MMU does not mean we support
unaligned accesses.  It means that we may have no way to support fixing
up unaligned accesses.
