Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbXJRPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbXJRPxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXJRPx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:53:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38168 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbXJRPx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:53:26 -0400
Date: Thu, 18 Oct 2007 17:54:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use relative symbolic links for bzImge in x86 ARCHs
Message-ID: <20071018155459.GA20698@uranus.ravnborg.org>
References: <4715F2E5.6000104@panasas.com> <20071017191633.GB11837@uranus.ravnborg.org> <47177C28.5010609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47177C28.5010609@panasas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benny.

> use relative paths in the symlink to bzImage
> to make it NFS export safe.
> 
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>

Your patch looks perfect - but you are a few hours too late.

See:
http://git.kernel.org/?p=linux/kernel/git/tglx/linux-2.6-x86.git;a=commit;h=a0075a509bd955ff6fc6e071efabb926e14bf19c

This is in the mm branch awaiting some more testing
before Thomas push it to Linus.

	Sam
