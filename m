Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYBIRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYBIRia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYBIRiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:38:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYBIRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:38:23 -0500
Date: Sat, 9 Feb 2008 12:38:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] kgdb 2.6.25 version
Message-ID: <20080209173822.GA19519@infradead.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 07:35:06AM -0600, jason.wessel@windriver.com wrote:
> Per reqest on lkml, here are the individual kgdb patches
> targeted at 2.6.25.
> 
> The kgdb tree has been collapsed review.  It includes
> the kgdb core, the x86 arch, the kgdb8250 uart driver
> and the kgdb console sharing driver.
> 
> Since the last time the kgdb patches were posted to LKML
> several months ago, the kgdb core has undergone some
> significant cleanup, as well as the kgdb I/O driver
> interface.
> 
> All the kgdb hooks are initialized dynamically only when a
> kgdb I/O module is configured. When not configured
> kgdb will not exist in any kernel execution path.
> 
> Further comments, questions and patches are certainly
> welcome.

I think this looks a lot nicer than all the kgdb patches I've seen
before.  Of course I'd really love to see support for ethernet using
netpoll and/or firewire eventually, but keeping things simple for
now is good.
