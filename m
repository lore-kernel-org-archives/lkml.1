Return-Path: <linux-kernel-owner+w=401wt.eu-S934452AbYBHK6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbYBHK6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbYBHK6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:58:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbYBHK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:58:35 -0500
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM
	architecture
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <1202461453.5469.217.camel@pmac.infradead.org>
References: <20080207133805.13f092ff@dilbert.local>
	 <20080207125824.GB7111@infradead.org>
	 <20080207130117.GA18750@uranus.ravnborg.org>
	 <200802071609.36960.openembedded@haerwu.biz>
	 <20080207160557.GB28435@flint.arm.linux.org.uk>
	 <20080207202329.GA21949@uranus.ravnborg.org>
	 <1202461453.5469.217.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:58:29 +0000
Message-Id: <1202468309.5469.248.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 09:04 +0000, David Woodhouse wrote:
> We could add get_unaligned() in certain places in the code, but that
> isn't ideal for the majority of architectures.

Actually, we already did that, despite the fact that it isn't optimal.
So there's no need to omit anything MTD-related from ARM builds whether
we have alignment fixup support or not.

-- 
dwmw2

