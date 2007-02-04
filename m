Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbXBDT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbXBDT1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXBDT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:27:17 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:20642 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbXBDT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:27:16 -0500
Date: Sun, 04 Feb 2007 14:26:59 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
In-reply-to: <45C5AEA5.2040501@tungstengraphics.com>
To: Thomas Hellstr?m <thomas@tungstengraphics.com>
Cc: ebuddington@wesleyan.edu, Dave Airlie <airlied@gmail.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070204192645.GA5169@pool-71-161-131-9.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
 <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com>
 <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net>
 <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com>
 <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net>
 <45C5AEA5.2040501@tungstengraphics.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 11:00:05AM +0100, Thomas Hellstr?m wrote:
> Eric,
> Sorry for the breakage. Can you try the attached patch and see if it 
> fixes the problem.
> 
> /Thomas

Thomas,

Thanks! That seems to fix it:

[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized r128 2.5.0 20030725 on minor 0

-Eric
