Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZFUGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZFUGrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZFUGrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 02:47:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44220 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZFUGrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 02:47:05 -0400
Date: Sun, 21 Jun 2009 08:42:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Martin Mares <mj@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org
Subject: Re: RFC: x86: cap iomem_resource to addressable physical memory
Message-ID: <20090621064201.GD1656@ucw.cz>
References: <4A2F0D45.2040602@linux.intel.com> <86802c440906111343g513a2ceau1e2bfdf14c295b2d@mail.gmail.com> <4A316D3C.7080403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A316D3C.7080403@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 13:46:52, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > 
> > do we need do that on every cpu?
> > 
> > looks like we could do that in identify_boot_cpu.
> > 
> 
> What if the CPUs are heterogenous?  It's obviously a suboptimal
> situation, but it doesn't seem like something we can rely on.

Is it ok if that changes during runtime? What if someone hotplugs
heterogenous cpu? I'd say basing it on boot cpu seems simplest.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
