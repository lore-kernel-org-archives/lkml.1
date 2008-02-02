Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYBBPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYBBPjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYBBPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:39:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44334 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762110AbYBBPjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:39:07 -0500
Date: Sat, 2 Feb 2008 16:38:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Massimo Maiurana <maiurana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix target update-po-config in Makefile
Message-ID: <20080202153850.GB24031@uranus.ravnborg.org>
References: <47A488A4.8040107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A488A4.8040107@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 04:13:40PM +0100, Massimo Maiurana wrote:
> Due to recent changes in arch/cris, "make update-po-config" fails
> because it can't include arch/cris/arch as it is a symlink generated
> at build time.
> Patch below fixes this by creating, and then removing at the end, a
> symlink to arch/cris/arch-v10 (should it point to arch-v32? arch-v10
> contains more help messages).
> 
> Signed-off-by: Massimo Maiurana <maiurana@gmail.com>

Hi Massimo.
This is fixed by the cris people recently and will hit
mainline soon.

See: http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/broken-out/cris-avoid-using-arch-links-in-kconfig.patch

So until then we will live with a broken update-po-config.

	Sam
