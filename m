Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbXHIUIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbXHIUIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXHIUHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:07:48 -0400
Received: from lazybastard.de ([212.112.238.170]:59381 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXHIUHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:07:47 -0400
Date: Thu, 9 Aug 2007 22:03:42 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 16/18] fs/Kconfig
Message-ID: <20070809200342.GD9036@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org> <20070808162339.GR15319@lazybastard.org> <200708090101.27226.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708090101.27226.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 August 2007 01:01:26 +0200, Arnd Bergmann wrote:
> On Wednesday 08 August 2007, Jörn Engel wrote:
> > +config LOGFS
> > +       bool "Log Filesystem (EXPERIMENTAL)"
> > +       depends on MTD && BLOCK && EXPERIMENTAL
> 
> The dependency on MTD _and_ BLOCK looks correct for your code, but
> not necessary. How about making it 
> 
> 	depends on (MTD || BLOCK) && EXPERIMENTAL
> 
> and allowing to build without the mtd/bdev specific code?

Would be useful, yes.

Jörn

-- 
Data expands to fill the space available for storage.
-- Parkinson's Law
