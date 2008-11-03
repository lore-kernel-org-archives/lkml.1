Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYKCDdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYKCDdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 22:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYKCDdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 22:33:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33504 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbYKCDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 22:33:35 -0500
Date: Sun, 2 Nov 2008 20:33:18 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING in 2.6.27.4 pci-dma::dma_free_coherent, during unload of sym53c8xx_2
Message-ID: <20081103033318.GK24469@parisc-linux.org>
References: <20081103013647.GA27549@merlin.emma.line.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103013647.GA27549@merlin.emma.line.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 02:36:47AM +0100, Matthias Andree wrote:
> Hi,
> 
> I killall -9'ed "taper" because my SCSI hardware was going haywire,
> and tried to rmmod sym53c8xx, and got a nice warning from the kernel -
> shown below.
> 
> [Please Cc: replies, I'm subscribed to linux-kernel@, but not linux-scsi@]
> 
> The machine had been suspended to disk before (via /sys/power/state).
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/pci-dma.c:376 dma_free_coherent+0x80/0x90()

Nothing to worry about.  It's a warning on x86 because it's a bug on
ARM.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
