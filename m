Return-Path: <linux-kernel-owner+w=401wt.eu-S934391AbYBHKoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbYBHKoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933207AbYBHKnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:43:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46322 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbYBHKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:43:51 -0500
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080208102347.GD21852@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local>
	 <20080207125824.GB7111@infradead.org>
	 <20080207130117.GA18750@uranus.ravnborg.org>
	 <200802071609.36960.openembedded@haerwu.biz>
	 <20080207160557.GB28435@flint.arm.linux.org.uk>
	 <20080207202329.GA21949@uranus.ravnborg.org>
	 <1202461453.5469.217.camel@pmac.infradead.org>
	 <20080208094538.GC21852@flint.arm.linux.org.uk>
	 <1202465911.5469.240.camel@pmac.infradead.org>
	 <20080208102347.GD21852@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:43:42 +0000
Message-Id: <1202467422.5469.245.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 10:23 +0000, Russell King - ARM Linux wrote:
> That would be misleading though - !CPU_CP15_MMU does not mean we
> support unaligned accesses.  It means that we may have no way to
> support fixing up unaligned accesses.

Doesn't that mean you should disallow MTD (or at least 16-bit NOR flash)
if !CPU_CP15_MMU, then? But at the moment you allow it?

-- 
dwmw2

