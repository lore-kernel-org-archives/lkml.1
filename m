Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYBPOIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYBPOIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYBPOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:08:22 -0500
Received: from rtr.ca ([76.10.145.34]:1879 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbYBPOIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:08:21 -0500
Message-ID: <47B6EE53.1070101@rtr.ca>
Date: Sat, 16 Feb 2008 09:08:19 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: Spurious completions during NCQ
References: <20080215134658.GB27745@vlad.carfax.org.uk>
In-Reply-To: <20080215134658.GB27745@vlad.carfax.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugo Mills wrote:
>    I'm getting these on my Dell Latitude D830:
> 
> Feb 15 13:06:00 willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
> Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002
> Feb 15 13:06:00 willow kernel: ata1.00: cmd 61/10:10:26:fb:c4/00:00:02:00:00/40 tag 2 cdb 0x0 data 8192 out
> Feb 15 13:06:00 willow kernel:          res 40/00:10:26:fb:c4/00:00:02:00:00/40 Emask 0x2 (HSM violation)
> Feb 15 13:06:00 willow kernel: ata1: soft resetting port
> Feb 15 13:06:00 willow kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Feb 15 13:06:00 willow kernel: ata1.00: configured for UDMA/133
> Feb 15 13:06:00 willow kernel: ata1: EH complete
> Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Write Protect is off
> Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
>    In some cases, there are several cmd/res lines listed. It's
> happening about once an hour or so (not correlated with any other
> event that I can see). It doesn't seem to be affecting operation of
> the machine, but it's making me nervous.
> 
>    Can anyone set my mind at rest? (Or suggest a fix?)
..

Tejun, have the spurious completion fixes been backported
to 2.6.23 / 2.6.22 yet ?  Those kernels will be in common use
for some time to come, and this fix is more or less essential.

???
