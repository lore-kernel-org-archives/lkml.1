Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYBYCIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYBYCIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYBYCIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:08:31 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44968 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBYCIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:08:30 -0500
Date: Mon, 25 Feb 2008 02:08:17 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Samuel Masham <samuel.masham@gmail.com>
Cc: stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: 2.6.24 patches for mips qemu target needed for stable.
Message-ID: <20080225020817.GA23300@linux-mips.org>
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:36:59AM +0900, Samuel Masham wrote:

> Hi Stable team,
> 
> The mips build for qemu (and possibly other targets) crashes when
> doing any irq probe.
> 
> Specifically this happens on boot when brining up the ne driver.
> 
> This is fixed by the following two patches from linus's tree
> 
> 46f4f8f665080900e865392f4b3593be463bf0d8 - IRQ_NOPROBE helper functions
> 24649c00ca334955ac7d8a79f5a7834fc7ea441d - MIPS: Mark all but i8259
> interrupts as no-probe.
> 
> They have no impact on any other architecture so I hope are simple to
> include in the stable tree.

ACK.

  Ralf
